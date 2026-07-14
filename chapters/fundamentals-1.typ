= Grundlagen

Dieses Kapitel legt den theoretischen Rahmen für die in den Kapiteln 4 bis 6 beschriebene Implementierung. Im Vordergrund stehen dabei drei Themenbereiche, die unmittelbar in den entwickelten Systemkomponenten Anwendung finden: kamerabasierte Gesichtsdetektion (Kap.~2.1), biometrische Identifikation über Gesichts-Embeddings (Kap.~2.2) sowie sitzungsübergreifendes Gedächtnis in LLM-basierten Systemen (Kap.~2.3). Die Darstellung folgt dem Prinzip der Zweckgerichtetheit: Es werden ausschließlich Konzepte eingeführt, die für die Nachvollziehbarkeit späterer Implementierungsentscheidungen notwendig sind.

== Kamerabasierte Gesichtsdetektion

Die automatische Erkennung von Gesichtern in Echtzeit-Videosignalen bildet die technische Grundlage für die Anwesenheitserkennung im entwickelten System. Dieser Abschnitt beschreibt die relevanten theoretischen Grundlagen neuronaler Gesichtsdetektoren sowie die Methode, mit der das System per Vision-LLM entscheidet, ob eine erkannte Person aktiv mit dem Kiosk interagieren möchte.

=== Neuronale Netze zur Gesichtsdetektion

Das System setzt auf BlazeFace als Gesichtsdetektor --- einen für mobile Endgeräte optimierten Detektor, der ein Bild in einem einzigen Netzwerk-Durchlauf analysiert und dabei auf frontale Gesichter ausgelegt ist. Im Unterschied zu schwergewichtigeren Architekturen verzichtet BlazeFace auf eine generische Feature-Pyramide --- eine Struktur, die ein Bild auf mehreren Auflösungsstufen gleichzeitig analysiert, um Gesichter unterschiedlicher Größe zu erfassen --- und reduziert dadurch die Inferenzzeit erheblich @bazarevsky2019blazeface[S.~2--3]. Für das Kiosk-Szenario mit fester Kameraposition und konstantem Personenabstand ist diese Vereinfachung unproblematisch und ein bewusster Entwurfsvorteil; ein Bruchteil der von Bazarevsky et al. berichteten Inferenzgeschwindigkeit reicht für die im System angestrebte Frame-Rate aus.

BlazeFace ist Bestandteil des MediaPipe-Frameworks, einer Echtzeit-Perception-Pipeline für mobile und serverbasierte Inferenz @lugaresi2019mediapipe[S.~1--2]. Die frontale Ausrichtung von BlazeFace entspricht dem Kiosk-Szenario: In der eigenen Implementierung wird die Kamera fest montiert, sodass Interaktionspartner frontal vor dem System stehen. Schnelle Detektoren wie BlazeFace erzielen auf frontalen, wenig okludierten Gesichtern vergleichbare Genauigkeit wie schwergewichtigere Modelle bei einem Bruchteil der Inferenzzeit @yang2016widerface[S.~1--2].

Die Konfiguration und Nutzung dieses Detektionsansatzes in der eigenen Implementierung wird in Kap.~4.1 beschrieben.

=== Interaktionsvalidierung durch Vision-LLM

Das System verzichtet auf klassische Blickrichtungsschätzung (Gaze Estimation), weil sie für jeden neuen Nutzer eine personenspezifische Kalibrierung erfordert --- in einem öffentlichen Kiosk mit wechselnden, unbekannten Besuchern ist dieser Aufwand ausgeschlossen. Aktuelle appearance-basierte Verfahren erreichen ihre Genauigkeit erst durch eine solche Kalibrierungsstufe, die systematische Abweichungen zwischen Personen kompensiert @cheng2021gazesurvey[§1, S.~1--2]; ohne diese Stufe verschlechtern sich die Vorhersagen unter realen „in the wild"-Bedingungen erheblich @zhang2015mpiigaze[S.~1--2]. Diese Abhängigkeit von individueller Kalibrierung schließt den klassischen Ansatz für die hier betrachtete Anwendung aus.

