= Personenerkennung
#import "@preview/fletcher:0.5.7": diagram, node, edge, shapes

Dieses Kapitel zeigt, wie die Personenerkennung im System umgesetzt ist: vom Kamerabild über die Gesichtsdetektion und die Prüfung, ob jemand wirklich mit dem Kiosk interagieren will, bis zu den Ereignissen, die das Frontend über Anwesenheit und Identität informieren. Es geht hier um das WIE der Umsetzung --- warum welche Technologie gewählt wurde, steht in Kap.~3.

== Gesichtsdetektion mit MediaPipe BlazeFace

Die Detektion nutzt drei konfigurierbare Filter (`MIN_DETECTION_CONFIDENCE` = 0,5, `MIN_FACE_WIDTH_RATIO` = 0,06 und `DETECTION_UPSCALE` = 2,5; vollständige Parameter siehe Anhang A2). Sie sortieren unerwünschte Detektionen aus. Der wichtigste ist `MIN_FACE_WIDTH_RATIO` mit 0,06. Er löst ein praktisches Problem: Eine Kamera sieht nicht nur die Person direkt vor dem Kiosk, sondern auch alle, die im Hintergrund vorbeigehen. Ohne diesen Filter würde jedes dieser Gesichter einen 4-Sekunden-Timer und damit eine Sitzung anstoßen --- der Kiosk würde also ständig auf Passanten reagieren, die gar nicht stehenbleiben. Der Filter nutzt aus, dass ein weit entferntes Gesicht im Bild klein erscheint: Nimmt ein Gesicht weniger als 6 % der Bildbreite ein, steht die Person zu weit weg, um interagieren zu wollen, und wird aussortiert.

`DETECTION_UPSCALE` von 2,5 gleicht das Gegenteil aus: BlazeFace erkennt sehr kleine Gesichter schlechter @bazarevsky2019blazeface[S.~2--3]. Der Frame wird deshalb vor der Detektion um Faktor 2,5 vergrößert, danach werden die gefundenen Boxen wieder auf die Originalgröße zurückgerechnet.

Die Detektion läuft nicht durchgehend, sondern im Takt von `FRAME_INTERVAL` = 1,0 s. Dieser Stichprobenansatz hält die CPU-Last niedrig und reicht zeitlich völlig aus @lugaresi2019mediapipe[S.~1--2].

== Gaze-Validierung via Vision-LLM

Der Gaze-Check läuft über Gemini 2.5 Flash (SAP AI Core) mit `temperature=0` und abgeschalteter interner Nachdenk-Phase (`thinking_budget=0`); Timeout ist `GAZE_TIMEOUT_SECS` = 9,0 s (vollständige Konfiguration siehe Anhang A2). Warum hier ein Vision-LLM statt einer klassischen Gaze-Estimation zum Einsatz kommt, ist in Kap.~3.2 und Kap.~2.1.2 begründet. Für die Umsetzung reicht ein binäres Urteil: Schaut die Person in die Kamera oder nicht?

Der verwendete Prompt lautet in der englischen Originalfassung: _„Look at this camera image from a kiosk. The camera is mounted at the top of the screen. Is the person's face pointing toward the screen? Answer 'yes' if the face is roughly frontal --- head upright or only slightly tilted. Answer 'no' if the head is clearly turned away, tilted far down, or tilted far up. Answer ONLY with 'yes' or 'no'."_ Bewusst wird nur nach Frontalität gefragt, nicht nach einer genauen Blickrichtung. Das Modell soll grob einschätzen, ob jemand interagieren will --- und das robust genug, dass es bei verschiedenen Personen zuverlässig funktioniert.

Der Ablauf startet, sobald eine Person `CANDIDATE_SECS` = 4,0 s ununterbrochen erkannt wurde. Der Kameraframe wird mit OpenCV als JPEG (Qualitätsstufe 70) kodiert und mit dem Prompt an Gemini 2.5 Flash über SAP AI Core geschickt. Da der SDK-Aufruf synchron blockiert, läuft er in einem eigenen Hintergrund-Thread und hält den Detektions-Loop nicht auf.

Aus der Antwort ergeben sich drei Pfade. Bei „yes" wird der Übergang nach ACTIVE freigegeben (Details in Kap.~4.3), bei „no" fällt die Maschine zurück nach IDLE. Überschreitet der Aufruf `GAZE_TIMEOUT_SECS` = 9,0 s oder schlägt er fehl, bleibt die Maschine im CANDIDATE-Zustand, statt nach IDLE zurückzufallen, und prüft im nächsten Frame erneut. So kostet ein kurzer Verbindungsfehler nicht gleich eine schon erkannte Interaktionsabsicht.

