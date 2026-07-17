= Evaluation

Das entwickelte System wird anhand von drei Dimensionen eingeordnet: Erkennungsgenauigkeit, Latenz und Robustheit. Die Evaluation kombiniert standardisierte Benchmark-Werte aus der Literatur mit protokollierten Beobachtungen aus dem Entwicklungs- und Deploymentbetrieb. Eine formale Probandenstudie mit standardisierter Versuchsanordnung war im Rahmen dieses Prototyps nicht vorgesehen; die daraus folgenden methodischen Grenzen werden bei den jeweiligen Dimensionen explizit ausgewiesen.

== Erkennungsgenauigkeit

Das eingesetzte Modell erreicht mit 99,83 % LFW-Genauigkeit einen Wert leicht über der FaceNet-Baseline (99,63 %) auf demselben Benchmark @deng2019arcface[S.~3], @schroff2015facenet[S.~1] --- der vollständige Modellvergleich findet sich in Kap.~3.3. Entscheidend für die Bewertung ist weniger der absolute Wert als seine Angemessenheit für den Einsatzkontext: Für den Kiosk-Betrieb ist diese Genauigkeit hinreichend, denn die Konsequenz eines Fehlers ist hier eine falsche Begrüßung, kein Sicherheitsrisiko. Im Entwicklungsbetrieb trat kein einziger False-Accept-Fall auf --- keine fremde Person wurde fälschlich als bekannter Nutzer erkannt. Über den `SIMILARITY_THRESHOLD`-Parameter lässt sich die Balance zwischen False-Accept-Rate und False-Reject-Rate an die jeweilige Umgebung anpassen (vgl. Kap.~5.1); ein niedrigerer Schwellenwert akzeptiert mehr legitime Wiederkennungen, erhöht aber das Risiko von Fehlerkennung --- für den Kiosk-Kontext, in dem kein Sicherheitsrisiko besteht, ist ein komfortorientierter Betriebspunkt sinnvoll.

Zwei Einschränkungen der Evaluation sind zu nennen: LFW bildet die Beleuchtungsvarianz und wechselnde Pose des Kiosk-Alltags nicht vollständig ab, und ArcFace-basierte Modelle können je nach Trainingsdatensatz (hier WebFace600K) demographisch unterschiedliche Fehlerraten aufweisen @buolamwini2018gendershades[S.~2--7] --- für einen internen Prototyp hinnehmbar, für einen öffentlichen Einsatz aber evaluierungspflichtig. Eine Langzeitstudie über Wochen liegt außerhalb des Scopes dieses Prototyps.

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
    [Beleuchtungsvarianz], [Bei verändertem Kamerastandort: 5/10 korrekte Ersterkennung mit Threshold 0,65; nach Anpassung auf 0,52: 9/10], [`SIMILARITY_THRESHOLD`-Kalibrierung auf Einsatzumgebung (vgl. Kap.~5.1)],
    [Multi-Person], [Gleichzeitige Ankünfte], [`GROUP_ARRIVAL_WINDOW` + Duplicate-Merge],
  ),
  kind: table,
  caption: [Robustheitsfaktoren und Gegenmaßnahmen im Entwicklungsbetrieb],
) <tab:robustheit>

Die kritischste Einschränkung ist die Winkelabhängigkeit des ArcFace-Scores: Bei Kopfdrehungen über 30° fällt der Ähnlichkeitswert von ~0,80 auf ~0,15 und damit unter jeden praxistauglichen Schwellenwert @barquero2020longtermtracking[S.~3--4]. Aufgefangen wird dies durch den Positions-Präfilter des zweistufigen Trackings (Kap.~5.2), sodass der ArcFace-Score nur für tatsächlich zurückkehrende Personen ausschlaggebend ist --- dort ist er wieder zuverlässig.

Beleuchtungsvarianz ist die zweite relevante Robustheitsdimension. Bei konstantem Kamerastandort lagen die Erkennungsraten im Entwicklungsbetrieb bei 10/10. Wurde die Kamera an einen Standort mit verändertem Lichteinfall versetzt, sank die korrekte Ersterkennung auf 5/10 --- die meisten Scores lagen um 0,53--0,58 und damit knapp unter dem ursprünglichen Schwellenwert von 0,65. Nach Anpassung auf 0,52 stieg die Rate auf 9/10. Ein False Accept trat dabei nicht auf. Die Beobachtung zeigt, dass der Schwellenwert auf die jeweilige Einsatzumgebung kalibriert werden muss.

