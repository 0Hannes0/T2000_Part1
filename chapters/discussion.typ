= Evaluation

Das entwickelte System wird anhand von drei Dimensionen eingeordnet: Erkennungsgenauigkeit, Latenz und Robustheit. Die Evaluation kombiniert standardisierte Benchmark-Werte aus der Literatur mit protokollierten Beobachtungen aus dem Entwicklungs- und Deploymentbetrieb. Eine formale Probandenstudie mit standardisierter Versuchsanordnung war im Rahmen dieses Prototyps nicht vorgesehen; die daraus folgenden methodischen Grenzen werden bei den jeweiligen Dimensionen explizit ausgewiesen.

Der Versuchsrahmen umfasste N = 10 bekannte Personen aus dem Büroumfeld, die über den Zeitraum der Entwicklungsphase (mehrere Wochen) wiederholt am System registriert wurden. Die Interaktionen fanden ausschließlich unter Innenraum-Bürobeleuchtung statt; künstliche Beleuchtungswechsel wurden einmalig gezielt herbeigeführt, um die Schwellenwert-Kalibrierung zu testen (vgl. Abschnitt~7.3). Ein formales Sitzungsprotokoll mit fester Dauer wurde nicht geführt; die Messungen entstammen dem laufenden Entwicklungsbetrieb, in dem das System kontinuierlich aktiv war. Diese Rahmenbedingungen sind methodisch eingeschränkt --- sie erlauben Trendaussagen, aber keine statistisch abgesicherten Konfidenzintervalle. Die daraus folgenden Grenzen werden bei den jeweiligen Dimensionen explizit ausgewiesen.

== Erkennungsgenauigkeit

Das eingesetzte Modell erreicht mit 99,83 % LFW-Genauigkeit einen Wert leicht über der FaceNet-Baseline (99,63 %) auf demselben Benchmark @deng2019arcface[S.~3], @schroff2015facenet[S.~1] --- der vollständige Modellvergleich findet sich in Kap.~3.3. Entscheidend für die Bewertung ist weniger der absolute Wert als seine Angemessenheit für den Einsatzkontext: Für den Kiosk-Betrieb ist diese Genauigkeit hinreichend, denn die Konsequenz eines Fehlers ist hier eine falsche Begrüßung, kein Sicherheitsrisiko. Im Entwicklungsbetrieb trat kein einziger False-Accept-Fall auf --- keine fremde Person wurde fälschlich als bekannter Nutzer erkannt. Über den `SIMILARITY_THRESHOLD`-Parameter lässt sich die Balance zwischen False-Accept-Rate und False-Reject-Rate an die jeweilige Umgebung anpassen (vgl. Kap.~5.1).

Der zugrundeliegende Tradeoff lässt sich anhand der beobachteten Score-Verteilung
konkretisieren: Echte Wiederkennungen derselben Person erzielen unter konstanten
Beleuchtungsbedingungen Kosinus-Scores von 0,72--0,85; nach Kamerastandort-Wechsel
oder Erscheinungsveränderungen (z.~B. neu gesetzte Brille) sinken diese auf 0,53--0,58.
Ein höherer Schwellenwert erhöht die Trennschärfe gegenüber Fremden (niedrige FAR),
erhöht aber gleichzeitig das Risiko, legitime Wiederkennungen im Grenzbereich
abzulehnen (höhere FRR). Der Literaturwert von 0,65 @deng2019arcface[S.~4--5]
erwies sich im Feldtest als zu hoch: Nach Kamerastandort-Wechsel wurden nur 5 von 10
bekannten Personen beim ersten Anlauf korrekt erkannt --- die Grenzfälle (0,53--0,58)
lagen unter dem Schwellenwert und wurden fälschlich als neue Personen klassifiziert
(vgl. Kap.~7.3). Der kalibrierte Betriebspunkt 0,52 deckt auch diese Grenzfälle ab
(9/10 korrekte Ersterkennung) und hält gleichzeitig die FAR bei null: In der gesamten
Entwicklungs- und Testphase trat kein einziger False-Accept auf. Für den
Kiosk-Kontext, in dem eine Falschablehnug störend, eine Falschakzeptanz aber
schwerwiegender ist, ist dieser Betriebspunkt angemessen.

