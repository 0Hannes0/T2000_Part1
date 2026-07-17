= Evaluation

Das entwickelte System wird anhand von drei Dimensionen eingeordnet: Erkennungsgenauigkeit, Latenz und Robustheit. Die Evaluation kombiniert standardisierte Benchmark-Werte aus der Literatur mit protokollierten Beobachtungen aus dem Entwicklungs- und Deploymentbetrieb. Eine formale Probandenstudie mit standardisierter Versuchsanordnung war im Rahmen dieses Prototyps nicht vorgesehen; die daraus folgenden methodischen Grenzen werden bei den jeweiligen Dimensionen explizit ausgewiesen.

== Erkennungsgenauigkeit

Das eingesetzte Modell erreicht mit 99,83 % LFW-Genauigkeit einen Wert leicht über der FaceNet-Baseline (99,63 %) auf demselben Benchmark @deng2019arcface[S.~3], @schroff2015facenet[S.~1] --- der vollständige Modellvergleich findet sich in Kap.~3.3. Entscheidend für die Bewertung ist weniger der absolute Wert als seine Angemessenheit für den Einsatzkontext: Für den Kiosk-Betrieb ist diese Genauigkeit hinreichend, denn die Konsequenz eines Fehlers ist hier eine falsche Begrüßung, kein Sicherheitsrisiko. Über den `SIMILARITY_THRESHOLD`-Parameter lässt sich die Balance zwischen False-Accept-Rate (FAR) und False-Reject-Rate (FRR) an die jeweilige Umgebung anpassen (vgl. Kap.~5.1); für wechselnde Lichtverhältnisse hat sich 0,52 als praxistauglicher Wert erwiesen.

Der FAR/FRR-Trade-off folgt dem bekannten Muster: Ein niedrigerer Schwellenwert senkt die FRR --- mehr legitime Wiederkennungen werden akzeptiert --- erhöht aber die FAR, da fremde Personen leichter als bekannt eingestuft werden. Für sicherheitskritische Biometrie-Anwendungen läge der Betriebspunkt typischerweise bei einer FAR unter 0,1 %; für den Kiosk-Kontext ist ein ausgewogener Betriebspunkt sinnvoller, der Nutzungskomfort gegenüber strikter Zugriffskontrolle priorisiert.

Zwei methodische Einschränkungen sind zu benennen: Erstens ist LFW ein Labordatensatz, der im Kiosk-Alltag herrschende Beleuchtungsvarianz, Partialoklusion und wechselnde Pose nicht vollständig abbildet. Zweitens weisen ArcFace-basierte Modelle je nach demographischer Gruppe unterschiedliche Fehlerraten auf --- ein bekanntes Problem biometrischer Systeme, das durch den Trainingsdatensatz (WebFace600K) beeinflusst wird @buolamwini2018gendershades[S.~2--7]. Für einen Prototyp mit internem Testbetrieb ist diese Einschränkung hinnehmbar; ein öffentlicher Produktiveinsatz würde eine demographisch ausgewogene Evaluationsstudie erfordern. Wie stabil die Genauigkeit unter wechselnder Beleuchtung und bei größeren Personenzahlen über Wochen bleibt, ließe sich erst durch eine Langzeitstudie belegen --- diese liegt außerhalb des Scopes dieses Prototyps.

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
    [Beleuchtungsvarianz], [Score-Abfall auf 0,53--0,58 bei verändertem Standort; 8/10 korrekte Ersterkennung], [`SIMILARITY_THRESHOLD` = 0,52 statt 0,65 (vgl. Kap.~5.1)],
    [Multi-Person], [Gleichzeitige Ankünfte], [`GROUP_ARRIVAL_WINDOW` + Duplicate-Merge],
  ),
  kind: table,
  caption: [Robustheitsfaktoren und Gegenmaßnahmen im Entwicklungsbetrieb],
) <tab:robustheit>

Die kritischste Einschränkung ist die Winkelabhängigkeit des ArcFace-Scores: Bei Kopfdrehungen über 30° fällt der Ähnlichkeitswert von ~0,80 auf ~0,15 und damit unter jeden praxistauglichen Schwellenwert @barquero2020longtermtracking[S.~3--4]. Aufgefangen wird dies durch den Positions-Präfilter des zweistufigen Trackings (Kap.~5.2), sodass der ArcFace-Score nur für tatsächlich zurückkehrende Personen ausschlaggebend ist --- dort ist er wieder zuverlässig.

Beleuchtungsvarianz ist die zweite relevante Robustheitsdimension. Bei konstantem Kamerastandort und gleichbleibenden Lichtverhältnissen lagen die Erkennungsraten im Entwicklungsbetrieb bei 10/10 korrekten Wiederkennungen. Wurde die Kamera an einen anderen Standort mit verändertem Lichteinfall versetzt, sank die korrekte Ersterkennung auf 8/10 --- zwei Personen wurden zunächst als neu eingestuft, weil ihre Scores auf 0,53--0,58 abfielen und damit knapp unter dem ursprünglichen Schwellenwert von 0,65 lagen. Nach Anpassung auf 0,52 (Kap.~5.1) wurden auch diese Fälle korrekt zugeordnet. Die Beobachtung unterstreicht, dass der Schwellenwert umgebungsabhängig kalibriert werden muss und nicht als universell gültiger Fixwert zu verstehen ist.

