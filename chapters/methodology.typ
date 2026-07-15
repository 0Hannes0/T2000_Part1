= Personenerkennung
#import "@preview/fletcher:0.5.7": diagram, node, edge, shapes

Dieses Kapitel beschreibt die vollständige Personenerkennungs-Pipeline des entwickelten Systems --- vom Kamerasignal über Gesichtsdetektion, Interaktionsvalidierung und Zustandsverwaltung bis hin zu den WebSocket-Events, die das Frontend über Anwesenheit und Identität einer Person informieren.
Der Aufbau folgt dem Datenfluss der Pipeline: Kap.~4.1 beschreibt die BlazeFace-basierte Gesichtsdetektion via MediaPipe, Kap.~4.2 die Gaze-Validierung via Vision-LLM, Kap.~4.3 die State Machine IDLE → CANDIDATE → ACTIVE und Kap.~4.4 das parallele Multi-Person-Tracking und die Gruppen-Erkennung.
Im Vordergrund steht dabei das WIE der Implementierung; die Begründung der Technologieentscheidungen (WARUM) ist bereits in Kap.~3 erfolgt.

== Gesichtsdetektion mit MediaPipe BlazeFace

#figure(
  table(
    columns: (auto, auto, 1fr),
    stroke: 0.5pt,
    inset: (x: 6pt, y: 5pt),
    align: (left, left, left),
    table.header(
      strong[Filter], strong[Wert], strong[Wirkung],
    ),
    [`MIN_DETECTION_CONFIDENCE`], [0,5], [MediaPipe-interne Schwelle für die Bounding-Box-Validierung --- verwirft Detektionen unter diesem Konfidenzwert],
    [`MIN_FACE_WIDTH_RATIO`], [0,06], [Mindestbreite eines erkannten Gesichts relativ zur Frame-Breite --- filtert Hintergrundpersonen heraus (< 6 % des Frame-Bereichs)],
    [`DETECTION_UPSCALE`], [2,5], [Frame wird vor Übergabe an MediaPipe um Faktor 2,5 vergrößert; Bounding-Boxen werden anschließend zurückgerechnet],
  ),
  kind: table,
  caption: [Konfigurationsparameter der BlazeFace-Detektion],
) <tab:blaze-params>

Die drei Filter schließen unerwünschte Detektionen auf unterschiedlichen Ebenen aus.
`MIN_FACE_WIDTH_RATIO` von 0,06 ist dabei der systemkritischste: Ohne diesen Filter würde jede Person, die am Kiosk vorbeiläuft, einen 4-Sekunden-CANDIDATE-Timer auslösen, obwohl sie gar nicht mit dem Kiosk interagieren will --- der Schwellenwert trennt Personen im direkten Interaktionsbereich von Passanten im Hintergrund.
`DETECTION_UPSCALE` von 2,5 kompensiert die distanzbedingte Gesichtsverkleinerung: Da BlazeFace bei kleinen Gesichtern in der Originalgröße an seine Detektionsgrenzen stößt @bazarevsky2019blazeface[S.~2--3], wird der Frame hochskaliert und die Bounding-Box-Koordinaten werden anschließend zurückgerechnet.
Die Detektion erfolgt periodisch mit `FRAME_INTERVAL` von 1,0 s --- kein kontinuierlicher Scan, sondern ein getakteter Stichprobenansatz, der die CPU-Last begrenzt und gleichzeitig eine ausreichend hohe zeitliche Auflösung bietet @lugaresi2019mediapipe[S.~1--2].

Die nach der Detektion ausgelöste Zustandsverwaltung folgt in Kap.~4.3, die Frame-übergreifende Identitätszuordnung in Kap.~4.4.

== Gaze-Validierung via Vision-LLM

#figure(
  table(
    columns: (auto, 1fr),
    stroke: 0.5pt,
    inset: (x: 6pt, y: 5pt),
    align: (left, left),
    table.header(
      strong[Aspekt], strong[Eigenschaft],
    ),
    [Modell], [Gemini 2.5 Flash über SAP AI Core (`thinking_budget=0`, `temperature=0`, `max_output_tokens=50`)],
    [Eingabe], [JPEG-kodiertes Kamerabild (Qualitätsstufe 70) plus Textaufforderung],
    [Ausgabe], [Binäre Klassifikation: „yes" → Person schaut in die Kamera, „no" → nicht, Timeout/Fehler → None (Retry)],
    [Timeout], [`GAZE_TIMEOUT_SECS` = 9,0 s; SDK-Aufruf läuft in separatem Hintergrund-Thread],
  ),
  kind: table,
  caption: [Konfiguration des Vision-LLM Gaze-Validators],
) <tab:gaze-config>

Die Begründung für den Einsatz des Vision-LLM statt klassischer Gaze-Estimation ist in Kap.~3.2 und Kap.~2.1.2 ausgeführt @zhang2015mpiigaze[S.~1--2], @kellnhofer2019gaze360[S.~1]. Das System nutzt dafür ein binäres Vision-LLM-Urteil: schaut die Person in die Kamera oder nicht.

