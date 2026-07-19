= Konzeption
#import "@preview/fletcher:0.5.7": diagram, node, edge, shapes

Dieses Kapitel begründet die zentralen Designentscheidungen des entwickelten Systems und legt damit das konzeptionelle Fundament für die Implementierungsbeschreibung der folgenden Kapitel. Im Vordergrund steht nicht die Beschreibung des Implementierten, sondern die nachvollziehbare Herleitung, warum genau diese Technologien und Architekturentscheidungen getroffen wurden. Kap.~3.1 gibt einen Überblick über die Gesamtarchitektur, Kap.~3.2 bis 3.4 begründen die drei zentralen Technologieentscheidungen (Detektionsansatz, Erkennungsmodell, Persistenzschicht), Kap.~3.5 und 3.6 behandeln mit Datenschutz und Wirtschaftlichkeit zwei querschnittliche Aspekte. Die Implementierungsdetails der einzelnen Komponenten folgen in den Kapiteln 4 bis 6.

== Gesamtarchitektur und Systemüberblick

Das entwickelte System besteht aus vier lose gekoppelten Diensten, die das Microservice-Prinzip umsetzen: Jeder Dienst ist unabhängig deploybar, hat klar abgegrenzte Verantwortlichkeiten und kommuniziert über definierte Schnittstellen @dragoni2017microservices[S.~1--3]. Diese Architekturentscheidung ermöglicht es, einzelne Komponenten --- etwa das Erkennungsmodell oder die Persistenzschicht --- unabhängig auszutauschen, ohne den restlichen Systemstack zu verändern. Das quelloffene MediaPipe-Framework ist dabei Grundlage für die Wahrnehmungs- und Verarbeitungspipeline (perception pipeline) des Presence Service und steht exemplarisch für den Open-Source-orientierten Stack @lugaresi2019mediapipe[S.~1--2]. Die vier Services sind: das Frontend (React, Port 5173), das Backend (FastAPI, Port 8000), der MCP Panel Server (FastMCP, Port 8001) und der Presence Service (Python/MediaPipe, Port 8002).

