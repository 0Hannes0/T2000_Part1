= Evaluation und Fazit

== Evaluation

Das entwickelte System wird anhand von drei Dimensionen eingeordnet: Erkennungsgenauigkeit, Latenz und Robustheit. Die Evaluation kombiniert standardisierte Benchmark-Werte aus der Literatur mit qualitativen Beobachtungen aus der Entwicklungs- und Deploymentphase. Eine formale Probandenstudie war im Rahmen dieses Prototyps nicht vorgesehen; die methodischen Grenzen werden am Ende dieses Abschnitts diskutiert.

=== Erkennungsgenauigkeit

#figure(
  table(
    columns: (1fr, auto, auto),
    stroke: 0.5pt,
    inset: (x: 6pt, y: 5pt),
    align: (left, center, center),
    table.header(
      strong[Modell], strong[Genauigkeit (LFW-Benchmark)], strong[CPU-Latenz],
    ),
    [InsightFace buffalo\_l (ArcFace ResNet50, gewählt)], [*99,83 %*], [~80 ms],
    [FaceNet (Vergleichsmaßstab)], [99,63 %], [---],
  ),
  kind: table,
  caption: [Erkennungsgenauigkeit des gewählten Modells im Vergleich zur FaceNet-Baseline],
) <tab:accuracy-vergleich>

Das eingesetzte Modell erreicht 99,83 % LFW-Genauigkeit @deng2019arcface[S.~3] und liegt damit über der FaceNet-Baseline auf demselben Benchmark @schroff2015facenet[S.~1]. Für den Kiosk-Betrieb ist dieser Wert hinreichend --- die Konsequenz eines Fehlers ist hier eine falsche Begrüßung, kein Sicherheitsrisiko. Über den `SIMILARITY_THRESHOLD`-Parameter lässt sich die Balance zwischen False Positives und Missed Recognitions an die jeweilige Umgebung anpassen; für schwierige Lichtverhältnisse hat sich 0,52 als praxistauglicher Wert erwiesen (eigene Beobachtung).

Die Einschränkung: LFW ist ein kontrollierter Benchmark, der Kiosk-Alltag nicht ist. Wie stabil die Genauigkeit unter wechselnder Beleuchtung und bei größeren Personenzahlen über Wochen bleibt, ließe sich erst durch eine Langzeitstudie belegen --- diese liegt außerhalb des Scopes dieses Prototyps.

=== Systemlatenz

#figure(
  table(
    columns: (1fr, auto),
    stroke: 0.5pt,
    inset: (x: 6pt, y: 5pt),
    align: (left, right),
    table.header(
      strong[Komponente], strong[Messwert],
    ),
    [InsightFace Embedding-Berechnung], [~80 ms (CPU, ONNX)],
    [Gaze-Check Gemini 2.5 Flash], [~1--2 s],
    [`CANDIDATE_SECS` (Wartezeit vor Gaze)], [4,0 s],
    [`GREETING_WAIT_SECS`], [1,5 s],
    [End-to-End bis personalisiertes Greeting], [~6,5--7,5 s],
  ),
  kind: table,
  caption: [Systemlatenz der kritischen Pfade],
) <tab:latenz>

Die Embedding-Berechnung (~80 ms) liegt nicht auf dem kritischen Pfad --- sie läuft parallel zum Gaze-Check und ist vor dessen Abschluss fertig. Der dominierende Latenztreiber ist der Vision-LLM-Aufruf mit ~1--2 s. Die resultierende End-to-End-Latenz von ~6,5--7,5 s bis zum personalisierten Greeting ist für den Kiosk-Kontext akzeptabel: Eine Person, die aktiv mit dem Gerät interagieren möchte, steht typischerweise länger als 10 s davor.

=== Robustheit

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

Die kritischste Einschränkung ist die Winkelabhängigkeit des ArcFace-Scores: Bei Kopfdrehungen über 30° fällt der Ähnlichkeitswert weit unter jeden praxistauglichen Schwellenwert @barquero2020longtermtracking[S.~3--4]. Das zweistufige Tracking (Kap.~5.2) adressiert das: Solange eine Person die letzte bekannte Position nicht verlässt (Radius 120 px), wird sie ohne ArcFace-Score korrekt zugeordnet. ArcFace kommt nur für Rückkehrer zum Einsatz, die kurz wirklich weg waren --- dort ist der Score wieder zuverlässig.

Die methodische Einschränkung gilt auch hier: Die Beobachtungen stammen aus dem Entwicklungsbetrieb unter Bürobeleuchtung. Eine unabhängige Evaluation unter kontrollierten Bedingungen bleibt als nächster Schritt offen.

