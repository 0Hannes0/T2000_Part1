= Evaluation

Dieses Kapitel ordnet das System entlang von vier Dimensionen ein: Erkennungsgenauigkeit, Latenz, Robustheit und Personalisierungsqualität. Grundlage sind eigene Messungen und Beobachtungen aus dem Entwicklungs- und Testbetrieb. Kennzahlen aus früheren Kapiteln werden hier nur mit ihrem Ergebnis genannt.

Der Prototyp wurde über rund drei Monate im täglichen Bürobetrieb erprobt und dabei fortlaufend getestet. In dieser Zeit traten die praxisrelevanten Fälle wiederholt auf: Erst- und Wiedererkennung, Wechsel von Beleuchtung und Kamerastandort sowie Situationen mit mehreren Personen im Bild. Eine formale Probandenstudie mit standardisierter Versuchsanordnung war für diesen Prototyp nicht vorgesehen; die Aussagen beruhen auf dieser laufenden Beobachtung, nicht auf einer kontrollierten Erhebung. Zur Einordnung stellt die folgende Tabelle die in Kap.~3.1 definierten Anforderungen dem beobachteten Ergebnis gegenüber.

#figure(
  table(
    columns: (auto, auto, auto, auto),
    stroke: 0.5pt,
    inset: (x: 6pt, y: 5pt),
    align: (left, left, left, left),
    table.header(
      strong[Anforderung], strong[Ziel], strong[Ergebnis], strong[Status],
    ),
    [A-01 Embedding-Latenz], [≤ 100 ms], [~80 ms], [erfüllt],
    [A-02 LFW-Genauigkeit], [≥ 99 %], [99,83 %], [erfüllt],
    [A-03 Betrieb ohne GPU], [CPU-only], [CPU-only (ONNX Runtime)], [erfüllt],
    [A-04 keine Falschakzeptanz], [im Betrieb], [kein False-Accept über 3 Monate], [erfüllt],
  ),
  kind: table,
  caption: [Soll-Ist-Abgleich der Anforderungen A-01 bis A-04 aus Kap.~3.1],
) <tab:soll-ist>

Alle vier Anforderungen wurden erfüllt. Die folgenden Abschnitte begründen diese Einordnung und benennen die jeweiligen Grenzen.

== Erkennungsgenauigkeit

Das eingesetzte Modell liegt mit 99,83 % LFW-Genauigkeit auf dem Niveau etablierter Verfahren (Vergleich in Kap.~3.3). Für den Kiosk-Betrieb ist das ausreichend, denn ein Fehler bedeutet hier eine falsche Begrüßung und kein Sicherheitsrisiko. Über den gesamten dreimonatigen Testbetrieb trat kein einziger False-Accept auf --- auch nicht bei Personen im Kamerabild, die nicht im System registriert waren: Keine von ihnen wurde fälschlich als bekannter Nutzer begrüßt.

Wie sich Schwellenwert und Erkennung im Feld verhalten, zeigt die eigene Score-Verteilung: Wiedererkennungen derselben Person erreichten unter konstantem Licht Kosinus-Werte von 0,72--0,85; nach einem Kamerastandort-Wechsel mit verändertem Licht sanken sie auf 0,53--0,58. Der Literatur-Startwert von 0,65 lag damit über diesen Grenzfällen, sodass nach dem Standortwechsel etwa die Hälfte der Wiedererkennungen fälschlich als neue Person gewertet wurde. Der auf 0,52 abgesenkte Betriebspunkt (vgl. Kap.~5.1) deckte auch diese Grenzfälle zuverlässig ab und hielt die Falschakzeptanz bei null. Für den Kiosk, wo eine Falschablehnung nur störend, eine Falschakzeptanz aber schwerwiegender ist, ist dieser Betriebspunkt angemessen.

Zwei Grenzen sind zu nennen. Erstens bildet der LFW-Benchmark den Kiosk-Alltag nur teilweise ab: Die Bilder zeigen Prominente in frontalen Studioaufnahmen, nicht die wechselnde Bürobeleuchtung und Consumer-Kameras des realen Betriebs @guo2019facesurvey[S.~4--5]. Ein hoher LFW-Wert ist deshalb nur ein relativer Indikator; die eigentliche Feld-Validierung leistet die Schwellenwert-Kalibrierung am Einsatzstandort (vgl. Kap.~5.1), die bei einem fest platzierten Kiosk einmalig genügt. Zweitens fand der Testbetrieb in einem Büroumfeld statt und deckt damit keine breite demographische Vielfalt ab. Dass Gesichtserkennung je nach Trainingsdaten unterschiedliche Fehlerraten zwischen Bevölkerungsgruppen zeigen kann, ist bekannt @buolamwini2018gendershades[S.~2--7] (vgl.~Kap.~3.7); für den internen SAP-Einsatz ist das vertretbar, ein öffentliches Deployment würde eine Prüfung über demographische Gruppen erfordern.

== Systemlatenz

Die Zeit vom Erkennen einer Person bis zur personalisierten Begrüßung teilt sich in zwei Phasen: eine bewusst gesetzte Wartezeit und eine kurze, parallel laufende Rechenphase.

