= Biometrische Identifikation und Persistenz
#import "@preview/fletcher:0.5.7": diagram, node, edge, shapes

Dieses Kapitel beschreibt die biometrische Identifikationslogik des entwickelten Systems --- von der Embedding-Berechnung über das zweistufige Tracking bis hin zur persistenten Profilspeicherung mit graduellem Embedding-Blending.
Der Aufbau folgt dem Verarbeitungsfluss: Kap.~5.1 beschreibt die Berechnung des Gesichts-Embeddings via InsightFace und ONNX-Optimierung, Kap.~5.2 das zweistufige Tracking-Verfahren zur Frame-übergreifenden Personenidentifikation inklusive sitzungsinterner Embedding-Stabilisierung, und Kap.~5.3 die Persistenzschicht mit FaceStore-Interface und sitzungsübergreifendem EMA-Blending.
Die Abgrenzung zu Kap.~4 ist klar: Kap.~4 beschrieb die Erkennungs-Pipeline bis zum CANDIDATE→ACTIVE-Übergang; Kap.~5 setzt an dem Punkt an, wo ein aktives Gesicht vorliegt, und beschreibt die biometrische Identifikation dieser Person sowie ihre persistente Erfassung.
Warum InsightFace als Erkennungsmodell gewählt wurde und warum die Persistenzschicht von SQLite auf Qdrant migriert wurde, ist in Kap.~3.3 und Kap.~3.4 ausgeführt --- dieses Kapitel enthält keine Entscheidungsbegründungen, sondern die Implementierungsbeschreibung.

== Biometrische Identifikation mit InsightFace

Die Embedding-Berechnung basiert auf dem InsightFace-Modellpaket buffalo\_l mit folgenden Kennwerten:

#figure(
  table(
    columns: (auto, 1fr),
    stroke: 0.5pt,
    inset: (x: 6pt, y: 5pt),
    align: (left, left),
    table.header(
      strong[Aspekt], strong[Eigenschaft],
    ),
    [Modellpaket], [InsightFace buffalo\_l],
    [Modell], [w600k\_r50 (ArcFace ResNet50, auf WebFace600K trainiert)],
    [Embedding-Dimension], [512],
    [Crop-Größe], [112×112 px],
    [Inference-Backend], [ONNX Runtime (CPUExecutionProvider)],
    [Latenz], [~80 ms pro Embedding-Berechnung],
    [LFW-Genauigkeit], [99,83 %],
  ),
  kind: table,
  caption: [Kennwerte des InsightFace buffalo\_l Erkennungsmodells],
) <tab:insightface-kennwerte>

Sobald der Presence Service ein aktives Gesicht identifiziert hat, beginnt die biometrische Identifikation mit der Berechnung des Gesichts-Embeddings.
Ausgangspunkt ist die Bounding Box, die BlazeFace in Kap.~4.1 für das erkannte Gesicht geliefert hat.
Dieser Bildausschnitt wird in `face_id.py` mit der Methode `_crop_face()` auf 112×112 Pixel skaliert --- die Eingabegröße, die das w600k\_r50-Modell erwartet.

Das Modell berechnet aus diesem Crop via `get_feat()` ein L2-normiertes 512-dimensionales Embedding --- den biometrischen Fingerabdruck der Person im in Kap.~2.2.1 hergeleiteten Embedding-Raum @schroff2015facenet[S.~1], @taigman2014deepface[S.~1]. Als Ähnlichkeitsmaß zwischen zwei Embeddings wird der Kosinus-Score verwendet: Werte nahe 1,0 signalisieren hohe Übereinstimmung; der Schwellenwert `SIMILARITY_THRESHOLD = 0,65` trennt „gleiche Person" von „neue Person".

Das eingesetzte Modell w600k\_r50 --- bereitgestellt über das InsightFace-Framework @guo2021scrfd[S.~1] im buffalo\_l-Modellpaket --- wurde mit ArcFace-Loss @deng2019arcface[S.~3] auf dem WebFace600K-Datensatz @zhu2021webface260m[S.~1] trainiert (Kap.~2.2).

Die Inferenz läuft via ONNX Runtime (optimiertes Laufzeitformat, Auswahl in Kap.~3.3) auf der CPU ohne GPU-Server-Anforderung, was eine Latenz von ~80 ms pro Embedding ermöglicht --- ausreichend für den periodischen Erkennungszyklus mit `FRAME_INTERVAL` = 1,0 s.

Wie die berechneten Embeddings im zweistufigen Tracking-Prozess zur Personenidentifikation eingesetzt werden, beschreibt Kap.~5.2.

== Zweistufiges Tracking und Embedding-Stabilisierung

Das Frame-übergreifende Tracking arbeitet zweistufig und wird durch den folgenden Parameter gesteuert:

#figure(
  table(
    columns: (auto, auto, 1fr),
    stroke: 0.5pt,
    inset: (x: 6pt, y: 5pt),
    align: (left, left, left),
    table.header(
      strong[Parameter], strong[Wert], strong[Bedeutung],
    ),
    [`POSITION_MATCH_RADIUS`], [120 px], [Maximaler Abstand im Original-Frame für Stage-1-Positions-Matching],
  ),
  kind: table,
  caption: [Tracking-Parameter für Stage-1-Positions-Matching],
) <tab:tracking-param>

Der Tracker in `presence/tracker.py` ordnet in jedem Detektionszyklus die neu erkannten Gesichter den bereits bekannten Personen zu.
Dies erfolgt zweistufig, wobei Stage 1 als kostengünstiger Präfilter vor dem ressourcenintensiven Stage 2 dient:

#figure(
  diagram(
    node-stroke: 0.5pt,
    node-corner-radius: 3pt,
    spacing: (10pt, 20pt),
    node((1,0), [Frame mit Gesicht], name: <frame>),
    node((1,1), align(center)[Stage 1:\ Position ≤ 120 px?], shape: shapes.diamond, inset: 8pt, name: <s1>),
    node((0,2), align(center)[Person zugewiesen\ #text(size: 7.5pt)[(kein ArcFace-Call)\ `upsert_profile()` aufgerufen]], width: 110pt, name: <m1>),
    node((2,2), align(center)[Stage 2:\ ArcFace-Score ≥ 0,65?], shape: shapes.diamond, inset: 8pt, name: <s2>),
    node((1,3), align(center)[Person identifiziert\ #text(size: 7.5pt)[`upsert_profile()` aufgerufen]], width: 110pt, name: <m2>),
    node((3,3), align(center)[Neue Person\ #text(size: 7.5pt)[neue PresenceStateMachine]], width: 110pt, name: <new>),
    edge(<frame>, <s1>,  "->"),
    edge(<s1>,    <m1>,  "->", label: text(size: 8pt)[Ja]),
    edge(<s1>,    <s2>,  "->", label: text(size: 8pt)[Nein]),
    edge(<s2>,    <m2>,  "->", label: text(size: 8pt)[Ja]),
    edge(<s2>,    <new>, "->", label: text(size: 8pt)[Nein]),
  ),
  kind: image,
  caption: [Zweistufiger Tracking-Algorithmus: Positions-Präfilter vor ArcFace-Matching],
) <fig:tracking-algorithmus>

*Stage 1 --- Positions-Matching:* Der Mittelpunkt der neuen Detektion wird im Original-Frame-Koordinatensystem mit den zuletzt bekannten Mittelpunkten aller aktiven Personen verglichen.
Liegt der euklidische Abstand innerhalb von `POSITION_MATCH_RADIUS` = 120 px, gilt die Detektion als Treffer und wird dieser Person zugewiesen --- ohne dass ein ArcFace-Embedding berechnet werden muss.
Bei mehreren Trefferkandidaten gewinnt die nächstgelegene Person (closest-first).
Dieser positionsbasierte Ansatz entspricht dem Tracking-by-Detection-Prinzip aus SORT @bewley2016sort[S.~1--3]: Solange eine Person sich zwischen zwei Detektionszyklen um weniger als 120 px bewegt, reicht die Positionsinformation allein für die Zuordnung aus --- ein kosteneffizientes Verfahren, das sich auch für Langzeit-Szenarien eignet @barquero2020longtermtracking[S.~2--3].
Die Koordinaten werden dabei auf den Original-Frame-Maßstab zurückgerechnet, da BlazeFace mit `DETECTION_UPSCALE` = 2,5 arbeitet und die zurückgegebenen Bounding-Box-Koordinaten entsprechend skaliert sind.

*Stage 2 --- ArcFace-Matching:* Nur Detektionen, die Stage 1 keiner bekannten Person zuordnen konnte, durchlaufen die kostspielige Embedding-Berechnung.
Der berechnete Kosinus-Score wird gegen alle gespeicherten Profile verglichen.
Liegt der höchste Score über `SIMILARITY_THRESHOLD`, wird die Detektion der entsprechenden Person zugewiesen; liegt er darunter, wird eine neue `_TrackedPerson` mit einer eigenen `PresenceStateMachine` angelegt.
Diese Kombination aus positionsbasiertem Präfilter und Deep-Appearance-Matching entspricht dem DeepSORT-Muster @wojke2017deepsort[S.~1--3] und ermöglicht robuste Personenzuordnung auch bei temporärer Nicht-Frontalorientierung @barquero2020longtermtracking[S.~3--4].

Nach erfolgreichem Stage-1- oder Stage-2-Match wird `upsert_profile()` aufgerufen (Details in Kap.~5.3).

Innerhalb einer Sitzung stabilisiert der Tracker das Embedding einer Person durch einen kumulativen normalisierten Mittelwert: Frame n trägt das Gewicht 1/n bei (`_running_avg()`), sodass alle bisherigen Frames gleichgewichtet in das Sitzungs-Embedding eingehen.
Kurzzeitige Pose-Änderungen oder schlechte Einzelframes dominieren das Sitzungs-Embedding dadurch nicht.
Das resultierende Sitzungs-Embedding ist stabiler als ein einzelnes Frame-Embedding und bildet die Grundlage für den sitzungsübergreifenden Upsert in Kap.~5.3.

== Qdrant-Persistenz und EMA-Blending

Die Persistenzschicht basiert auf einem abstrakten FaceStore-Interface mit zwei Backends und nutzt folgende Konfiguration:

#figure(
  table(
    columns: (auto, 1fr),
    stroke: 0.5pt,
    inset: (x: 6pt, y: 5pt),
    align: (left, left),
    table.header(
      strong[Aspekt], strong[Eigenschaft],
    ),
    [FaceStore-Typ], [Abstrakte Basisklasse (Strategy-Pattern)],
    [Backend-Auswahl], [ENV-Variable `FACE_STORE_BACKEND`],
    [Verfügbare Implementierungen], [SQLiteFaceStore (lokale Entwicklung) / QdrantFaceStore (Kubernetes-Deployment)],
    [Vektordimensionen (Qdrant)], [512-dim ArcFace-Embeddings / 384-dim RAG-Chunks (vgl. Kap.~6)],
    [Ähnlichkeitsmaß], [Kosinus-Distanz (HNSW-Index, vgl. Kap.~2.2.1)],
  ),
  kind: table,
  caption: [Konfiguration der FaceStore-Persistenzschicht],
) <tab:facestore-config>

Das FaceStore-Interface entkoppelt die Persistenzschicht vom Identifikations-Algorithmus: Über die Umgebungsvariable `FACE_STORE_BACKEND` wählt eine Factory-Funktion zur Laufzeit zwischen `SQLiteFaceStore` und `QdrantFaceStore` --- die Migrationsgründe sind in Kap.~3.4 dokumentiert.

Qdrant nutzt einen HNSW-Index für Kosinus-Ähnlichkeitssuche über die 512-dimensionalen ArcFace-Embeddings (vgl. Kap.~2.2.1 und Kap.~3.4): `find_profile()` gibt das Profil mit dem höchsten Kosinus-Score zurück; liegt dieser Score über `SIMILARITY_THRESHOLD`, gilt die Person als bekannt.
Im System werden zwei Qdrant-Collections genutzt: `face_profiles` für die 512-dimensionalen ArcFace-Embeddings und `conversation_chunks` für die 384-dimensionalen RAG-Embeddings des Gesprächsgedächtnisses. Das RAG-Embedding-Modell (all-MiniLM-L12-v2, lokal) und die Nutzung dieser Collection werden in Kap.~6.2 beschrieben.

Bei jedem Besuch einer bekannten Person wird das gespeicherte Embedding nicht überschrieben, sondern graduell nach der folgenden Formel aktualisiert:

$ bold(e)_"neu" = "normalize"((1-alpha) dot.op bold(e)_"alt" + alpha dot.op bold(e)_"aktuell"), quad alpha = 0","2 $

Mit $alpha = 0","2$ trägt das aktuelle Sitzungs-Embedding 20 % bei, das gespeicherte Langzeit-Embedding 80 %.
Der Wert ist empirisch gewählt als Kompromiss: schnell genug, um echte Veränderungen wie eine neue Frisur über mehrere Besuche einzuarbeiten, aber stabil genug, um einzelne Ausreißer-Frames unter schlechter Beleuchtung abzudämpfen (eigene Beobachtung).
Der Normierungsschritt stellt die L2-Norm wieder her (vgl. Kap.~5.1).
Dieses Exponential Weighted Moving Average-Verfahren @gardner2006exponentialsmoothing[§2--3] sorgt dafür, dass das gespeicherte Profil einer Person über mehrere Besuche hinweg stabil bleibt und sich gleichzeitig an veränderte Bedingungen wie unterschiedliche Beleuchtung oder Winkeländerungen graduell anpasst --- eine Eigenschaft, die für sitzungsübergreifendes Langzeit-Tracking essenziell ist @barquero2020longtermtracking[S.~4--5].

Zusammen mit dem Embedding speichert `upsert_profile()` bei jedem Besuch auch Metadaten: `visit_count`, `last_seen` und einen beliebigen `metadata`-Payload.
Diese Metadaten ermöglichen es der Begrüßungslogik in Kap.~6.1, zwischen einem Erstbesuch und einer wiederkehrenden Person zu unterscheiden und die Begrüßung entsprechend anzupassen.

Kap.~6 beschreibt, wie der FaceStore neben den Gesichts-Embeddings auch Gesprächs-Chunks für die RAG-basierte Personalisierung speichert und abruft.