Der funktionale Ablauf startet, sobald die Person `CANDIDATE_SECS` = 4,0 s ununterbrochen erkannt wurde: Der aktuelle Kameraframe wird mittels OpenCV als JPEG mit Qualitätsstufe 70 kodiert und zusammen mit einer kurzen Textaufforderung an das Modell Gemini 2.5 Flash über SAP AI Core geschickt.
Da der zugrunde liegende SDK-Aufruf synchron blockiert, wird er in einem separaten Hintergrund-Thread ausgeführt, sodass der Detektions-Loop nicht blockiert wird.
Aus der Modellantwort ergeben sich drei Pfade: Antwortet das Modell mit „yes", wird der Übergang zu ACTIVE freigegeben, wie in Kap.~4.3 detailliert beschrieben. Antwortet es mit „no", fällt die State Machine zurück nach IDLE.
Überschreitet der Aufruf die Wartezeit von `GAZE_TIMEOUT_SECS` = 9,0 s oder tritt ein Fehler auf, gibt der Gaze-Validator None zurück --- die State Machine verbleibt in diesem Fall im CANDIDATE-Zustand und wiederholt die Prüfung im nächsten Frame, ohne in IDLE zurückzufallen.
Dieser Retry-Mechanismus stellt sicher, dass ein kurzzeitiger LLM-Verbindungsfehler nicht zum Verlust einer bereits erkannten Interaktionsabsicht führt.
Der genaue Prompt-Wortlaut ist nicht Teil dieser Dokumentation; es wird ausschließlich die funktionale Verhaltensweise beschrieben.

Wie der Gaze-Check als zweite Filterstufe in den Zustandsübergang CANDIDATE → ACTIVE eingebettet ist, beschreibt Kap.~4.3.

== State Machine: IDLE → CANDIDATE → ACTIVE

#figure(
  table(
    columns: (auto, auto, 1fr),
    stroke: 0.5pt,
    inset: (x: 6pt, y: 5pt),
    align: (left, left, left),
    table.header(
      strong[Parameter], strong[Wert], strong[Bedeutung],
    ),
    [`CANDIDATE_SECS`], [4,0 s], [Person muss vier Sekunden ununterbrochen erkannt werden, bevor der Gaze-Check startet],
    [`LEAVE_SECS`], [10,0 s], [Kein Gesicht für zehn Sekunden führt von ACTIVE zurück nach IDLE],
    [`GAZE_TIMEOUT_SECS`], [9,0 s], [Maximale Wartezeit auf die Vision-LLM-Antwort; bei Überschreitung Retry ohne IDLE-Reset],
    [`GREETING_WAIT_SECS`], [1,5 s], [Maximale Nachwartezeit nach Gaze-Bestätigung auf den vorbereiteten Begrüßungstext],
    [`FRAME_INTERVAL`], [1,0 s], [Periodisches Detektions-Intervall --- kein kontinuierlicher Scan],
  ),
  kind: table,
  caption: [Parametrisierung der PresenceStateMachine],
) <tab:statemachine-params>

#figure(
  diagram(
    node-stroke: 0.5pt,
    node-corner-radius: 4pt,
    spacing: (22pt, 20pt),
    node((0,0), [], shape: shapes.circle, fill: black, width: 0.7em, height: 0.7em, name: <st>),
    node((1,0), [IDLE],      name: <idle>),
    node((2,0), [CANDIDATE], name: <cand>),
    node((3,0), [ACTIVE],    name: <act>),
    edge(<st>,   <idle>, "->"),
    edge(<idle>, <cand>, "->", label: text(size: 8pt)[Gesicht erkannt]),
    edge(<cand>, <idle>, "->", bend:  40deg, label: text(size: 7.5pt)[Gesicht verloren]),
    edge(<cand>, <idle>, "->", bend: -40deg, label: text(size: 7.5pt)[Gaze negativ]),
    edge(<cand>, <act>,  "->", label: text(size: 7.5pt)[`CANDIDATE_SECS` + Gaze ok]),
    edge(<act>,  <idle>, "->", bend: -55deg, label: text(size: 7.5pt)[`LEAVE_SECS` ohne Gesicht]),
  ),
  kind: image,
  caption: [Zustandsdiagramm der PresenceStateMachine],
) <fig:statemachine>

Sobald `CANDIDATE_SECS` = 4,0 s überschritten sind, startet das System gleichzeitig zwei Hintergrundaufgaben: die Gaze-Validierung und die biometrische Identifikation.
Während die Gaze-Validierung läuft, wartet das System auf das Ergebnis der Identifikation --- dieses enthält Personenname, Wiederkehr-Status, bevorzugte Sprache und Gesprächskontext aus vorherigen Sitzungen --- und bereitet auf dieser Basis einen Begrüßungstext vor.
Sobald die Gaze-Validierung abgeschlossen ist, entscheidet ihr Ergebnis über den Übergang: Gibt sie True zurück, wird der Zustand auf ACTIVE gesetzt; der Begrüßungstext wird mit einem Timeout von `GREETING_WAIT_SECS` = 1,5 s abgewartet und anschließend über das WebSocket-System nach außen signalisiert.
Gibt sie False zurück, wechselt die Maschine zurück nach IDLE und bricht die Begrüßungsvorbereitung ab.
Tritt ein Timeout nach `GAZE_TIMEOUT_SECS` = 9,0 s auf und gibt der Gaze-Validator None zurück, erfolgt kein Zustandswechsel --- im nächsten Detektionszyklus wird sofort erneut geprüft.
Dieser Retry-Mechanismus ist bewusst nicht als eigener Zustand modelliert: ein LLM-Verbindungsfehler ist kein inhaltlicher Sonderfall, sondern ein technisches Interim.