Das entwickelte System ersetzt klassische Gaze-Estimation durch ein binäres Vision-LLM-Urteil: Das Modell entscheidet ohne benutzerspezifische Kalibrierung, ob eine Person in die Kamera schaut (Ja/Nein). Vision-Language-Modelle (VLMs) kombinieren visuelles Verstehen mit Sprachgenerierung und ermöglichen so eine Aufgabenbewältigung ohne vorheriges Training auf den jeweiligen Anwendungsfall --- darunter auch die hier benötigte Entscheidung, ob eine Person in die Kamera schaut @radford2021clip[S.~1--3], @cheng2021gazesurvey[§1, S.~1--2]. Diese Eigenschaft --- robuste Klassifikation ohne Kalibrierungsaufwand --- macht VLMs besonders geeignet für Szenarien mit wechselnden Nutzern an öffentlichen Terminals.

Die Entscheidung für den Vision-LLM-basierten Ansatz zur Interaktionsvalidierung und dessen konkrete Implementierung werden in Kap.~4.2 beschrieben.

== Biometrische Identifikation mit Gesichts-Embeddings

Die Wiedererkennung einer Person über mehrere Sitzungen hinweg erfordert ein robustes biometrisches Merkmal, das personenspezifisch, kompakt speicherbar und effizient vergleichbar ist. Gesichts-Embeddings --- kompakte Vektorrepräsentationen eines Gesichtsbildes --- erfüllen diese Anforderungen und bilden die Grundlage des eingesetzten Identifikationsverfahrens.

=== Embedding-Räume und Kosinus-Ähnlichkeit

Das biometrische Identifikationsverfahren basiert auf dem Konzept des Embedding-Raums: Ein Convolutional Neural Network (CNN --- ein auf Bildverarbeitung spezialisiertes neuronales Netz) bildet Gesichtsbilder in einen metrischen Raum ab, in dem Abstände Gesichtsähnlichkeit entsprechen. Neuronale Netze haben bereits früh gezeigt, dass sich Gesichter durch tiefe Merkmalsrepräsentationen mit an menschlicher Erkennungsleistung heranreichender Genauigkeit verifizieren lassen @taigman2014deepface[S.~1--4]; die für biometrische Identifikation entscheidende Eigenschaft ist dabei nicht die Klassifikationsgenauigkeit, sondern ob Gesichter derselben Person im Vektorraum nah beieinander und Gesichter verschiedener Personen weit auseinander liegen. FaceNet präzisiert dieses Ziel: Ein neuronales Netz bildet ein Gesichtsbild auf einen normierten Vektorraum ab, sodass der Winkel zwischen zwei Embeddings --- gemessen als Kosinus-Ähnlichkeit --- unmittelbar der Gesichtsähnlichkeit entspricht @schroff2015facenet[S.~1].

Als Ähnlichkeitsmaß zwischen zwei Embeddings $bold(a)$ und $bold(b)$ wird häufig die Kosinus-Ähnlichkeit verwendet, die den Winkel zwischen den Vektoren misst und damit von der absoluten Vektornorm unabhängig ist:

$ cos(theta) = frac(bold(a) dot.op bold(b), ||bold(a)|| dot.op ||bold(b)||) $

Sind die Embeddings auf die Einheitskugel L2-normiert --- das heißt, ihre Länge wird auf 1 skaliert, sodass das Skalarprodukt direkt den Winkel zwischen zwei Vektoren misst --- vereinfacht sich die Formel zum einfachen Skalarprodukt:

$ cos(theta) = bold(a) dot.op bold(b) $

Ein Schwellwertvergleich auf dem Kosinus-Wert ermöglicht dann die binäre Entscheidung, ob zwei Gesichtsbilder dieselbe Person zeigen. Die Wahl des Schwellwerts beeinflusst dabei den Trade-off zwischen Falschakzeptanzrate und Falschrückweisungsrate und ist anwendungsspezifisch zu kalibrieren.