#figure(
  diagram(
    node-stroke: 0.5pt,
    node-corner-radius: 3pt,
    spacing: (14pt, 22pt),
    node((1,0),  align(center)[*Frontend :5173*\ #text(size:7.5pt)[React 19 · 3D Avatar · VAD · Panels]], width:110pt, name:<fe>),
    node((1,2),  align(center)[*Backend :8000*\ #text(size:7.5pt)[FastAPI · STT · Chat · TTS · Summarize]], width:110pt, name:<be>),
    node((3,2),  align(center)[*MCP Panel :8001*\ #text(size:7.5pt)[map · chart · Aktienkurse · News]], width:100pt, name:<mcp>),
    node((-1,2), align(center)[*Presence :8002*\ #text(size:7.5pt)[BlazeFace · InsightFace · FaceStore]], width:100pt, name:<ps>),
    node((3,4),  align(center)[*SAP AI Core*\ #text(size:7.5pt)[Gemini 2.5 Flash · Kokoro TTS]], width:100pt, fill:luma(235), name:<ai>),
    node((-1,4), align(center)[*Persistenz*\ #text(size:7.5pt)[Qdrant :6333 (K8s) · SQLite (lokal)]], width:100pt, fill:luma(235), name:<db>),
    edge(<fe>,  <be>,  "<->", label: text(size:7.5pt)[HTTP + WebSocket]),
    edge(<fe>,  <ps>,  "<->", bend: 10deg, label: text(size:7.5pt)[WebSocket :8002]),
    edge(<be>,  <mcp>, "->",  label: text(size:7.5pt)[MCP Tool-Calls]),
    edge(<be>,  <ai>,  "<->", bend: -15deg, label: text(size:7.5pt)[Chat · STT · TTS]),
    edge(<be>,  <db>,  "<->", bend: 15deg,  label: text(size:7.5pt)[RAG · Profile]),
    edge(<mcp>, <ai>,  "->",  label: text(size:7.5pt)[LLM-Calls]),
    edge(<ps>,  <ai>,  "->",  bend: -20deg, label: text(size:7.5pt)[Gaze-Check · Greeting]),
    edge(<ps>,  <db>,  "<->", label: text(size:7.5pt)[Embeddings]),
  ),
  kind: image,
  caption: [Systemarchitektur: vier Microservices mit definierten Kommunikationsschnittstellen],
) <fig:systemarchitektur>

Die drei Hauptdatenflüsse des Systems verlaufen über HTTP und WebSocket zwischen Frontend und Backend, über MCP-Tool-Calls zwischen Backend und MCP Panel Server sowie über eine dedizierte WebSocket-Verbindung zwischen Presence Service und Frontend für Presence-Events.

Der Presence Service bildet die Kernkomponente des Systems: Er verarbeitet den Kamerastream, führt Gesichtsdetektion, Tracking und biometrische Identifikation durch und persistiert Nutzerprofile. SAP AI Core dient als LLM-Infrastruktur für die Kerndienste des Systems: Gemini 2.5 Flash übernimmt Gaze-Check, Begrüßungsgenerierung und LLM-Chat.

Die Zustandsverwaltung jeder erkannten Person wird durch eine `PresenceStateMachine` modelliert, die drei Zustände kennt: _IDLE_ (Person nicht aktiv erkannt), _CANDIDATE_ (Person erkannt, Interaktionsabsicht wird durch den Gaze-Check geprüft) und _ACTIVE_ (Gaze-Check positiv, Sitzung läuft). Kap.~4.3 beschreibt den Zustandsautomaten vollständig.

#figure(
  diagram(
    node-stroke: 0.5pt,
    node-corner-radius: 3pt,
    spacing: (10pt, 18pt),
    node((0,0), [Kamera], name:<cam>),
    node((0,1), align(center)[MediaPipe BlazeFace\ #text(size:7.5pt)[Bounding Boxes]], width:130pt, name:<det>),
    node((0,2), align(center)[PersonTracker\ #text(size:7.5pt)[Stage 1: Position · Stage 2: ArcFace]], width:140pt, name:<tr>),
    node((0,3), align(center)[PresenceStateMachine\ #text(size:7.5pt)[IDLE → CANDIDATE → ACTIVE]], width:140pt, name:<sm>),
    node((-2,4), align(center)[Gaze-Check\ #text(size:7.5pt)[Gemini 2.5 Flash]], width:90pt, name:<gz>),
    node((0,4),  align(center)[Face-ID\ #text(size:7.5pt)[InsightFace buffalo\_l]], width:90pt, name:<fid>),
    node((2,4),  align(center)[Greeting-Gen\ #text(size:7.5pt)[Gemini 2.5 Flash]], width:90pt, name:<gr>),
    node((0,5),  align(center)[FaceStore (Interface)\ #text(size:7.5pt)[SQLite (lokal) · Qdrant (K8s)]], width:140pt, name:<fs>),
    node((0,6),  align(center)[WebSocket Broadcast\ #text(size:7.5pt)[person\_arrived · group\_arrived · person\_left]], width:150pt, name:<ws>),
    node((0,7),  align(center)[Frontend\ #text(size:7.5pt)[usePresence.js]], width:100pt, name:<fend>),
    edge(<cam>, <det>, "->"),
    edge(<det>, <tr>,  "->"),
    edge(<tr>,  <sm>,  "->"),
    edge(<sm>,  <gz>,  "->", label: text(size:7pt)[parallel]),
    edge(<sm>,  <fid>, "->"),
    edge(<sm>,  <gr>,  "->"),
    edge(<fid>, <fs>,  "->"),
    edge(<gz>,  <ws>,  "->", bend:-30deg, label: text(size:7pt)[true → ACTIVE]),
    edge(<fs>,  <ws>,  "->"),
    edge(<ws>,  <fend>,"->"),
  ),
  kind: image,
  caption: [Interne Verarbeitungspipeline des Presence Service],
) <fig:presence-pipeline>

=== Anforderungsanalyse

Die folgende Tabelle fasst die messbaren Systemanforderungen zusammen, gegen die die
Designentscheidungen in den nachfolgenden Abschnitten geprüft werden:

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
    [A-04], [False-Accept-Rate im Betrieb], [= 0], [Schwellenwert-Kalibrierung 0,52 (vgl. Kap.~5.1, Kap.~7.1)],
  ),
  kind: table,
  caption: [Anforderungsanalyse: Messbare Systemanforderungen vor den Designentscheidungen],
) <tab:anforderungen>

Die Anforderungen A-01 bis A-03 sind aus den Einsatzbedingungen des Kiosk-Kontexts
abgeleitet; A-04 ergänzt die Sicherheitsanforderung, die für biometrische Identifikation
im öffentlichen Raum relevant ist. Die Erfüllung jeder Anforderung wird in den
jeweiligen Entscheidungsabschnitten (vgl. Kap.~3.2--3.4) nachgewiesen.

== Auswahl des Detektionsansatzes

Die Anforderungen an die Gesichtsdetektion im öffentlichen Kiosk-Kontext bestimmen die Modellwahl: Erkannt werden sollen ausschließlich Personen, die aktiv mit dem System interagieren --- Personen, die vorbeigehen oder sich seitlich zur Kamera befinden, dürfen das System nicht auslösen.

Diese Anforderung rückt die Frontalorientierung des Detektors in den Vordergrund. Ein System, das im öffentlichen Raum installiert ist, hat eine feste Kameraposition und interagiert nur mit Personen, die direkt vor dem Kiosk stehen und bewusst Blickkontakt zum Gerät aufnehmen. Seitenansichten und Profilperspektiven sind im Normalfall ein Indikator für Passanten, nicht für aktive Nutzer.

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

YOLO-basierte Detektoren erkennen Gesichter aus allen Winkeln einschließlich Seitenansichten und sind daher für diesen Anwendungsfall ungeeignet: Interne Tests zeigten, dass YOLO regelmäßig Personen detektierte, die lediglich am Kiosk vorbeigingen oder sich seitlich im Sichtfeld befanden, ohne die Absicht einer Interaktion. Diese Eigenschaft führte zu ungewollten Trigger-Events und beeinträchtigte die Nutzungserfahrung erheblich.

MediaPipe BlazeFace ist als frontaler Einzelpersonen-Detektor konzipiert: Das Anchor-Schema ist explizit auf Frontalgesichter ausgelegt, was für den Kiosk-Einsatz ein Vorteil ist --- Personen, die seitlich stehen oder vorbeigehen, werden so von vornherein nicht erkannt @bazarevsky2019blazeface[S.~2--3]. MediaPipe stellt dabei das quelloffene Inferenz-Framework bereit, in das BlazeFace als eingebettete Komponente integriert ist @lugaresi2019mediapipe[S.~1--2]. Mit einer CPU-Latenz von ca. 15--30 ms pro Frame ermöglicht BlazeFace Echtzeit-Verarbeitung auf Standard-Hardware ohne GPU-Anforderung.

Als zweite Filterschicht wird Blickkontakt per Vision-LLM (Gemini 2.5 Flash) validiert, um auch frontal detektierte, aber nicht aktiv interagierende Personen herauszufiltern. Gemini klassifiziert Bilder direkt ohne benutzerspezifische Kalibrierung --- für einen öffentlichen Kiosk mit wechselnden Personen ist das entscheidend, da klassische Gaze-Estimation ohne individuelle Kalibrierungsstufe unter realen Bedingungen erheblich an Genauigkeit verliert @cheng2021gazesurvey[§1, S.~1--2], @radford2021clip[S.~1--3].

Das naive Alternativvorgehen wäre der Einsatz klassischer Gaze-Estimation mit geometrischem 3D-Kopfposen-Modell und individueller Kalibrierungssitzung pro Nutzer gewesen --- ein Verfahren, das nach dem Muster der Gaze360-Klasse benutzerspezifische Parameter durch eine geführte Blickfolge-Sequenz einmisst @kellnhofer2019gaze360[S.~1--2], @cheng2021gazesurvey[§2, S.~2--4]. Dieser Ansatz setzt voraus, dass Nutzer bekannt und kooperativ sind und eine Kalibrierungssitzung absolvieren; an einem öffentlichen Kiosk mit wechselnden, unbekannten Passanten ist kein solcher Schritt durchführbar --- klassische Gaze-Estimation ist dort strukturell nicht einsetzbar. Der Vision-LLM-Ansatz (Gemini 2.5 Flash) umgeht dieses Problem vollständig: Er liefert zero-shot Blickkontakterkennung ohne jeden Kalibrierungsaufwand und ohne nutzerspezifische Vorarbeit @yin2024clipgaze[S.~1--3] --- genau darin liegt der Kreativitätsmehrwert der gewählten Lösung gegenüber dem naiven Standardvorgehen.

== Auswahl des Erkennungsmodells

Die Wahl des biometrischen Erkennungsmodells bestimmt Genauigkeit und Latenz des gesamten Identifikationssystems.

Die Anforderungen für den Kiosk-Einsatz sind klar definiert: hohe Erkennungsgenauigkeit bei niedriger False-Accept-Rate, CPU-Inferenz ohne GPU-Server, keine Cloud-Abhängigkeit für biometrische Daten sowie ONNX-Kompatibilität für ressourceneffizientes Edge-Deployment. Diese Kombination schließt viele cloudbasierte oder GPU-abhängige Alternativen von vornherein aus.

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

Alle betrachteten Modelle setzen das Embedding-Raumkonzept um (Kap.~2.2.1) --- sie unterscheiden sich nicht im _Was_, sondern im _Wie_: in der Verlustfunktion, mit der das Embedding-Modell trainiert wurde, und im Inferenz-Stack, auf dem es ausgeführt wird. Die Auswahl entscheidet sich entlang dieser beiden Dimensionen @schroff2015facenet[S.~1--2], @taigman2014deepface[S.~1701--1703].

InsightFace buffalo\_l (ArcFace ResNet50) erreicht 99,83 % LFW-Genauigkeit bei ca. 80 ms CPU-Latenz (eigene Messung). Der Genauigkeitsvorsprung gegenüber Alternativen geht auf die ArcFace-Verlustfunktion zurück, deren Wirkung in Kap.~2.2.2 hergeleitet ist und im LFW-Benchmark messbar bleibt @deng2019arcface[S.~3--5], @guo2019facesurvey[S.~3--5]. Wrapper-Lösungen wie das DeepFace-Framework erreichen unter realen Bedingungen nur ca. 92 % Genauigkeit bei ca. 300 ms Latenz.\* Der Latenzunterschied von Faktor 3,75 ist für Echtzeit-Personenerkennung entscheidend.

Die verworfenen Alternativen scheiden entlang derselben beiden Dimensionen aus: InsightFace buffalo\_s wurde trotz geringerer Latenz (~20 ms) verworfen, da bei biometrischer Identifikation auch kleine Genauigkeitseinbußen die False-Accept-Rate erhöhen --- d.~h. Fremde würden fälschlich als bekannte Nutzer erkannt. Die übrigen Alternativen liegen in Genauigkeit, Latenz oder beidem unter buffalo\_l (vgl. Tabelle~3.2).

Ausgangspunkt der Evaluation war das DeepFace-Framework, das als etablierte Python-Bibliothek eine schnelle erste Integration ermöglichte. Im Entwicklungsbetrieb zeigte sich, dass DeepFace unter realen Bedingungen nur ca. 92 % Erkennungsgenauigkeit erreichte und mit ca. 300 ms Latenz pro Embedding die Zielanforderung an Echtzeit-Verarbeitung nicht erfüllte. Diese Beobachtung führte zur Entscheidung, das Erkennungsmodell zu wechseln: InsightFace buffalo\_l wurde eingesetzt und erfüllte beide Kriterien --- 99,83 % LFW-Genauigkeit bei ca. 80 ms CPU-Latenz.

Die Inferenz via ONNX Runtime liefert CPU-optimierte Verarbeitung ohne GPU-Server. Dies eliminiert sowohl die Infrastrukturkosten für dedizierte GPU-Instanzen als auch die Latenz durch Cloud-Calls für jeden Frame --- eine direkte Konsequenz der ONNX-Kompatibilität von InsightFace buffalo\_l.

== Auswahl der Persistenzschicht

Das FaceStore-Interface-Design entkoppelt die Persistenzlogik vom Tracking-Code und ermöglicht den Wechsel zwischen Backends per Umgebungsvariable. Drei Persistenzlösungen wurden evaluiert:

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

Das FaceStore-ABC definiert eine einheitliche Schnittstelle mit den Methoden `find_profile`, `upsert_profile` und `find_relevant_chunks` für alle Persistenz-Backends. Diese Entwurfsentscheidung setzt das Dependency-Inversion-Prinzip um: Der Tracker-Code hängt von der abstrakten Schnittstelle ab, nicht von einer konkreten Implementierung @martin2017cleanarchitecture[S.~65--70]. Der Wechsel zwischen lokaler und Produktiv-Persistenz erfolgt damit transparent per Umgebungsvariable, ohne Umbau des Tracker-Codes.

Für die lokale Entwicklung wird SQLite als dateibasiertes Backend eingesetzt --- ohne Setup-Overhead und ohne laufende externe Services. Im Kubernetes-Deployment auf Azure ist SQLite nicht einsetzbar und wird durch Qdrant ersetzt. SAP HANA Cloud Vector Engine wurde als K8s-native Alternative evaluiert, schied jedoch aus: HANA ist primär eine relationale Datenbank, deren Vektorsuchfunktion als Erweiterung dazugekommen ist --- für einen Anwendungsfall, der ausschließlich Vektoren speichert und abfragt, ist das ein unnötiger Overhead. Qdrant hingegen ist von Grund auf für genau diesen Zweck gebaut: Die Konfiguration ist schlanker, der HNSW-Index direkt zugänglich, und das System war in der Praxis bereits erprobt. Die Entscheidung fiel damit nicht gegen SAP-Infrastruktur, sondern für das spezialisierte Werkzeug --- bei einem Prototyp mit klarem Fokus auf Vektorretrieval ist das der relevante Unterschied.

Qdrant ist eine vektornative Datenbank, die als Kubernetes-Pod ohne Dateisystem-Lock-Probleme betrieben wird. Im System werden zwei Collections genutzt: `face_profiles` mit 512-dimensionalen ArcFace-Embeddings für die Gesichtsidentifikation und `conversation_chunks` mit 384-dimensionalen RAG-Embeddings (all-MiniLM-L12-v2) für das Gesprächsgedächtnis. Als Index-Algorithmus verwendet Qdrant HNSW (Kap.~2.2.1), der die für den Live-Betrieb erforderliche logarithmische Suchkomplexität liefert @malkov2020hnsw[S.~1--2], @johnson2019faiss[S.~1--3]. Für das konkrete Einsatzszenario bedeutet dies: Selbst bei 10.000 registrierten Profilen wächst die Suchzeit lediglich um den Faktor log(10.000)/log(10) ≈ 4 gegenüber dem aktuellen Testbetrieb mit ~10 Profilen --- bei 100.000 Profilen entsprechend um den Faktor ~5. Da die biometrische Embedding-Berechnung (~80 ms, vgl. Kap.~3.3) die Gesamtlatenz dominiert, bleibt die Profilanzahl kein limitierender Faktor für die Systemskalierbarkeit. Die `conversation_chunks`-Collection dient dabei als nicht-parametrisches Gedächtnis im Sinne des in Kap.~2.3.3 hergeleiteten RAG-Mechanismus @lewis2020rag[S.~4--5], @guu2020realm[S.~1--3]; ihre konkrete Nutzung beschreibt Kap.~6.2.

== Datenschutz und biometrische Daten

Gesichtsembeddings sind biometrische Daten im Sinne des Art.~9 Abs.~1 der DSGVO, da sie aus natürlichen Personen abgeleitet werden und zur eindeutigen Identifikation geeignet sind @dsgvo2016[Art.~9 Abs.~1]. Die Verarbeitung solcher Daten besonderer Kategorie unterliegt einem strengen Rechtsrahmen, der die Identifizierbarkeit betroffener Personen als zentrales Schutzgut anerkennt @voigt2017gdpr[S.~114--120], @krivokucahahn2023biometricprotection[S.~639--641].

Das entwickelte System ist ein interner SAP-Prototyp und wird nicht für Endkunden deployt. Die biometrischen Daten werden ausschließlich im internen Netzwerk verarbeitet und gespeichert: Der Qdrant-Pod läuft im SAP-eigenen Kubernetes-Cluster, und biometrische Embeddings verlassen diesen Cluster zu keinem Zeitpunkt. Eine explizite Einwilligung aller am Prototyp beteiligten Testpersonen liegt vor. Dieser Kontext unterscheidet das System grundlegend von einem öffentlichen Deployment-Szenario.

Für ein reales Kundensystem wären zusätzliche Maßnahmen erforderlich: ein explizites Opt-in-Verfahren gemäß Art.~9 Abs.~2 lit.~a DSGVO, das Recht auf Löschung gespeicherter Embeddings nach Art.~17 DSGVO @dsgvo2016[Art.~17] sowie eine Datenschutz-Folgenabschätzung gemäß Art.~35 DSGVO @dsgvo2016[Art.~35] für Hochrisiko-Verarbeitungen biometrischer Daten @voigt2017gdpr[S.~152--160]. Diese Anforderungen sind als bekannte Produktivierungs-Voraussetzungen identifiziert, liegen jedoch außerhalb des Scopes dieses Prototyps.

Neben dem rechtlichen Rahmen ist die gesellschaftliche Akzeptanz biometrischer Systeme ein eigenständiger Einflussfaktor für die praktische Einsetzbarkeit. Untersuchungen zur Wahrnehmung automatischer Gesichtserkennung zeigen, dass Nutzer biometrische Identifikation dann eher akzeptieren, wenn Zweck und Datenspeicherung transparent kommuniziert werden und eine empfundene Nützlichkeit erkennbar ist --- eine Befundlage, die dem Technology-Acceptance-Modell entspricht @rotter2008biometricacceptance[S.~68--70]. Für den SAP-Kiosk-Kontext mit bekannten und eingewilligten Testpersonen ist dies im Rahmen des internen Prototyps unkritisch; für ein öffentliches Deployment bedeutet es jedoch, dass Akzeptanzaspekte --- transparenter Hinweis auf die Kamerafunktion, klare Opt-out-Möglichkeit --- früh in das Interface-Design einfließen müssten, um den rechtlichen Opt-in nicht als leere Formalität zu behandeln.

== Wirtschaftliche Bewertung

Der gesamte lokale Verarbeitungsstack des Systems verwendet ausschließlich Open-Source-Komponenten: MediaPipe, InsightFace, ONNX Runtime, Qdrant und FastAPI sind lizenzfrei nutzbar @lugaresi2019mediapipe[S.~1--2]. Dies eliminiert Lizenzkosten für alle rechenlastigen Kernfunktionen und steht im Gegensatz zu proprietären Cloud-API-basierten Alternativen. Die Microservice-Architektur verstärkt diesen Vorteil: Einzelne Dienste können unabhängig durch kostengünstigere Alternativen ersetzt werden, ohne den restlichen Stack zu beeinflussen @dragoni2017microservices[S.~1--3].

CPU-Inferenz via ONNX Runtime spart zusätzlich GPU-Instanzkosten, die bei Cloud-basierten Alternativen typischerweise den dominanten Kostenfaktor darstellen (Modellwahl vgl. Kap.~3.3).

SAP AI Core wird ausschließlich für drei Aufgaben genutzt: Gaze-Check per Gemini 2.5 Flash (einmalig pro Erkennungsevent), Begrüßungsgenerierung (einmalig pro ACTIVE-Ereignis) und LLM-Chat (nutzergesteuert). Da der Gaze-Check mit einer Rate von maximal einem Aufruf pro vier Sekunden Kandidatensichtbarkeit ausgelöst wird und Begrüßungsgenerierungen nur bei vollständigem ACTIVE-Übergang entstehen, hält sich der API-Verbrauch auch bei dauerhaftem Kiosk-Betrieb in engen Grenzen. Die biometrische Identifikation selbst --- die rechenlastigste und latenzsensibelste Operation --- läuft vollständig lokal ohne LLM-Calls. Damit demonstriert der Prototyp eine wirtschaftliche Personalisierungslösung, die für den SAP-Unternehmenskontext ohne Lizenzrisiken und mit minimalem Cloud-Verbrauch einsetzbar ist.

Für einen typischen 8-Stunden-Kiosk-Tag mit 30~Besuchern ergibt sich folgende Schätzung (Annahmen: 1,5~Gaze-Check-Calls pro Erkennungsevent, 1~Begrüßungs-Call pro ACTIVE-Übergang, 3~Chat-Turns pro Interaktion):

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
    [Chat (Gemini 2.5 Flash)], [90], [2.700], [identisch\*], [identisch\*], [identisch\*],
    [Gesichtserkennung (ArcFace/ONNX)], [30], [900], [*\$0,00*], [~\$0,90], [~\$1,35],
  ),
  kind: table,
  caption: [Geschätzte API-Kosten im 8-Stunden-Kiosk-Betrieb (30~Besucher/Tag). \* Gemini-API-Kosten sind in beiden Szenarien identisch und werden nicht verglichen. AWS~Rekognition: \$0,001/Bild; Azure~Face~API: \$1,50/1.000~Transaktionen (laut öffentlichem Listenpreis).],
) <tab:kostenvergleich>

Damit vermeidet der Prototyp Cloud-API-Kosten von ca.~\$0,90~(AWS~Rekognition) bzw.~\$1,35~(Azure~Face~API) pro Monat allein für die biometrische Identifikation --- bei zehn Kiosk-Standorten entspräche das \$9 bzw.~\$13,50 monatlich.


== Nachhaltigkeitsaspekte

Die ökologische Dimension profitiert davon, dass die Inferenz via ONNX Runtime ausschließlich auf CPU-Ressourcen des Kiosk-Hosts läuft; ein dedizierter GPU-Server ist nicht erforderlich (vgl.~Kap.~3.3). Damit entfällt der Energiebedarf für GPU-Instanzen, der bei Cloud-basierten Alternativen den dominanten Verbrauchsfaktor darstellt. Zusätzlich analysiert das System Kameraframes nicht kontinuierlich, sondern im Takt von 1,0~s (`FRAME_INTERVAL`, vgl.~Kap.~4.1) --- dieser periodische Scan reduziert die CPU-Dauerlast im Kiosk-Betrieb gegenüber einem kontinuierlichen Videostream erheblich.

Die ökonomische Dimension ergibt sich aus dem vollständig lizenzfreien Open-Source-Stack: MediaPipe, InsightFace, ONNX Runtime, Qdrant und FastAPI entstehen ohne wiederkehrende Lizenzkosten. Wie @tab:kostenvergleich zeigt, fallen für die biometrische Identifikation monatlich \$0,00 an --- gegenüber ca.~\$0,90~(AWS~Rekognition) bzw.~\$1,35~(Azure~Face~API) pro Standort bei Cloud-Alternativen (vgl.~Kap.~3.6). Da keine Cloud-Abhängigkeit mit nutzungsabhängigen Gebühren besteht, sind die Betriebskosten bei wachsender Standortanzahl planbar.

Die soziale Nachhaltigkeitsdimension betrifft das Risiko demographisch ungleicher Fehlerraten: Gesichtserkennung birgt die Gefahr, dass ArcFace-Modelle je nach Trainingsdatensatz Untergruppen schlechter erkennen als andere @buolamwini2018gendershades[S.~2--7] --- ein Aspekt, den Kap.~7.1 für den SAP-Kiosk-Kontext einordnet. Der datenschutzrechtliche Rahmen gemäß DSGVO Art.~9 begrenzt den Einsatz bereits strukturell auf registrierte und einwilligende Personen; der Prototyp verarbeitet ausschließlich Bilder bekannter Testpersonen mit erteiltem Opt-in (vgl.~Kap.~3.5). Für ein öffentliches Deployment wäre eine demographische Audit-Phase Teil des Produktivierungspfads.
