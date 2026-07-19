= Grundlagen

Dieses Kapitel legt den theoretischen Rahmen für die in den Kapiteln 4 bis 6 beschriebene Implementierung. Im Vordergrund stehen drei Themenbereiche, die unmittelbar in den entwickelten Komponenten Anwendung finden: kamerabasierte Gesichtsdetektion (Kap.~2.1), biometrische Identifikation über Gesichts-Embeddings (Kap.~2.2) sowie sitzungsübergreifendes Gedächtnis in LLM-basierten Systemen (Kap.~2.3). Eingeführt werden nur Konzepte, die für spätere Implementierungsentscheidungen relevant sind.

== Kamerabasierte Gesichtsdetektion

Die automatische Erkennung von Gesichtern in Echtzeit bildet die Grundlage für die Anwesenheitserkennung. Dieser Abschnitt beschreibt die neuronalen Gesichtsdetektoren sowie die Methode, mit der das System entscheidet, ob eine erkannte Person aktiv mit dem Kiosk interagieren möchte.

=== Neuronale Netze zur Gesichtsdetektion

Das System nutzt BlazeFace als Gesichtsdetektor. Dabei handelt es sich um ein neuronales Netz, das für mobile Geräte optimiert ist und ein Bild in einem einzigen Durchlauf nach Gesichtern absucht @bazarevsky2019blazeface[S.~2--3]. Es ist gezielt auf frontale Gesichter ausgelegt und arbeitet dadurch sehr schnell. Für den Kiosk mit fester Kameraposition und konstantem Abstand zur Person ist diese Ausrichtung auf Frontalgesichter kein Nachteil, sondern passt genau zum Einsatzzweck. BlazeFace ist Teil des MediaPipe-Frameworks, einer Sammlung fertiger Bausteine für die Bildverarbeitung in Echtzeit @lugaresi2019mediapipe[S.~1--2].

=== Interaktionsvalidierung durch Vision-LLM

Das System verzichtet auf klassische Blickrichtungsschätzung (Gaze Estimation), weil sie für jeden neuen Nutzer eine personenspezifische Kalibrierung erfordert; ohne sie verschlechtern sich die Ergebnisse unter realen Bedingungen deutlich @cheng2021gazesurvey[§1, S.~1--2], @zhang2015mpiigaze[S.~1--2]. In einem öffentlichen Kiosk mit ständig wechselnden Besuchern lässt sich dieser Schritt nicht durchführen.

Stattdessen fällt die Entscheidung, ob eine Person mit dem Kiosk interagieren möchte, über ein einfaches Ja/Nein-Urteil eines Vision-Sprachmodells: schaut die Person in die Kamera oder nicht. Solche Modelle (etwa Gemini 2.5 Flash) verarbeiten Bild und Sprache gemeinsam und lösen eine Aufgabe allein anhand einer Beschreibung in normaler Sprache --- ohne vorheriges Training für genau diese Aufgabe und ohne Beispielbilder @yin2024clipgaze[S.~6729--6730]. Das passt zum Kiosk mit wechselnden, unbekannten Personen: keine Kalibrierung pro Nutzer, keine Trainingsbeispiele.

== Biometrische Identifikation mit Gesichts-Embeddings

Die Wiedererkennung einer Person über mehrere Sitzungen hinweg braucht ein Merkmal, das eindeutig zur Person passt, sich kompakt speichern und schnell vergleichen lässt. Gesichts-Embeddings --- kompakte Zahlenvektoren, die ein Gesichtsbild beschreiben --- erfüllen das und bilden die Grundlage des eingesetzten Identifikationsverfahrens.

=== Embedding-Räume und Kosinus-Ähnlichkeit

Das Identifikationsverfahren beruht auf dem Konzept des Embedding-Raums: Ein Convolutional Neural Network (CNN --- ein auf Bildverarbeitung spezialisiertes neuronales Netz) übersetzt jedes Gesichtsbild in einen Vektor, und der Abstand zwischen zwei solchen Vektoren gibt an, wie ähnlich sich die Gesichter sind @taigman2014deepface[S.~1--4]. Entscheidend für die Wiedererkennung ist dabei eine einfache Eigenschaft: Gesichter derselben Person liegen im Vektorraum nah beieinander, Gesichter verschiedener Personen weit auseinander. Genau darauf setzt FaceNet @schroff2015facenet[S.~1]. FaceNet misst den Abstand als euklidische Distanz; das hier eingesetzte Verfahren nutzt stattdessen die Kosinus-Ähnlichkeit, also den Winkel zwischen den Vektoren.

Als Ähnlichkeitsmaß zwischen zwei Embeddings $bold(a)$ und $bold(b)$ dient die Kosinus-Ähnlichkeit. Sie misst den Winkel zwischen den Vektoren und ist damit unabhängig von deren Länge:

$ cos(theta) = frac(bold(a) dot.op bold(b), ||bold(a)|| dot.op ||bold(b)||) $

Sind die Embeddings auf Länge 1 normiert (L2-Normierung), vereinfacht sich das zum Skalarprodukt:

$ cos(theta) = bold(a) dot.op bold(b) $