== State Machine: IDLE → CANDIDATE → ACTIVE

Der Zustandsautomat kennt drei Zustände und wird über fünf Zeitparameter gesteuert (`CANDIDATE_SECS` = 4,0 s, `LEAVE_SECS` = 10,0 s, `GREETING_WAIT_SECS` = 1,5 s u.~a.; vollständige Parameter siehe Anhang A2). @fig:statemachine zeigt die Übergänge.

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

Sobald `CANDIDATE_SECS` = 4,0 s überschritten sind, laufen zwei Dinge gleichzeitig an: die Gaze-Validierung und die biometrische Identifikation. Die Identifikation liefert nach rund 80 ms Name, Wiederkehr-Status, bevorzugte Sprache und den Gesprächskontext aus früheren Sitzungen. Mit diesen Daten startet parallel ein dritter Vorgang, der aus Kamerabild und Personendaten schon einen fertigen Begrüßungssatz erzeugt --- vorsorglich, während der Gaze-Check noch läuft. Gebraucht wird er nur, wenn der Check positiv ausfällt.

Über den Übergang entscheidet dann der Gaze-Check. Fällt er positiv aus, geht der Zustand auf ACTIVE, die vorbereitete Begrüßung wird mit maximal `GREETING_WAIT_SECS` = 1,5 s Nachlauf eingesammelt und über das WebSocket-System gemeldet. Fällt er negativ aus, geht es zurück nach IDLE und die Begrüßung wird verworfen. Bei einem Timeout nach `GAZE_TIMEOUT_SECS` = 9,0 s bleibt der Zustand unverändert und der nächste Zyklus prüft erneut. Dieser Wiederholfall bekommt bewusst keinen eigenen Zustand: Ein Verbindungsfehler ist kein inhaltlicher Sonderfall, sondern nur eine technische Zwischenphase.

Der Rückweg von ACTIVE nach IDLE greift erst, wenn `LEAVE_SECS` = 10,0 s lang kein Gesicht der Person erkannt wurde. Kurze Unterbrechungen werden toleriert: Für jede Person merkt sich das System, seit wann sie nicht mehr gesehen wurde (`gone_since`). Taucht sie im nächsten Zyklus wieder auf, wird dieser Zeitstempel zurückgesetzt und die Sitzung läuft weiter. Erst nach vollen zehn Sekunden ohne ein einziges Wiedersehen endet die Sitzung. Normales Wegsehen oder kurzes Aus-dem-Bild-Treten beendet sie also nicht.

== Paralleles Multi-Person-Tracking und Gruppen-Erkennung

Das Multi-Person-Tracking wird über `POSITION_MATCH_RADIUS` = 120 px, `SIMILARITY_THRESHOLD` = 0,52 und das Sammel-Fenster `GROUP_ARRIVAL_WINDOW_SECS` = 2,0 s gesteuert (vollständige Parameter siehe Anhang A2).

Der `PersonTracker` führt für jede erkannte Person eine eigene Zustandsmaschine. Jede durchläuft den IDLE → CANDIDATE → ACTIVE-Zyklus aus Kap.~4.3 unabhängig von den anderen im Bild: CANDIDATE-Timer, Gaze-Ergebnis und Identität einer Person beeinflussen nie den Zustand einer anderen. Mehrere Personen können also gleichzeitig den CANDIDATE-Übergang durchlaufen.

Zur Zuordnung neuer Gesichter zu bekannten Personen prüft der Tracker zuerst eine schnelle, positionsbasierte Stufe; nur bei Uneindeutigkeit wird das teurere ArcFace-Embedding berechnet. Dieses zweistufige Tracking-by-Detection --- Position zuerst, Erscheinungsbild nur bei Bedarf --- passt gut zum Kiosk, wo Personen länger stehen und zwischendurch wegsehen @bewley2016sort[S.~1--3], @wojke2017deepsort[S.~1--3], @barquero2020longtermtracking[S.~1--3]. Schwellwerte und vollständiger Algorithmus stehen in Kap.~5.2.

Für Gruppen gilt das Sammel-Fenster `GROUP_ARRIVAL_WINDOW_SECS` = 2,0 s: Erreichen mehrere Personen innerhalb dieser Zeit die ACTIVE-Schwelle, fasst das System sie zu einem gemeinsamen `group_arrived`-Ereignis zusammen. IDLE-Einträge werden nach `LEAVE_SECS` · 6 ≈ 60 s entfernt, damit das Register nicht unbegrenzt wächst.
