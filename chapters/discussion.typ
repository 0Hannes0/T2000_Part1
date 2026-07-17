= Evaluation

Das entwickelte System wird anhand von drei Dimensionen eingeordnet: Erkennungsgenauigkeit, Latenz und Robustheit. Die Evaluation kombiniert standardisierte Benchmark-Werte aus der Literatur mit qualitativen Beobachtungen aus der Entwicklungs- und Deploymentphase. Eine formale Probandenstudie war im Rahmen dieses Prototyps nicht vorgesehen; die methodischen Grenzen werden bei den jeweiligen Dimensionen diskutiert.

== Erkennungsgenauigkeit

Das eingesetzte Modell erreicht mit 99,83 % LFW-Genauigkeit einen Wert leicht über der FaceNet-Baseline (99,63 %) auf demselben Benchmark @deng2019arcface[S.~3], @schroff2015facenet[S.~1] --- der vollständige Modellvergleich findet sich in Kap.~3.3. Entscheidend für die Bewertung ist weniger der absolute Wert als seine Angemessenheit für den Einsatzkontext: Für den Kiosk-Betrieb ist diese Genauigkeit hinreichend, denn die Konsequenz eines Fehlers ist hier eine falsche Begrüßung, kein Sicherheitsrisiko. Über den `SIMILARITY_THRESHOLD`-Parameter lässt sich die Balance zwischen False Positives und Missed Recognitions an die jeweilige Umgebung anpassen; für schwierige Lichtverhältnisse hat sich 0,52 als praxistauglicher Wert erwiesen (eigene Beobachtung).

Die Einschränkung: LFW ist ein kontrollierter Benchmark, der Kiosk-Alltag nicht ist. Wie stabil die Genauigkeit unter wechselnder Beleuchtung und bei größeren Personenzahlen über Wochen bleibt, ließe sich erst durch eine Langzeitstudie belegen --- diese liegt außerhalb des Scopes dieses Prototyps.

== Systemlatenz

Die Zeit vom Erkennen einer Person bis zur personalisierten Begrüßung teilt sich in zwei Phasen: eine bewusst gesetzte, sequenzielle Wartezeit und eine kurze, parallel verarbeitete Rechenphase.

#figure(
  table(
    columns: (auto, 1fr, auto),
    stroke: 0.5pt,
    inset: (x: 6pt, y: 5pt),
    align: (left, left, right),
    table.header(
      strong[Phase], strong[Inhalt], strong[Dauer],
    ),
    [Debounce (sequenziell)], [`CANDIDATE_SECS`: Person muss durchgängig sichtbar sein, bevor die Verarbeitung startet], [4,0 s],
    [Verarbeitung (parallel)], [Gaze-Check (~2 s), Embedding (~80 ms) und Begrüßungsgenerierung laufen gleichzeitig; der Gaze-Check dominiert], [~2 s],
    [Summe], [End-to-End bis personalisiertes Greeting], [*~6 s*],
  ),
  kind: table,
  caption: [Systemlatenz: sequenzielle Wartezeit und parallele Verarbeitung],
) <tab:latenz>

Die entscheidende Beobachtung ist, dass die eigentliche Rechenlast nicht der Engpass ist: Embedding-Berechnung und Begrüßungsgenerierung laufen parallel zum Gaze-Check (Ablauf s. Kap.~4.3) und sind vor oder nahezu mit ihm fertig, sodass die Verarbeitungsphase durch den ~2 s dauernden Vision-LLM-Aufruf bestimmt wird und nicht durch die Summe ihrer Teile. Der dominierende Anteil der End-to-End-Latenz ist damit die bewusst gesetzte `CANDIDATE_SECS`-Wartezeit von 4,0 s. Die resultierenden rund 6 s sind für den Kiosk-Kontext akzeptabel: Eine Person, die aktiv mit dem Gerät interagieren möchte, steht typischerweise länger als 10 s davor.

== Robustheit

#figure(
  table(
    columns: (auto, 1fr, 1fr),
    stroke: 0.5pt,
    inset: (x: 6pt, y: 5pt),
    align: (left, left, left),
    table.header(
      strong[Faktor], strong[Beobachtung], strong[Gegenmaßnahme],
    ),
    [Kopfdrehung > 30°], [ArcFace-Score fällt von ~0,80 auf ~0,15], [Positions-Prä-Filter (Stage 1) vor ArcFace-Matching],
    [Beleuchtungsvarianz], [Score-Schwankungen bei indirektem Licht], [`SIMILARITY_THRESHOLD`-Anpassung],
    [Multi-Person], [Gleichzeitige Ankünfte], [`GROUP_ARRIVAL_WINDOW` + Duplicate-Merge],
  ),
  kind: table,
  caption: [Robustheitsfaktoren und Gegenmaßnahmen im Entwicklungsbetrieb],
) <tab:robustheit>

Die kritischste Einschränkung ist die Winkelabhängigkeit des ArcFace-Scores: Bei Kopfdrehungen über 30° fällt der Ähnlichkeitswert von ~0,80 auf ~0,15 und damit unter jeden praxistauglichen Schwellenwert @barquero2020longtermtracking[S.~3--4]. Aufgefangen wird dies durch den Positions-Präfilter des zweistufigen Trackings (Kap.~5.2), sodass der ArcFace-Score nur für tatsächlich zurückkehrende Personen ausschlaggebend ist --- dort ist er wieder zuverlässig.

Die methodische Einschränkung gilt auch hier: Die Beobachtungen stammen aus dem Entwicklungsbetrieb unter Bürobeleuchtung. Eine unabhängige Evaluation unter kontrollierten Bedingungen bleibt als nächster Schritt offen.