Über einen Schwellwert auf diesem Kosinus-Wert lässt sich dann entscheiden, ob zwei Gesichtsbilder dieselbe Person zeigen. Wo der Schwellwert liegt, bestimmt das Verhältnis zwischen fälschlich akzeptierten und fälschlich abgewiesenen Personen und muss für die jeweilige Anwendung kalibriert werden.

Bei vielen gespeicherten Gesichtern wäre ein Vergleich mit jedem einzelnen Vektor zu langsam. Das eingesetzte Qdrant-Backend nutzt deshalb HNSW, ein Verfahren, das sehr schnell die ähnlichsten Vektoren findet, ohne alle durchzurechnen @malkov2020hnsw[S.~1--2]. Die Details dazu folgen in Kap.~5.

=== Metrisches Lernen: Angular Margin Loss

Ein einfach trainiertes Netz lernt vor allem, die Trainingsbilder korrekt einzusortieren. Es stellt aber nicht sicher, dass Gesichter derselben Person im Vektorraum eng zusammenliegen --- und genau darauf kommt es bei der Wiedererkennung an. Margin-basierte Verlustfunktionen setzen hier an: Sie zwingen das Netz beim Training, zwischen den Personen einen festen Sicherheitsabstand einzuhalten @liu2017sphereface[S.~1--3], @wang2018cosface[S.~1--2]. Das hier verwendete ArcFace erzwingt diesen Abstand als festen Winkelabstand @deng2019arcface[S.~3]; das Ergebnis sind kompaktere Gruppen derselben Person und größere Abstände zwischen verschiedenen Personen --- genau die Eigenschaft, die der spätere Schwellwertvergleich (Kap.~2.2.1) braucht. CosFace erreicht denselben Effekt, indem der Abstand auf den Kosinus-Wert statt auf den Winkel angesetzt wird @wang2018cosface[S.~1--2].

== Sitzungsübergreifendes Gedächtnis in LLM-Systemen

Konversationelle KI-Systeme, die über mehrere Sitzungen hinweg personalisiert antworten sollen, stehen vor einer grundlegenden Hürde: Sprachmodelle haben kein dauerhaftes Gedächtnis. Jede Sitzung beginnt mit einem leeren Kontextfenster. Dieser Abschnitt erläutert das Kontextfenster-Problem, zusammenfassungsbasierte Gedächtnisansätze und Retrieval-Augmented Generation.

=== Das Kontextfenster-Problem

Das Kontextfenster eines Sprachmodells ist sein Arbeitsgedächtnis: Nur was im Prompt steht, kann das Modell bei der Antwort nutzen. Selbst wenn der Platz ausreicht, nutzt das Modell den Inhalt nicht gleichmäßig --- Information aus der Mitte langer Kontexte wird deutlich schlechter abgerufen als am Anfang oder Ende. Dieser Effekt ist als „Lost in the Middle" bekannt @liu2023lostinthemiddle[S.~4--6]. Einfach alle vergangenen Sitzungen in den Prompt zu packen, ist damit keine tragfähige Lösung für sitzungsübergreifende Personalisierung.

=== Gesprächszusammenfassung als Langzeitgedächtnis

Statt die gesamte rohe Gesprächshistorie mitzuschleppen, ist es sinnvoller, vergangene Sitzungen zusammenzufassen und zu verdichten. Systeme, die zusammenfassen und gezielt abrufen, kommen bei langen Gesprächsverläufen deutlich besser zurecht als Modelle, die nur die reine Historie verarbeiten @xu2022beyondgoldfish[S.~1]. Alternativ lassen sich auch einzelne Fakten gezielt herausziehen --- etwa Vorlieben, Gewohnheiten oder wiederkehrende Themen --- was die gespeicherten Informationen später leichter auffindbar macht.

Die Grundidee, Informationen aus dem begrenzten Kontextfenster in einen externen Speicher auszulagern, greift das System von MemGPT auf @packer2024memgpt[S.~1--3], setzt sie aber über die gezielte Extraktion von Fakten und deren späteren Abruf per RAG um (Kap.~6.1 und 6.2).

=== Retrieval-Augmented Generation

Retrieval-Augmented Generation (RAG) verbindet ein Sprachmodell, dessen Wissen fest in den Modellgewichten steckt, mit einem externen, jederzeit aktualisierbaren Wissensspeicher. Der Ablauf ist zweistufig: Zuerst holt ein Retriever passende Dokumente aus dem Vektorindex, dann stützt der Generator seine Antwort auf diese Inhalte. So werden die Antworten konkreter und faktentreuer @lewis2020rag[S.~4], und das externe Wissen lässt sich austauschen, ohne das Modell neu zu trainieren @guu2020realm[S.~1--3] --- für nutzerspezifische Informationen besonders wichtig.

Die Abrufseite arbeitet mit einer semantischen Ähnlichkeitssuche im Embedding-Raum --- nach demselben Prinzip wie die Kosinus-Ähnlichkeit aus Kap.~2.2.1: Anfrage und Dokument werden in denselben Vektorraum übersetzt, thematische Nähe zeigt sich im Abstand der Vektoren. Das System nutzt dafür all-MiniLM-L12-v2 (SBERT-Architektur, 384-dimensionale Vektoren). Der konkrete Einsatz folgt in Kap.~6.2 und 6.3.
