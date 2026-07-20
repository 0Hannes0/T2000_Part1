= Konzeption
#import "@preview/fletcher:0.5.7": diagram, node, edge, shapes

Dieses Kapitel begründet die zentralen Designentscheidungen des Systems. Es geht dabei nicht darum, das Implementierte zu beschreiben, sondern nachvollziehbar herzuleiten, warum diese Technologien gewählt wurden. Kap.~3.1 gibt den Architekturüberblick, Kap.~3.2 bis 3.4 begründen die drei Technologieentscheidungen (Detektion, Erkennungsmodell, Persistenz), Kap.~3.5 bis 3.7 behandeln Datenschutz, Wirtschaftlichkeit und Nachhaltigkeit. Die Implementierungsdetails folgen in den Kapiteln 4 bis 6.

== Gesamtarchitektur und Systemüberblick

Das System besteht aus vier lose gekoppelten Diensten nach dem Microservice-Prinzip: Jeder Dienst ist unabhängig deploybar, hat klar abgegrenzte Aufgaben und kommuniziert über feste Schnittstellen @dragoni2017microservices[S.~1--3]. So lässt sich eine Komponente --- etwa das Erkennungsmodell oder die Persistenzschicht --- austauschen, ohne den Rest anzufassen. Die Wahrnehmungspipeline des Presence Service baut auf dem quelloffenen MediaPipe-Framework auf, das stellvertretend für den Open-Source-Stack steht @lugaresi2019mediapipe[S.~1--2]. Die vier Dienste sind das Frontend (React, Port 5173), das Backend (FastAPI, Port 8000), der MCP Panel Server (FastMCP, Port 8001) und der Presence Service (Python/MediaPipe, Port 8002).

