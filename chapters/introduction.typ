= Einleitung

== Thematischer Hintergrund und Problemstellung

Öffentliche KI-Assistenten --- etwa sprachgesteuerte Kiosk-Systeme im Empfang von Unternehmen oder auf Messen --- kommen bewusst ohne Login aus @porcheron2018voice[S.~3]. Das ist eine Designentscheidung: Jeder Besucher soll das System sofort nutzen können. Es gibt keine Tastatur und keine Login-Maske, also kann sich der Nutzer auch nicht selbst zu erkennen geben @jain2011biometrics[S.~1]. Diese Offenheit hat aber einen Nachteil: Das System weiß nicht, mit wem es spricht, und kann seine Antworten kaum auf die einzelne Person zuschneiden.

Der Grund liegt in der Funktionsweise großer Sprachmodelle (LLMs): Sie haben kein Gedächtnis, das über eine einzelne Sitzung hinausreicht @zhang2018persona[S.~2388]. Was ein Nutzer heute sagt, ist für das Modell beim nächsten Besuch wieder unbekannt --- es kennt weder seinen Namen noch seine Interessen noch frühere Gespräche @zhang2018persona[S.~2390]. Für echte Personalisierung müsste der gespeicherte Kontext eines Besuchers zu Sitzungsbeginn wieder eingespielt werden, und das setzt voraus, dass das System die Person wiedererkennt.

Dazu kommt eine praktische Grenze: Man kann nicht einfach die komplette Gesprächshistorie in jeden Aufruf laden. Das Kontextfenster eines LLM --- die Textmenge, die es gleichzeitig verarbeiten kann --- ist begrenzt, und je länger die Historie wird, desto unzuverlässiger nutzt das Modell die relevanten Stellen mitten im Text @liu2023lostinthemiddle[S.~1]. Ein sinnvolles Verfahren muss deshalb gezielt nur die Inhalte abrufen, die zur aktuellen Frage passen.

Die Aufgabe dieser Arbeit besteht damit aus zwei verbundenen Teilen: Zuerst muss die Person erkannt werden, danach lässt sich passender Kontext aus früheren Sitzungen abrufen --- beides ohne aktives Zutun des Nutzers. Für die Erkennung bietet sich kamerabasierte Gesichtserkennung an, das gängigste Verfahren, um Personen berührungslos zu identifizieren @guo2019facesurvey[S.~4]. Erst die erkannte Identität macht es möglich, gespeicherten Kontext der richtigen Person zuzuordnen @jain2011biometrics[S.~12]. Wie sich beide Bausteine in einem öffentlichen KI-Assistenten zusammenführen lassen, ist der Gegenstand dieser Arbeit.

== Einordnung in den Forschungsstand

Bestehende Ansätze zur Personalisierung von Sprachassistenten setzen meist auf feste Nutzerprofile mit Login @zhang2018persona[S.~2388--2390] oder speichern Kontext nur kurzzeitig innerhalb einer Sitzung @xu2022beyondgoldfish[S.~1]. Für einen öffentlichen Kiosk ohne Anmeldung fällt die erste Variante weg @porcheron2018voice[S.~3], und die zweite reicht nicht über den einzelnen Besuch hinaus. Biometrische Identifikation ohne vorherige Registrierung ist zwar aus Zugangskontrollen bekannt @jain2011biometrics[S.~12], wurde aber bisher nicht mit einer sitzungsübergreifenden Gesprächspersonalisierung verbunden. Auch Systeme, die Kontext gezielt auslagern und über Sitzungen hinweg vorhalten (etwa MemGPT), setzen eine bereits bekannte Nutzeridentität voraus @packer2024memgpt[S.~1--2]. Genau hier setzt diese Arbeit an: Die Identität kommt passiv über das Gesicht, ohne aktive Anmeldung, gekoppelt mit einem Gesprächsgedächtnis, das relevante Inhalte gezielt nachlädt (Retrieval-Augmented Generation, kurz RAG) @lewis2020rag[S.~2] --- ohne Login, ohne GPU-Server und im Rahmen der DSGVO.

== Zielsetzung und Forschungsfrage

Die Arbeit untersucht, wie ein öffentlicher KI-Assistent wiederkehrende Nutzer per Gesichtserkennung erkennen und ihnen über mehrere Sitzungen hinweg personalisierte Antworten geben kann. Im Mittelpunkt stehen Konzeption, Umsetzung und Bewertung eines vollständigen Prototyps --- von der Erkennung über die Speicherung bis zur personalisierten Sitzung. Die Forschungsfrage lautet:

#rect(width: 100%, inset: (x: 12pt, y: 10pt), radius: 4pt, stroke: 0.5pt)[
  _„Wie kann ein öffentlicher KI-Assistent durch kamerabasierte Gesichtserkennung mittels Deep-Learning-Embeddings wiederkehrende Nutzer identifizieren und eine sitzungsübergreifend personalisierte Konversationserfahrung bereitstellen?"_
]

Die technische Grundlage --- Gesichtserkennung über Deep-Learning-Embeddings @deng2019arcface[S.~1] (numerische Merkmalsvektoren, die ein Gesicht vergleichbar machen) und RAG zur Kontextbereitstellung @lewis2020rag[S.~2] --- wird in Kap.~2 theoretisch eingeordnet und in Kap.~3 als Architekturentscheidung begründet.

== Aufbau der Arbeit

Die Arbeit gliedert sich in acht Kapitel. Kap.~2 legt die theoretischen Grundlagen: Gesichtsdetektion, biometrische Identifikation über Gesichts-Embeddings und sitzungsübergreifendes Gedächtnis in LLM-Systemen. Kap.~3 stellt die Gesamtarchitektur vor und begründet die zentralen Technologieentscheidungen samt Datenschutz- und Wirtschaftlichkeitsaspekten. Kap.~4 beschreibt die Personenerkennung, Kap.~5 die biometrische Identifikation und Profilspeicherung, Kap.~6 die sitzungsübergreifende Personalisierung samt Datenschutz bei Gruppen-Sessions. Kap.~7 bewertet das System nach Genauigkeit, Latenz, Robustheit und Personalisierungsqualität; Kap.~8 beantwortet die Forschungsfrage und gibt einen Ausblick.
