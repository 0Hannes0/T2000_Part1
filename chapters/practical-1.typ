= Biometrische Identifikation und Persistenz
#import "@preview/fletcher:0.5.7": diagram, node, edge, shapes

Dieses Kapitel beschreibt, wie das System ein erkanntes Gesicht identifiziert und über mehrere Besuche hinweg speichert.
Es setzt dort an, wo Kap.~4 aufhört: Ein aktives Gesicht liegt bereits vor.
Der Aufbau folgt dem Verarbeitungsfluss --- Kap.~5.1 berechnet das Gesichts-Embedding, Kap.~5.2 ordnet es über ein zweistufiges Tracking einer Person zu, und Kap.~5.3 speichert es dauerhaft und aktualisiert es bei jedem Besuch.
Die Begründungen zur Modell- und Persistenzwahl stehen in Kap.~3.3 und Kap.~3.4.

== Biometrische Identifikation mit InsightFace

Die Embedding-Berechnung nutzt das InsightFace-Modellpaket buffalo\_l mit dem Modell w600k\_r50 (ArcFace ResNet50): 512-dimensionale Embeddings aus einem 112×112-px-Crop, berechnet über die ONNX Runtime (CPU) in ~80 ms, bei einer LFW-Genauigkeit von 99,83 % und `SIMILARITY_THRESHOLD` = 0,52 (vollständige Kennwerte siehe Anhang A2).

Sobald der Presence Service ein aktives Gesicht identifiziert hat, beginnt die Identifikation mit der Embedding-Berechnung.
Ausgangspunkt ist die Bounding Box aus Kap.~4.1.
Dieser Bildausschnitt wird in `face_id.py` auf 112×112 Pixel skaliert --- die Eingabegröße, die das w600k\_r50-Modell erwartet.

Aus diesem Crop berechnet das Modell ein L2-normiertes, 512-dimensionales Embedding --- den biometrischen Fingerabdruck der Person im Embedding-Raum aus Kap.~2.2.1 @schroff2015facenet[S.~1], @taigman2014deepface[S.~1]. Als Ähnlichkeitsmaß dient der Kosinus-Score (Werte nahe 1,0 = hohe Übereinstimmung); der Schwellenwert `SIMILARITY_THRESHOLD` trennt „gleiche Person" von „neue Person".

Den Schwellenwert habe ich iterativ kalibriert. Startpunkt war der Literaturwert 0,65 für ArcFace-Verifikation @deng2019arcface[S.~4--5]. Bei konstanter Beleuchtung liegen die Kosinus-Scores echter Wiedererkennungen typischerweise bei 0,72--0,85; ändert sich Licht oder Aussehen (z.~B. eine neue Brille), fallen sie auf 0,53--0,58. Mit 0,65 werden solche legitimen Wiedererkennungen fälschlich als neue Person gewertet. Eine eigene Messreihe bestätigte das und führte zur Absenkung auf 0,52 --- die konkreten Erkennungsraten stehen in Kap.~7.3.

Das Modell w600k\_r50 wurde mit ArcFace-Loss auf einem großen Gesichtsdatensatz trainiert (Details in Kap.~2.2) @deng2019arcface[S.~3]. Die Inferenz läuft über die ONNX Runtime (Auswahl in Kap.~3.3) auf der CPU, ohne GPU-Server --- ~80 ms pro Embedding, schnell genug für den Erkennungszyklus mit `FRAME_INTERVAL` = 1,0 s.

== Zweistufiges Tracking und Embedding-Stabilisierung

Der Tracker in `presence/tracker.py` ordnet in jedem Detektionszyklus die neu erkannten Gesichter den bereits bekannten Personen zu.
Das geschieht zweistufig: Stage 1 ist ein günstiger Vorfilter, Stage 2 die teurere Embedding-Berechnung. @fig:tracking-algorithmus zeigt den Ablauf:

#figure(
  diagram(
    node-stroke: 0.5pt,
    node-corner-radius: 3pt,
    spacing: (10pt, 20pt),
    node((1,0), [Frame mit Gesicht], name: <frame>),
    node((1,1), align(center)[Stage 1:\ Position ≤ 120 px?], shape: shapes.diamond, inset: 8pt, name: <s1>),
    node((0,2), align(center)[Person zugewiesen\ #text(size: 7.5pt)[(kein ArcFace-Call)\ `upsert_profile()` aufgerufen]], width: 110pt, name: <m1>),
    node((2,2), align(center)[Stage 2:\ ArcFace-Score ≥ 0,52?], shape: shapes.diamond, inset: 8pt, name: <s2>),
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

*Stage 1 --- Positions-Matching:* Der Mittelpunkt der neuen Detektion wird mit den zuletzt bekannten Mittelpunkten aller aktiven Personen verglichen. Liegt der Abstand innerhalb von `POSITION_MATCH_RADIUS` (120 px), gilt die Detektion als Treffer und wird dieser Person zugewiesen --- ganz ohne ArcFace-Embedding; bei mehreren Kandidaten gewinnt die nächstgelegene Person. Das setzt das Tracking-Prinzip aus Kap.~4.3 (SORT @bewley2016sort[S.~1--3]) um. Die Koordinaten werden dabei auf den Original-Frame zurückgerechnet, da BlazeFace mit `DETECTION_UPSCALE` = 2,5 arbeitet.

*Stage 2 --- ArcFace-Matching:* Nur Detektionen ohne Stage-1-Treffer durchlaufen die Embedding-Berechnung. Der Kosinus-Score wird gegen alle gespeicherten Profile verglichen. Liegt der höchste Score über `SIMILARITY_THRESHOLD`, wird die Detektion der Person zugewiesen; liegt er darunter, entsteht eine neue `_TrackedPerson` mit eigener `PresenceStateMachine`. Diese Kombination aus Positions-Vorfilter und Embedding-Vergleich entspricht dem DeepSORT-Muster @wojke2017deepsort[S.~1--3] und ordnet Personen auch dann zuverlässig zu, wenn sie kurz zur Seite blicken @barquero2020longtermtracking[S.~3--4]. Nach einem Treffer in Stage 1 oder Stage 2 wird `upsert_profile()` aufgerufen (Details in Kap.~5.3).

Innerhalb einer Sitzung stabilisiert der Tracker das Embedding einer Person durch einen laufenden Mittelwert: Frame n trägt mit dem Gewicht 1/n bei (`_running_avg()`), sodass einzelne schlechte Frames das Sitzungs-Embedding nicht dominieren. Dieses stabilere Embedding ist die Grundlage für den sitzungsübergreifenden Upsert in Kap.~5.3.

== Qdrant-Persistenz und EMA-Blending

Die Persistenzschicht basiert auf einem abstrakten FaceStore-Interface (Strategy-Pattern) mit zwei Backends, deren Auswahl per ENV-Variable `FACE_STORE_BACKEND` erfolgt: `SQLiteFaceStore` für die lokale Entwicklung und `QdrantFaceStore` für das Kubernetes-Deployment (Konfigurationsdetails siehe Anhang A2).

Das FaceStore-Interface trennt die Persistenz vom Identifikations-Algorithmus (Begründung vgl. Kap.~3.4): Über `FACE_STORE_BACKEND` wählt eine Factory zur Laufzeit zwischen `SQLiteFaceStore` und `QdrantFaceStore`. Qdrant sucht per HNSW-Index nach der ähnlichsten Person; liegt deren Kosinus-Score über `SIMILARITY_THRESHOLD`, gilt die Person als bekannt. Die `conversation_chunks`-Collection für die RAG-Embeddings wird in Kap.~6.2 beschrieben.

Bei jedem Besuch einer bekannten Person steht man vor einem Zielkonflikt.
Ein festes, nie verändertes Template veraltet mit der Zeit: Ändert sich das Aussehen durch Licht, Frisur oder Alterung, sinken die Kosinus-Scores und die Person wird irgendwann fälschlich abgewiesen. Das Embedding einfach mit dem neuesten zu überschreiben, hat das umgekehrte Problem: Ein einziger schlechter Frame kann das Profil dauerhaft verschlechtern. Deshalb wird das gespeicherte Embedding nicht überschrieben, sondern bei jedem Besuch graduell aktualisiert:

$ bold(e)_"neu" = "normalize"((1-alpha) dot.op bold(e)_"alt" + alpha dot.op bold(e)_"aktuell"), quad alpha = 0","2 $

Der Faktor $alpha$ steuert, wie stark der aktuelle Besuch das gespeicherte Profil verändert. Ich habe ihn empirisch bestimmt. Zuerst lag die Wahl bei $alpha = 0","5$, also gleiches Gewicht für Alt und Neu. Im Testbetrieb bekamen dadurch einzelne schlechte Frames zu viel Einfluss und die Erkennungsscores sanken bei Folgebesuchen. Mit $alpha = 0","2$ zählt das gespeicherte Langzeit-Embedding zu 80 % und der aktuelle Besuch nur zu 20 %. Das balanciert beide Anforderungen: stabil gegenüber einzelnen Ausreißern, aber offen für echte Veränderungen (neue Frisur, Brille) über mehrere Besuche --- der Einfluss eines Besuchs sinkt nach fünf weiteren auf $(0{,}8)^5 approx 33~%$ (eigene Beobachtung). Der Normierungsschritt stellt anschließend die L2-Norm wieder her (vgl. Kap.~5.1). Dieses Vorgehen entspricht dem etablierten Exponential-Weighted-Moving-Average-Prinzip adaptiver Erscheinungsmodelle @dewan2016adaptiveappearance[S.~129--131], @gardner2006exponentialsmoothing[§2--3].

Zusammen mit dem Embedding speichert `upsert_profile()` bei jedem Besuch auch Metadaten (`visit_count`, `last_seen` und einen `metadata`-Payload). Diese ermöglichen es der Begrüßungslogik in Kap.~6.1, zwischen Erstbesuch und wiederkehrender Person zu unterscheiden.