Der Übergang ACTIVE → IDLE tritt nach `LEAVE_SECS` = 10,0 s ein, in denen kein Gesicht der Person erkannt wurde.
Das System toleriert kurze Unterbrechungen der Sichtbarkeit: Wird die Person im nächsten Detektionszyklus erneut erkannt, wird der `gone_since`-Timer zurückgesetzt, ohne den ACTIVE-Zustand zu verlassen --- ein normales Wegsehen oder kurzes Verlassen des Sichtfeldes beendet die Sitzung also nicht sofort.
Die biometrische Identifikation wird in Kap.~5.2 detailliert beschrieben; die Anbindung der Begrüßungsgenerierung an die Personalisierungslogik in Kap.~6.1.

== Paralleles Multi-Person-Tracking und Gruppen-Erkennung

#figure(
  table(
    columns: (auto, auto, 1fr),
    stroke: 0.5pt,
    inset: (x: 6pt, y: 5pt),
    align: (left, left, left),
    table.header(
      strong[Parameter], strong[Wert], strong[Bedeutung],
    ),
    [`POSITION_MATCH_RADIUS`], [120 px], [Schwelle der Positions-Stufe der Zuordnung (Wirkung in Kap.~5.2)],
    [`SIMILARITY_THRESHOLD`], [0,65], [Schwelle der ArcFace-Stufe der Zuordnung (Wirkung in Kap.~5.2)],
    [`GROUP_ARRIVAL_WINDOW_SECS`], [2,0 s], [Sammel-Fenster für parallele ACTIVE-Übergänge --- verschmilzt sie zu `group_arrived`],
    [IDLE-Eviction], [`LEAVE_SECS` · 6 ≈ 60 s], [IDLE-Tracker werden nach diesem Zeitraum aus der Liste entfernt],
  ),
  kind: table,
  caption: [Parametrisierung des PersonTracker für Multi-Person-Tracking],
) <tab:tracker-params>

Der `PersonTracker` in `presence/tracker.py` führt für jede erkannte Person eine eigene `PresenceStateMachine`.
Jede Person durchläuft damit den vollständigen IDLE → CANDIDATE → ACTIVE-Zyklus aus Kap.~4.3 unabhängig von allen übrigen Personen im Frame.
Diese Pro-Person-Trennung ist das zentrale Designprinzip: Die Sitzungssemantik einer Person --- ihr CANDIDATE-Timer, ihr Gaze-Ergebnis, ihre biometrische Identität --- beeinflusst niemals den Zustand einer anderen Person.
Mehrere Personen können gleichzeitig den CANDIDATE-Übergang durchlaufen, und für jede läuft eine eigene Instanz des parallelen Gaze-Identifikations-Flows aus Kap.~4.3.

In jedem Detektionszyklus ordnet der Tracker die neu eingehenden Bounding-Boxen den bekannten `_TrackedPerson`-Einträgen zu. Auf der Architekturebene relevant ist nur das _Prinzip_: Eine schnelle, positionsbasierte Stufe prüft zuerst, ob eine neue Detektion geometrisch zu einer bereits bekannten Person passt; nur wenn das nicht eindeutig ist, wird das vergleichsweise teure ArcFace-Embedding berechnet und gegen die bekannten Profile abgeglichen. Die konkreten Schwellwerte (`POSITION_MATCH_RADIUS`, `SIMILARITY_THRESHOLD`) und der vollständige Algorithmus sind in Kap.~5.2 ausgeführt. Das Vorgehen folgt dem Tracking-by-Detection-Ansatz @bewley2016sort[S.~1--3]: Jedes neue Detektionsergebnis wird einer bereits bekannten Person zugeordnet --- zunächst über ihre Position, dann über ihr Erscheinungsbild @wojke2017deepsort[S.~1--3]. Diese Kombination ist besonders für Szenarien geeignet, in denen Personen längere Zeit vor der Kamera stehen und kurz wegsehen können @barquero2020longtermtracking[S.~1--3].

Für die Gruppen-Logik gilt das `GROUP_ARRIVAL_WINDOW_SECS`-Sammel-Fenster von 2,0 s: Erreichen mehrere Personen innerhalb dieser Zeitspanne die ACTIVE-Schwelle, werden sie zu einem gemeinsamen `group_arrived`-Event zusammengefasst. IDLE-Einträge werden nach `LEAVE_SECS` · 6 ≈ 60 s aus der Liste entfernt, damit das Tracking-Register nicht unbegrenzt wächst.