#figure(
  table(
    columns: (auto, 1fr, auto),
    stroke: 0.5pt,
    inset: (x: 6pt, y: 5pt),
    align: (left, left, right),
    table.header(
      strong[Phase], strong[Inhalt], strong[Dauer],
    ),
    [Debounce (sequenziell)\ #text(size:7.5pt)[Entprellung --- bewusste Wartezeit, die kurze Fehlauslösungen ausfiltert]], [`CANDIDATE_SECS`: Person muss durchgängig sichtbar sein, bevor die Verarbeitung startet], [4,0 s],
    [Verarbeitung (parallel)], [Gaze-Check (~2 s), Embedding (~80 ms) und Begrüßungsgenerierung laufen gleichzeitig; der Gaze-Check dominiert], [~2 s],
    [Summe], [End-to-End bis personalisiertes Greeting], [*~6 s*],
  ),
  kind: table,
  caption: [Systemlatenz: sequenzielle Wartezeit und parallele Verarbeitung],
) <tab:latenz>

Die eigentliche Rechenlast ist nicht der Engpass: Embedding und Begrüßungsgenerierung laufen parallel zum Gaze-Check (Ablauf s. Kap.~4.3) und sind vor oder mit ihm fertig, sodass die Verarbeitungsphase vom ~2 s dauernden Gaze-Check bestimmt wird. Der größte Anteil der End-to-End-Latenz ist damit die bewusst gesetzte Wartezeit von 4,0 s. Die resultierenden rund 6 s sind für den Kiosk akzeptabel: Wer aktiv interagieren möchte, steht ohnehin länger davor.

Der Gaze-Check zeigte im Testbetrieb folgendes Bild: Falsch als zugewandt erkannte Personen (False Positives) blieben klar in der Minderheit. Fälschlich abgewiesene aktive Nutzer (False Negatives) kamen etwas öfter vor, vor allem bei ungünstiger Kopfneigung oder sehr seitlichem Kamerawinkel. Da der Gaze-Check nur als Vorfilter wirkt, ist das tolerierbar: Der Nutzer muss sich lediglich nochmals direkt zum Kiosk wenden.

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
    [Kopfdrehung > 30°], [ArcFace-Score fällt von ~0,80 auf ~0,15], [Positions-Vorfilter (Stage 1) vor dem ArcFace-Matching],
    [Beleuchtungsvarianz], [Bei verändertem Standort mit 0,65 rund die Hälfte der Ersterkennungen verpasst; nach Anpassung auf 0,52 zuverlässig], [`SIMILARITY_THRESHOLD`-Kalibrierung (vgl. Kap.~5.1)],
    [Multi-Person], [Ca. 20 % der Sessions mit mehr als einer Person; der Gruppen-Mechanismus griff], [`GROUP_ARRIVAL_WINDOW` + Duplicate-Merge],
  ),
  kind: table,
  caption: [Robustheitsfaktoren und Gegenmaßnahmen im Testbetrieb],
) <tab:robustheit>

Die deutlichste Einschränkung ist die Winkelabhängigkeit: Bei Kopfdrehungen über 30° fällt der Ähnlichkeitswert von ~0,80 auf ~0,15 und damit unter jeden brauchbaren Schwellenwert (eigene Beobachtung). Aufgefangen wird das durch den Positions-Vorfilter des zweistufigen Trackings (Kap.~5.2), sodass der ArcFace-Score nur für tatsächlich zurückkehrende Personen ausschlaggebend ist --- und dort ist er wieder zuverlässig. Die Beleuchtungsabhängigkeit fängt die Schwellenwert-Kalibrierung ab (Werte s. @tab:robustheit). Gruppen-Sessions kamen in etwa einem Fünftel der Fälle vor; der `GROUP_ARRIVAL_WINDOW`-Mechanismus (vgl. Kap.~6.3) verhinderte Doppelbegrüßungen zuverlässig, eine Fehlzuordnung von Gesprächshistorien wurde nicht beobachtet.

== Personalisierungsqualität

Die drei vorigen Dimensionen bewerten technische Eigenschaften. Die in Kap.~1.3 formulierte Forschungsfrage zielt darüber hinaus auf die sitzungsübergreifende Personalisierung: ob das System für wiederkehrende Nutzer eine sinnvolle Gesprächskontinuität herstellt.

Diese Kontinuität funktionierte im Testbetrieb nachweislich. Das dreikanalige Gedächtnis (vgl. Kap.~6.1) injiziert beim Wiedererkennen den letzten Sitzungs-Summary und ruft beim ersten Sprechen thematisch passende Fakten aus dem personenspezifischen Index ab. Der Assistent konnte dadurch beim nächsten Besuch ohne erneute Erklärung auf das vorige Gesprächsthema Bezug nehmen; wechselte der Nutzer das Thema, blieb das Retrieval erwartungsgemäß ohne Treffer. Nicht Teil des Projektumfangs war eine breite Nutzerbefragung zur subjektiv wahrgenommenen Nützlichkeit; sie ist als Weiterarbeit denkbar (vgl. Kap.~8.2).