#figure(
  diagram(
    node-stroke: 0.5pt,
    node-corner-radius: 3pt,
    spacing: (14pt, 22pt),
    node((1,0),  align(center)[*Frontend :5173*\ #text(size:7.5pt)[React 19 · 3D Avatar · VAD · Panels]], width:110pt, name:<fe>),
    node((1,2),  align(center)[*Backend :8000*\ #text(size:7.5pt)[FastAPI · Dialog · STT · Summarize]], width:110pt, name:<be>),
    node((3,2),  align(center)[*MCP Panel :8001*\ #text(size:7.5pt)[map · chart · Aktienkurse · News]], width:100pt, name:<mcp>),
    node((-1,2), align(center)[*Presence :8002*\ #text(size:7.5pt)[BlazeFace · InsightFace · FaceStore]], width:100pt, name:<ps>),
    node((3,4),  align(center)[*SAP AI Core*\ #text(size:7.5pt)[gpt-4o Realtime · Gemini 2.5 Flash · Whisper]], width:110pt, fill:luma(235), name:<ai>),
    node((-1,4), align(center)[*Persistenz*\ #text(size:7.5pt)[Qdrant :6333 (K8s) · SQLite (lokal)]], width:100pt, fill:luma(235), name:<db>),
    edge(<fe>,  <be>,  "<->", label: text(size:7.5pt)[HTTP + WebSocket]),
    edge(<fe>,  <ps>,  "<->", bend: 10deg, label: text(size:7.5pt)[WebSocket :8002]),
    edge(<be>,  <mcp>, "->",  label: text(size:7.5pt)[MCP Tool-Calls]),
    edge(<be>,  <ai>,  "<->", bend: -15deg, label: text(size:7.5pt)[Dialog · STT]),
    edge(<be>,  <db>,  "<->", bend: 15deg,  label: text(size:7.5pt)[RAG · Profile]),
    edge(<mcp>, <ai>,  "->",  label: text(size:7.5pt)[LLM-Calls]),
    edge(<ps>,  <ai>,  "->",  bend: -20deg, label: text(size:7.5pt)[Gaze-Check · Greeting]),
    edge(<ps>,  <db>,  "<->", label: text(size:7.5pt)[Embeddings]),
  ),
  kind: image,
  caption: [Systemarchitektur: vier Microservices mit definierten Kommunikationsschnittstellen],
) <fig:systemarchitektur>

Die drei Hauptdatenflüsse verlaufen über HTTP und WebSocket zwischen Frontend und Backend, über MCP-Tool-Calls zwischen Backend und MCP Panel Server sowie über eine WebSocket-Verbindung zwischen Presence Service und Frontend für Presence-Events.

Der Presence Service ist die Kernkomponente: Er verarbeitet den Kamerastream, führt Gesichtsdetektion, Tracking und Identifikation durch und speichert die Nutzerprofile. SAP AI Core stellt die Sprachmodelle bereit: Das Gespräch --- Spracheingabe und -ausgabe --- läuft über ein Realtime-Sprachmodell (gpt-4o Realtime), Gemini 2.5 Flash übernimmt die Bild- und Textaufgaben (Gaze-Check, Begrüßung, Sitzungszusammenfassung). Ein Whisper-Modell erzeugt zusätzlich ein Transkript der Nutzeräußerung, das den Kontextabruf für das Gesprächsgedächtnis auslöst (vgl.~Kap.~6.2).

Jede erkannte Person wird über eine `PresenceStateMachine` verwaltet, die drei Zustände kennt: _IDLE_ (Person nicht aktiv erkannt), _CANDIDATE_ (Person erkannt, Interaktionsabsicht wird per Gaze-Check geprüft) und _ACTIVE_ (Gaze-Check positiv, Sitzung läuft). Der interne Verarbeitungsfluss --- von der Kamera über Detektion, Tracking und Identifikation bis zum WebSocket-Broadcast an das Frontend --- wird in den Kapiteln 4 und 5 im Detail beschrieben; Kap.~4.3 zeigt den Zustandsautomaten vollständig.

=== Anforderungsanalyse

Die folgende Tabelle fasst die messbaren Systemanforderungen zusammen, gegen die die Designentscheidungen der nächsten Abschnitte geprüft werden:

#figure(
  table(
    columns: (auto, 1fr, auto, 1fr),
    stroke: 0.5pt,
    inset: (x: 6pt, y: 5pt),
    align: (left, left, left, left),
    table.header(
      strong[ID], strong[Anforderung], strong[Zielwert], strong[Erfüllt durch],
    ),
    [A-01], [Embedding-Latenz auf Standard-CPU], [≤ 100~ms], [InsightFace buffalo\_l via ONNX (~80~ms, vgl. Kap.~3.3)],
    [A-02], [Erkennungsgenauigkeit (LFW-Benchmark)], [≥ 99~%], [ArcFace ResNet50: 99,83~% (vgl. Kap.~3.3)],
    [A-03], [Infrastruktur CPU-only, kein GPU-Server], [Hard Constraint], [ONNX Runtime CPUExecutionProvider (vgl. Kap.~3.3)],
    [A-04], [Keine Falschakzeptanz im Betrieb], [keine im Test], [Schwellenwert-Kalibrierung 0,52 (vgl. Kap.~5.1, Kap.~7.1)],
    [A-05], [Sitzungsübergreifender Kontext: wiedererkannter Nutzer erhält relevanten Kontext aus vorheriger Sitzung], [im Betrieb erfüllbar], [Dreikanaliges Gedächtnis + RAG (vgl. Kap.~6)],
  ),
  kind: table,
  caption: [Anforderungsanalyse: Messbare Systemanforderungen vor den Designentscheidungen],
) <tab:anforderungen>

Die Anforderungen A-01 bis A-03 folgen aus den Einsatzbedingungen am Kiosk; A-04 ergänzt die Sicherheitsanforderung, die für biometrische Identifikation im öffentlichen Raum wichtig ist. A-05 hält das eigentliche Kernziel fest --- die sitzungsübergreifende Personalisierung, die einen wiedererkannten Nutzer an den letzten Gesprächsstand anknüpfen lässt (vgl. Kap.~6). Ob jede Anforderung erfüllt wird, weisen die folgenden Entscheidungsabschnitte nach (vgl. Kap.~3.2--3.4).

== Auswahl des Detektionsansatzes

Am Kiosk soll das System nur auf Personen reagieren, die aktiv davor stehen. Wer vorbeigeht oder seitlich zur Kamera steht, darf es nicht auslösen. Die Kamera ist fest verbaut, und ein echter Nutzer nimmt bewusst Blickkontakt zum Gerät auf. Eine Seiten- oder Profilansicht deutet deshalb meist auf einen Passanten hin, nicht auf einen Nutzer. Entscheidend für die Modellwahl ist damit, dass der Detektor bevorzugt Frontalgesichter erkennt.

Die folgende Tabelle vergleicht die evaluierten Detektionsansätze anhand dieser Kriterien:

#figure(
  table(
    columns: (1fr, 1fr, auto, 1fr, auto),
    stroke: 0.5pt,
    inset: (x: 6pt, y: 5pt),
    align: (left, left, left, left, left),
    table.header(
      strong[Ansatz], strong[Erkannte Winkel], strong[CPU-Latenz], strong[Fehlauslösungen], strong[Ergebnis],
    ),
    [MediaPipe BlazeFace], [Nur frontal], [~15–30 ms], [Keine Seitenansichten], [*Gewählt*],
    [YOLO], [Alle Winkel, auch Seitenansichten], [~20–30 ms], [Hintergrundpersonen, Vorbeigehende], [Verworfen],
    [Vision-LLM (Gemini)], [Nicht für kontinuierliche Detektion geeignet], [~1–2 s], [Zu hohe Latenz für Frame-Scanning], [Nicht evaluiert],
  ),
  kind: table,
  caption: [Vergleich evaluierter Gesichtsdetektionsansätze],
) <tab:detektionsvergleich>

YOLO-basierte Detektoren erkennen Gesichter aus allen Winkeln, auch Seitenansichten, und sind damit ungeeignet: In eigenen Tests löste YOLO regelmäßig bei Personen aus, die nur vorbeigingen oder seitlich im Bild standen. MediaPipe BlazeFace ist dagegen als frontaler Detektor ausgelegt, sodass seitlich stehende oder vorbeigehende Personen von vornherein nicht erkannt werden @bazarevsky2019blazeface[S.~2--3]. Mit ca. 15--30 ms CPU-Latenz pro Frame reicht das für Echtzeit-Verarbeitung auf Standard-Hardware ohne GPU @lugaresi2019mediapipe[S.~1--2].

Als zweite Filterschicht prüft ein Vision-LLM (Gemini 2.5 Flash) den Blickkontakt. Die naheliegende Alternative wäre klassische Gaze-Estimation (Schätzung der Blickrichtung), die aber eine Kalibrierungssitzung pro Nutzer voraussetzt @kellnhofer2019gaze360[S.~1--2], @cheng2021gazesurvey[§2, S.~2--4]. An einem öffentlichen Kiosk mit wechselnden, unbekannten Passanten ist das nicht durchführbar --- ohne Kalibrierung verliert das Verfahren unter realen Bedingungen deutlich an Genauigkeit @cheng2021gazesurvey[§1, S.~1--2]. Gemini klassifiziert das Kamerabild dagegen direkt, ohne nutzerspezifische Kalibrierung @yin2024clipgaze[S.~1--3], @radford2021clip[S.~1--3].

== Auswahl des Erkennungsmodells

Das biometrische Erkennungsmodell bestimmt Genauigkeit und Latenz des Identifikationssystems. Die Anforderungen für den Kiosk sind klar: hohe Erkennungsgenauigkeit bei niedriger False-Accept-Rate (Fremde dürfen nicht als bekannte Nutzer durchgehen), CPU-Inferenz ohne GPU-Server, keine Cloud-Abhängigkeit für biometrische Daten und ONNX-Kompatibilität für schlankes Deployment. Diese Kombination schließt viele cloudbasierte oder GPU-abhängige Modelle von vornherein aus.

Die folgende Tabelle stellt die evaluierten Modelle anhand dieser Kriterien gegenüber:

#figure(
  table(
    columns: (1.8fr, auto, auto, 1fr, 1fr),
    stroke: 0.5pt,
    inset: (x: 6pt, y: 5pt),
    align: (left, center, center, left, left),
    table.header(
      strong[Modell], strong[LFW-Gen.], strong[CPU-Latenz], strong[Stack], strong[Ergebnis],
    ),
    [InsightFace buffalo\_l (ArcFace ResNet50)], [*99,83 %*], [*~80 ms*], [ONNX Runtime], [*Gewählt*],
    [InsightFace buffalo\_s (ArcFace MobileNet)], [~99,5 %], [~20 ms], [ONNX Runtime], [Nicht gewählt],
    [DeepFace + ArcFace], [~92 % real\*], [~300 ms], [TensorFlow/Keras], [Verworfen],
    [DeepFace + FaceNet512], [~97 % real\*], [~250 ms], [TensorFlow/Keras], [Verworfen],
    [OpenCV SFace], [~99,3 %], [~10 ms], [ONNX Runtime], [Nicht gewählt],
    [dlib face\_recognition], [99,38 %], [~150 ms], [C++/dlib], [Nicht gewählt],
  ),
  kind: table,
  caption: [Vergleich evaluierter biometrischer Erkennungsmodelle (\* reale Genauigkeit im DeepFace-Framework; eigene Beobachtung)],
) <tab:modellvergleich>

Alle betrachteten Modelle setzen das Embedding-Raumkonzept um (Kap.~2.2.1) --- sie unterscheiden sich nicht im _Was_, sondern im _Wie_: in der Verlustfunktion, mit der sie trainiert wurden, und im Inferenz-Stack, auf dem sie laufen @schroff2015facenet[S.~1--2], @taigman2014deepface[S.~1701--1703].

Ausgangspunkt der Evaluation war das DeepFace-Framework, das eine schnelle erste Integration erlaubte. Im Entwicklungsbetrieb erreichte es unter realen Bedingungen aber nur ca. 92~% Genauigkeit bei ca. 300~ms Latenz pro Embedding und erfüllte die Echtzeit-Anforderung nicht. Das gab den Ausschlag für den Wechsel zu InsightFace buffalo\_l (ArcFace ResNet50): 99,83~% LFW-Genauigkeit bei ca. 80~ms CPU-Latenz (eigene Messung). Der Genauigkeitsvorsprung geht auf die ArcFace-Verlustfunktion zurück (vgl. Kap.~2.2.2) @deng2019arcface[S.~3--5], @guo2019facesurvey[S.~3--5]. Die niedrigere Latenz ist relevant, weil der Presence Service im Takt von 1,0~s scannt (vgl. Kap.~4.1) und das Embedding innerhalb dieses Intervalls fertig sein muss.

Die übrigen Alternativen scheiden entlang derselben zwei Dimensionen aus: buffalo\_s wurde trotz geringerer Latenz verworfen, da schon kleine Genauigkeitseinbußen die False-Accept-Rate erhöhen; die weiteren Modelle liegen in Genauigkeit, Latenz oder beidem unter buffalo\_l (vgl. @tab:modellvergleich). Die Inferenz über ONNX Runtime läuft CPU-optimiert ohne GPU-Server und spart die Latenz von Cloud-Calls pro Frame.

== Auswahl der Persistenzschicht

Die Persistenzschicht speichert die Gesichtsembeddings und das Gesprächsgedächtnis. Ein FaceStore-Interface entkoppelt diese Logik vom Tracking-Code, sodass sich das Backend per Umgebungsvariable wechseln lässt. Drei Lösungen wurden evaluiert:

#figure(
  table(
    columns: (1.5fr, auto, 1fr, 1fr, 1fr),
    stroke: 0.5pt,
    inset: (x: 6pt, y: 5pt),
    align: (left, center, center, left, left),
    table.header(
      strong[Persistenzlösung], strong[K8s-fähig], strong[ANN-Index], strong[Embedding-Dim.], strong[Ergebnis],
    ),
    [Qdrant], [Ja], [HNSW (COSINE)], [512-dim (ArcFace) + 384-dim (RAG)], [*Gewählt*],
    [SAP HANA Cloud Vector Engine], [Ja (Cloud-managed)], [Proprietär], [Flexibel], [Nicht gewählt],
    [SQLite], [Nein (POSIX-Lock)], [Kein ANN-Index], [Beliebig], [Nur lokal],
  ),
  kind: table,
  caption: [Vergleich evaluierter Persistenzlösungen für biometrische Embeddings],
) <tab:persistenzvergleich>

Das FaceStore-ABC gibt allen Backends eine einheitliche Schnittstelle mit `find_profile`, `upsert_profile` und `find_relevant_chunks` vor. Damit hängt der Tracker-Code nur von der abstrakten Schnittstelle ab, nicht von einer konkreten Datenbank (Dependency-Inversion-Prinzip) @martin2017cleanarchitecture[S.~65--70]; der Wechsel zwischen lokaler und Produktiv-Persistenz erfolgt per Umgebungsvariable.

Für die lokale Entwicklung dient SQLite als dateibasiertes Backend ohne Setup. Im Kubernetes-Deployment auf Azure ist SQLite nicht einsetzbar und wird durch Qdrant ersetzt. Als K8s-native Alternative wurde SAP HANA Cloud Vector Engine geprüft, aber nicht gewählt: HANA ist primär relational, deren Vektorsuche als Erweiterung dazugekommen ist --- für einen Fall, der ausschließlich Vektoren speichert und abfragt, ist das mehr Funktionsumfang als nötig. Qdrant ist dagegen von Grund auf dafür gebaut: schlankere Konfiguration, direkt zugänglicher HNSW-Index und in der Praxis erprobt. Die Entscheidung fiel damit nicht gegen SAP-Infrastruktur, sondern für das passende Werkzeug beim Prototyp.

Qdrant ist eine vektornative Datenbank und läuft als Kubernetes-Pod. Sie nutzt zwei Collections: `face_profiles` mit 512-dimensionalen ArcFace-Embeddings für die Identifikation und `conversation_chunks` mit 384-dimensionalen RAG-Embeddings (all-MiniLM-L12-v2) für das Gesprächsgedächtnis. Als Index dient HNSW (Kap.~2.2.1), der die im Live-Betrieb nötige logarithmische Suchkomplexität liefert @malkov2020hnsw[S.~1--2], @johnson2019faiss[S.~1--3]. Die Suchzeit bleibt dadurch auch bei vielen tausend Profilen unkritisch, zumal die Embedding-Berechnung (~80~ms, vgl. Kap.~3.3) die Gesamtlatenz dominiert. Die `conversation_chunks`-Collection dient als Gedächtnis im Sinne des in Kap.~2.3.3 hergeleiteten RAG-Mechanismus @lewis2020rag[S.~4--5], @guu2020realm[S.~1--3]; ihre Nutzung beschreibt Kap.~6.2.

== Datenschutz und biometrische Daten

Gesichtsembeddings sind biometrische Daten im Sinne von Art.~9 Abs.~1 DSGVO, da sie aus einer natürlichen Person abgeleitet werden und zur eindeutigen Identifikation taugen @dsgvo2016[Art.~9 Abs.~1]. Solche Daten besonderer Kategorie unterliegen einem strengen Rechtsrahmen @voigt2017gdpr[S.~114--120], @krivokucahahn2023biometricprotection[S.~639--641].

Das System ist ein interner SAP-Prototyp und wird nicht für Endkunden deployt. Die biometrischen Daten werden ausschließlich im internen Netzwerk verarbeitet: Der Qdrant-Pod läuft im SAP-eigenen Kubernetes-Cluster, und die Embeddings verlassen diesen Cluster nicht. Alle Testpersonen haben eingewilligt.

Für ein reales Kundensystem wären zusätzliche Maßnahmen nötig: ein explizites Opt-in nach Art.~9 Abs.~2 lit.~a DSGVO, das Recht auf Löschung gespeicherter Embeddings nach Art.~17 DSGVO @dsgvo2016[Art.~17] und eine Datenschutz-Folgenabschätzung nach Art.~35 DSGVO @dsgvo2016[Art.~35] @voigt2017gdpr[S.~152--160]. Diese liegen außerhalb des Prototyp-Scopes. Hinzu kommt die gesellschaftliche Akzeptanz: Nutzer akzeptieren biometrische Identifikation eher, wenn Zweck und Datenspeicherung transparent sind @rotter2008biometricacceptance[S.~68--70]. Ein öffentliches Deployment müsste einen transparenten Kamerahinweis und eine klare Opt-out-Möglichkeit früh ins Interface-Design aufnehmen.

== Wirtschaftliche Bewertung

Der lokale Verarbeitungsstack nutzt ausschließlich Open-Source-Komponenten: MediaPipe, InsightFace, ONNX Runtime, Qdrant und FastAPI sind lizenzfrei @lugaresi2019mediapipe[S.~1--2]. Damit fallen für die rechenlastigen Kernfunktionen keine Lizenz- oder GPU-Instanzkosten an. Wichtiger als der reine Kostenpunkt ist dabei, dass die biometrische Identifikation --- die latenzsensibelste Operation --- vollständig lokal läuft und dadurch keine Cloud-Abhängigkeit und keine laufenden API-Kosten pro erkanntem Gesicht entstehen.

SAP AI Core wird nur für drei Aufgaben genutzt: Gaze-Check und Begrüßung über Gemini 2.5 Flash sowie den Dialog über das Realtime-Sprachmodell. Der Gaze-Check läuft höchstens einmal pro vier Sekunden Kandidatensichtbarkeit, die Begrüßung nur bei einem vollständigen ACTIVE-Übergang --- der Verbrauch bleibt damit auch im Dauerbetrieb gering. Die folgende Tabelle schätzt die API-Kosten für einen typischen 8-Stunden-Tag mit 30~Besuchern:

#figure(
  table(
    columns: (1.5fr, auto, auto, 1fr, 1fr, 1fr),
    stroke: 0.5pt,
    inset: (x: 6pt, y: 5pt),
    align: (left, left, left, left, left, left),
    table.header(
      strong[Komponente], strong[Calls/Tag], strong[Calls/Monat],
      strong[Open-Source/ONNX], strong[AWS Rekognition], strong[Azure Face API],
    ),
    [Gaze-Check (Gemini 2.5 Flash)], [~45], [~1.350], [identisch\*], [identisch\*], [identisch\*],
    [Begrüßung (Gemini 2.5 Flash)], [30], [900], [identisch\*], [identisch\*], [identisch\*],
    [Dialog (gpt-4o Realtime)], [90], [2.700], [identisch\*], [identisch\*], [identisch\*],
    [Gesichtserkennung (ArcFace/ONNX)], [30], [900], [*\$0,00*], [~\$0,90], [~\$1,35],
  ),
  kind: table,
  caption: [Geschätzte API-Kosten im 8-Stunden-Kiosk-Betrieb (30~Besucher/Tag). \* Die Sprachmodell-Kosten fallen in allen Szenarien gleich an und werden daher nicht verglichen; verglichen wird nur die biometrische Identifikation. AWS~Rekognition: \$0,001/Bild; Azure~Face~API: \$1,50/1.000~Transaktionen (laut öffentlichem Listenpreis).],
) <tab:kostenvergleich>

In absoluten Zahlen ist die Ersparnis klein: Der Prototyp vermeidet Cloud-API-Kosten von rund \$0,90~(AWS~Rekognition) bzw.~\$1,35~(Azure~Face~API) pro Monat für die biometrische Identifikation. Der eigentliche Vorteil der lokalen Verarbeitung liegt damit nicht in der Ersparnis, sondern im Datenschutz (die Biometrie verlässt das interne Netz nicht, vgl. Kap.~3.5) und darin, dass keine GPU-Hardware nötig ist. Die serverseitige Verarbeitung läuft im bestehenden SAP-Kubernetes-Cluster mit.


== Nachhaltigkeitsaspekte

Ökologisch profitiert das System davon, dass die Inferenz über ONNX Runtime nur auf der CPU des Kiosk-Hosts läuft; ein dedizierter GPU-Server ist nicht nötig (vgl.~Kap.~3.3). Damit entfällt der Energiebedarf für GPU-Instanzen, der bei Cloud-Alternativen den größten Verbrauchsposten ausmacht. Zusätzlich analysiert das System die Kameraframes nicht durchgehend, sondern im Takt von 1,0~s (`FRAME_INTERVAL`, vgl.~Kap.~4.1), was die CPU-Dauerlast deutlich senkt.

Sozial betrifft die Nachhaltigkeit das Risiko demographisch ungleicher Fehlerraten: Gesichtserkennung kann je nach Trainingsdatensatz manche Bevölkerungsgruppen schlechter erkennen @buolamwini2018gendershades[S.~2--7] --- ein Aspekt, den Kap.~7.1 einordnet. Der DSGVO-Rahmen (Art.~9) begrenzt den Einsatz ohnehin auf registrierte, einwilligende Personen (vgl.~Kap.~3.5); für ein öffentliches Deployment wäre eine demographische Audit-Phase Teil des Produktivierungspfads.