Für die effiziente Suche in hochdimensionalen Embedding-Räumen werden Approximate-Nearest-Neighbor-Algorithmen eingesetzt, die auf annähernde statt exakte Übereinstimmungen setzen und so den Suchraum erheblich verkleinern @johnson2019faiss[S.~1--3]. Das in dieser Arbeit eingesetzte Qdrant-Backend nutzt HNSW (Hierarchical Navigable Small World) --- einen graphbasierten Algorithmus, der auch bei großen Kollektionen schnell die ähnlichsten Vektoren findet @malkov2020hnsw[S.~1--2].

Die Berechnung und Speicherung von Embeddings in der eigenen Implementierung werden in Kap.~5.1 und Kap.~5.2 beschrieben.

=== Metrisches Lernen: Angular Margin Loss

Standard-Softmax-Klassifikation optimiert ein Netz darauf, Trainingsklassen korrekt zu klassifizieren --- sie stellt aber nicht sicher, dass Gesichter derselben Person im Vektorraum nah beieinander liegen, was für die Wiedererkennung entscheidend ist. Margin-basierte Verlustfunktionen adressieren genau diesen Mangel: Sie zwingen das Netz während des Trainings, einen festen Sicherheitsabstand zwischen Klassen einzuhalten, sodass Embeddings derselben Person eng beieinander, Embeddings verschiedener Personen weiter auseinander liegen --- ein Prinzip, das mit Large Margin Softmax auf normierten Embeddings erstmals systematisch umgesetzt wurde @liu2017sphereface[S.~1--3], @wang2018cosface[S.~1--2].

ArcFace realisiert dies durch eine additive Winkelmarge: Beim Training wird ein fester Abstandswinkel zwischen dem Merkmalsvektor einer Person und den anderen Klassen erzwungen @deng2019arcface[S.~3]. Das Ergebnis sind kompaktere Cluster derselben Person und größere Abstände zwischen verschiedenen Personen --- genau die Eigenschaft, die der nachgelagerte Schwellwertvergleich (Kap.~2.2.1) für die Identifikation ausnutzt. Eine alternative Formulierung verwendet eine kosinusbasierte statt einer angularen Marge @wang2018cosface[S.~1--2]; beide Ansätze erzielen denselben Effekt, unterscheiden sich jedoch in der geometrischen Art, wie die Marge wirkt.

== Sitzungsübergreifendes Gedächtnis in LLM-Systemen

Konversationelle KI-Systeme, die über mehrere Sitzungen hinweg personalisiert interagieren sollen, stehen vor einer grundlegenden Herausforderung: Sprachmodelle verfügen über kein persistentes Gedächtnis. Jede Sitzung beginnt mit einem leeren Kontextfenster. Dieser Abschnitt erläutert das Kontextfenster-Problem, Zusammenfassungs-basierte Gedächtnisansätze und Retrieval-Augmented Generation als die drei theoretischen Säulen des sitzungsübergreifenden Gedächtnisses.

=== Das Kontextfenster-Problem

Das Kontextfenster eines Sprachmodells entspricht seinem Arbeitsgedächtnis: nur Informationen, die explizit im Prompt enthalten sind, stehen dem Modell bei der Generierung einer Antwort zur Verfügung. Diese Begrenzung hat eine strukturelle Konsequenz für die Nutzung langer Gesprächshistorien: Auch wenn die Kapazität des Kontextfensters ausreicht, nutzen Sprachmodelle darin enthaltene Informationen nicht gleichmäßig. Empirische Untersuchungen zeigen, dass relevante Information aus dem mittleren Teil langer Kontexte signifikant schlechter abgerufen wird als Information an Anfang oder Ende --- ein Befund, der unter dem Begriff „Lost in the Middle"-Effekt bekannt ist @liu2023lostinthemiddle[S.~4--6]. Zugleich belegen Analysen zu In-Context-Lernen, dass Leistung und Zuverlässlichkeit von LLMs stark von der Selektion und Anordnung des Kontextinhalts abhängen @dong2022survey[S.~1--4]. Das bloße Einbetten aller vergangenen Sitzungen in den Prompt ist damit keine robuste Strategie für sitzungsübergreifende Personalisierung.