== Fazit

Die vorliegende Arbeit untersucht eine Forschungsfrage, die aus zwei Teilproblemen öffentlicher Kiosk-Systeme entsteht: einerseits dem bewussten Verzicht auf Login-Mechanismen @porcheron2018voice[S.~3], andererseits dem fehlenden persistenten Gedächtnis großer Sprachmodelle über Sitzungsgrenzen hinweg @zhang2018persona[S.~2388]:

#rect(width: 100%, inset: (x: 12pt, y: 10pt), radius: 4pt, stroke: 0.5pt)[
  _„Wie kann ein öffentlicher KI-Assistent durch kamerabasierte Gesichtserkennung mittels Deep-Learning-Embeddings wiederkehrende Nutzer identifizieren und eine sitzungsübergreifend personalisierte Konversationserfahrung bereitstellen?"_
]

Die Frage lässt sich auf Basis des entwickelten und evaluierten Prototyps positiv beantworten: Ein öffentlicher KI-Assistent kann wiederkehrende Nutzer durch kamerabasierte Gesichtserkennung zuverlässig identifizieren --- und über strukturierte Fakt-Extraktion mit RAG-Retrieval eine personalisierte Konversation aufbauen, die über einzelne Sitzungen hinaus trägt.

Der eigentliche Beitrag der Arbeit liegt weniger in den einzelnen Verfahren --- diese sind etabliert --- als in ihrer Integration zu einem kohärenten Stack: Frontaldetektion, zweistufiges Tracking, Embedding-basierte Identifikation und ein nicht-parametrisches Gesprächsgedächtnis greifen so ineinander, dass die in Kap.~1.1 beschriebene strukturelle Personalisierungslücke öffentlicher Kiosk-Systeme geschlossen wird --- ohne Login, ohne GPU-Server und ohne proprietären Vendor Lock-in. Die in Kap.~7.1 berichteten Genauigkeits-, Latenz- und Robustheitswerte belegen, dass diese Integration die Anforderungen des Kiosk-Kontexts erfüllt; die architektonische Entkopplung über Microservices und das FaceStore-Interface hält sie zugleich für andere Einsatzkontexte offen.

Diese Antwort steht unter dem Vorbehalt ihrer Evaluationsbasis: Die Ergebnisse stützen sich auf Literatur-Benchmarks und Beobachtungen aus dem Entwicklungsbetrieb, nicht auf eine kontrollierte Probandenstudie. Der Prototyp zeigt damit die technische Machbarkeit; der empirische Nachweis unter realen Kiosk-Bedingungen bleibt der in Kap.~7.3 skizzierten Weiterarbeit vorbehalten.

== Ausblick

Obwohl der Prototyp die Forschungsfrage beantwortet, eröffnet er mehrere Weiterentwicklungsrichtungen.

Die unmittelbar interessanteste ist die Domänenübertragung: Das System ist prinzipiell nicht auf den SAP-Kiosk-Kontext beschränkt, sondern auf alle Settings übertragbar, in denen Nutzer bekannt sind, aber keine explizite Login-Infrastruktur existiert @porcheron2018voice[S.~4]. Denkbare Anwendungsfelder reichen von der Pflege (Begrüßung beim Betreten eines Patientenzimmers ohne Geräteentsperrung) über den Bildungsbereich (adaptive Lernsysteme, die Lernhistorie ohne Login laden) bis hin zum Retail (Beratungssysteme, die Stammkunden erkennen und auf frühere Präferenzen eingehen).

Die zweite Richtung betrifft die datenschutzrechtliche Konsolidierung. Der Prototyp wurde unter internen Laborbedingungen entwickelt; ein DSGVO-konformer Produktiveinsatz erfordert darüber hinausgehende Maßnahmen: explizite Einwilligungsmechanismen, ein transparentes Opt-out mit garantierter Datenlöschung (Art.~17 DSGVO) und eine Datenschutz-Folgenabschätzung gemäß Art.~35 DSGVO --- Gesichtsembeddings fallen als biometrische Daten besonderer Kategorie unter Art.~9 @hogenhout2025biometricprivacy[S.~2--4].

Die dritte Richtung ist die technische Reifung: Eine kontrollierte Studie mit standardisierten Bedingungen und einer größeren Probandengruppe würde die auf Benchmark-Werten basierenden Genauigkeitsaussagen empirisch absichern und die Langzeitstabilität des EMA-Embedding-Gedächtnisses über Wochen und Monate validieren @barquero2020longtermtracking[S.~4--5].