Zwei Einschränkungen der Evaluation sind zu nennen: LFW bildet die Beleuchtungsvarianz und wechselnde Pose des Kiosk-Alltags nicht vollständig ab. Im realen Betrieb steht ein Kiosk jedoch dauerhaft an einem festen Standort mit stabilen Lichtverhältnissen --- die einmalige Schwellenwert-Kalibrierung bei Inbetriebnahme ist daher ausreichend, wie die Beobachtungen in Kap.~7.3 zeigen. Dass ArcFace-basierte Modelle je nach Trainingsdatensatz demographisch unterschiedliche Fehlerraten aufweisen können, ist eine soziale Nachhaltigkeitsdimension der Systemgestaltung @buolamwini2018gendershades[S.~2--7] (vgl.~Kap.~3.7). Im vorliegenden Prototyp beschränkt sich der Testbetrieb auf N~=~10 bekannte Personen aus dem Büroumfeld --- eine demographisch nicht repräsentative Stichprobe, sodass Verzerrungen zwischen Untergruppen nicht quantifiziert werden konnten. Für den internen SAP-Kiosk-Einsatz ist dies vertretbar; ein öffentliches Deployment würde eine Evaluation der Fehlerrate über demographische Gruppen erfordern.

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

Die qualitative Bewertung des Gaze-Checks ergab folgendes Bild: False Positives --- Personen ohne Interaktionsabsicht werden fälschlich als zugewandt erkannt --- traten im Entwicklungsbetrieb selten auf; typischerweise bei Personen, die kurz zum Bildschirm schauten, ohne sich aktiv davor zu stellen. False Negatives --- aktive Nutzer werden trotz Blickkontakt abgewiesen --- waren häufiger und entstanden vorwiegend bei ungünstiger Kopfneigung oder sehr seitlichem Kamerawinkel. Da der Gaze-Check als Debounce-Filter vor der Identifikation wirkt, ist eine erhöhte False-Negative-Rate tolerierbar: Der Nutzer muss sich lediglich nochmals direkt zum Kiosk wenden, um die Verarbeitung auszulösen.

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
    [Multi-Person], [Im Testbetrieb wiesen ca. 20 % der aufgezeichneten Sessions mehr als eine gleichzeitig erkannte Person auf; in diesen Fällen griff der `GROUP_ARRIVAL_WINDOW`-Mechanismus], [`GROUP_ARRIVAL_WINDOW` + Duplicate-Merge],
  ),
  kind: table,
  caption: [Robustheitsfaktoren und Gegenmaßnahmen im Entwicklungsbetrieb],
) <tab:robustheit>

Die kritischste Einschränkung ist die Winkelabhängigkeit des ArcFace-Scores: Bei Kopfdrehungen über 30° fällt der Ähnlichkeitswert von ~0,80 auf ~0,15 und damit unter jeden praxistauglichen Schwellenwert (eigene Beobachtung). Aufgefangen wird dies durch den Positions-Präfilter des zweistufigen Trackings (Kap.~5.2), sodass der ArcFace-Score nur für tatsächlich zurückkehrende Personen ausschlaggebend ist --- dort ist er wieder zuverlässig.

Beleuchtungsvarianz ist die zweite relevante Robustheitsdimension. Bei konstantem Kamerastandort lagen die Erkennungsraten im Entwicklungsbetrieb durchgehend bei 10/10. Wurde die Kamera an einen Standort mit verändertem Lichteinfall versetzt, sank die korrekte Ersterkennung zunächst auf 5/10; nach Kalibrierung von `SIMILARITY_THRESHOLD` auf 0,52 (Vorgehen vgl. Kap.~5.1) stieg sie auf 9/10. Ein False Accept trat bei keinem der getesteten Schwellenwerte und zu keinem Zeitpunkt der gesamten Entwicklung auf.

Gruppen-Sessions --- Situationen, in denen mehrere Personen gleichzeitig erkannt wurden --- traten im Testbetrieb in etwa einem Fünftel aller Sessions auf. Der `GROUP_ARRIVAL_WINDOW`-Mechanismus (vgl. Kap.~6.3) verhinderte in diesen Fällen Doppelbegrüßungen zuverlässig; eine Fehlzuordnung von Gesprächshistorien zwischen verschiedenen Personen wurde nicht beobachtet.