Die daraus folgenden Anforderungen an die Gedächtnisarchitektur dieses Systems werden in Kap.~6.1 diskutiert.

=== Gesprächszusammenfassung als Langzeitgedächtnis

Für sitzungsübergreifende Personalisierung ist die Verdichtung vergangener Sitzungen durch Zusammenfassung der rohen Gesprächshistorie vorzuziehen: Systeme mit Zusammenfassungs- und Retrievalfähigkeiten übertreffen Standard-Encoder-Decoder-Architekturen bei langen Gesprächsverläufen deutlich @xu2022beyondgoldfish[S.~1]. Die strukturierte Extraktion von Fakten aus Gesprächen --- etwa über Präferenzen, Gewohnheiten oder wiederkehrende Themen --- ist eine Variante dieses Ansatzes, die gegenüber freier Zusammenfassung eine strukturiertere Abrufbarkeit bietet. Das Grundprinzip getrennter Gedächtnisschichten ist dabei älter als moderne LLMs: Memory Networks formalisieren die Idee eines explizit adressierbaren externen Gedächtnisses, das unabhängig vom kurzfristigen Arbeitsgedächtnis persistiert wird @weston2014memory[S.~1--3].

Ein ähnliches Prinzip --- explizites Auslagern von Informationen aus dem Kontextfenster in einen externen Speicher --- beschreiben Packer et al. als MemGPT @packer2024memgpt[S.~1--3]. Das vorliegende System folgt diesem Grundgedanken, setzt es aber anders um: durch strukturierte Faktextraktion und RAG-basiertes Retrieval (Kap.~6.1 und 6.2).

Die Realisierung der Zusammenfassung in der eigenen Implementierung wird in Kap.~6.1 beschrieben.

=== Retrieval-Augmented Generation

Retrieval-Augmented Generation (RAG) kombiniert ein Sprachmodell, dessen Wissen fest im Modellgewicht gespeichert ist, mit einem extern gespeicherten, aktualisierbaren Wissensindex. Die Grundarchitektur ist zweistufig: Ein Retriever ruft kontextrelevante Dokumente aus dem Vektorindex ab, ein Generator konditioniert seine Ausgabe auf die abgerufenen Inhalte --- das Ergebnis sind „more specific, diverse and factual" Antworten verglichen mit einem rein parametrischen Modell @lewis2020rag[S.~4]. REALM zeigt, dass Retrieval-augmentierte Sprachmodelle durch die Trennung von parametrischem und nicht-parametrischem Wissen aktualisierbar sind, ohne das Modell erneut trainieren zu müssen @guu2020realm[S.~1--3] --- was für dynamische, benutzerspezifische Informationsbestände besonders relevant ist.

Die Retrieval-Seite von RAG basiert auf semantischer Ähnlichkeitssuche im Embedding-Raum --- analog zur Kosinus-Ähnlichkeit aus Kap.~2.2.1. Anfrage und Dokument werden durch ein Embedding-Modell in denselben Vektorraum projiziert; thematische Nähe ist dann direkt als Skalarprodukt messbar. Das im System eingesetzte RAG-Retrievalmodell all-MiniLM-L12-v2 erzeugt 384-dimensionale Vektoren; seine Nutzung für das Chunk-Retrieval wird in Kap.~6.2 beschrieben.

Kap.~6.2 beschreibt das RAG-Chunk-Retrieval in der eigenen Implementierung; Kap.~6.3 die History-Isolation zwischen parallelen Nutzern.
