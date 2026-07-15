= Sitzungsübergreifende Personalisierung
#import "@preview/fletcher:0.5.7": diagram, node, edge, shapes

Dieses Kapitel beschreibt die sitzungsübergreifende Personalisierungslogik des entwickelten Systems --- von der strukturierten Fakt-Extraktion am Sitzungsende über das RAG-basierte Chunk-Retrieval mid-session bis hin zur History-Isolation bei Gruppen-Sessions.
Der Aufbau folgt dem Verarbeitungsfluss: Kap.~6.1 beschreibt, wie Gespräche beim Verlassen einer Person in ein dreikanaliges JSON-Schema extrahiert werden; Kap.~6.2 den Retrieval-Mechanismus, mit dem diese Fakten mid-session kontextuell in die laufende Sitzung injiziert werden; und Kap.~6.3 die datenschutzorientierte Sonderbehandlung bei Gruppen-Sessions.
Die Abgrenzung zu den Grundlagenkapiteln ist klar: WARUM strukturierte Fakten statt roher Gesprächshistorie gewählt wurden --- Kontextfenster-Problem, Zusammenfassungstheorie, RAG-Architektur --- ist in Kap.~2.3 ausgeführt.
Dieses Kapitel enthält keine Theoriewiederholungen, sondern die Implementierungsbeschreibung.
Wie die erkannten Personen, deren Anwesenheits-Events das Personalisierungssystem auslösen, im Tracker verwaltet werden, ist in Kap.~4.4 beschrieben.

== Strukturierte Fakt-Extraktion

Verlässt eine erkannte Person das Blickfeld, löst das `person_left`-Event eine strukturierte Fakt-Extraktion aus.
Das System persistiert Sitzungsinformationen in drei strukturell getrennten Kanälen, die sich in Granularität und Abrufpfad unterscheiden:

#figure(
  table(
    columns: (auto, 1fr, 1fr),
    stroke: 0.5pt,
    inset: (x: 6pt, y: 5pt),
    align: (left, left, left),
    table.header(
      strong[Feld], strong[Inhalt], strong[Persistenz],
    ),
    [`summary`], [1--2 Sätze Freitextübersicht der Session (dritte Person, neutral)], [1 Chunk mit `[summary]`-Tag; Session-Start-Injektion via `_get_last_summary()`],
    [`facts_sentences`], [Bis zu 5 atomare Sätze (ein Fakt pro Satz, dritte Person); personenspezifische Präferenzen und Themen --- selektiv, keine Tool-Ergebnisse], [Je 1 Chunk pro Satz; 384-dim Vektor für RAG-Retrieval],
    [`facts`], [Stabile Kerndaten: name, location, language\_preference, role, company], [Als metadata-Payload im Profil; kein Chunk-Embedding],
  ),
  kind: table,
  caption: [Dreikanaliges Gedächtnisdesign: Persistenzfelder der strukturierten Fakt-Extraktion],
) <tab:extraktion-kanaele>

Beim Verlassen einer Person --- genauer: beim `person_left`-Event, das die State Machine aus Kap.~4.3 an den Presence Listener übermittelt --- löst das System den Zusammenfassungs-Endpunkt `/api/summarize` aus.
Dieser Endpunkt übergibt die Gesprächshistorie der abgelaufenen Sitzung an ein Sprachmodell, das per JSON-Schema-Constraint-Prompt exakt die drei Felder `summary`, `facts_sentences` und `facts` als strukturierte Ausgabe liefert @brown2020gpt3[S.~7--9].
Die Verwendung eines festen JSON-Schemas sichert, dass die Ausgabe direkt maschinenverarbeitbar ist, ohne Nachverarbeitung oder heuristische Parsing-Logik.

Die drei Felder unterscheiden sich bewusst in Granularität und Persistenzpfad, weil sie für verschiedene Abruf-Szenarien optimiert sind.
Die `facts_sentences` sind dabei als atomare Einzelsätze gespeichert --- ein Fakt pro Embedding.
Diese Granularität ist für das RAG-Retrieval entscheidend: Atomare Sätze liegen im Vektorraum präzise verortet, während ein zusammengesetzter Absatz das Embedding in mehrere Richtungen zieht und die Trefferquote der semantischen Suche senkt @xu2022beyondgoldfish[S.~1].
Das `facts`-Feld hingegen enthält stabile Kerndaten (Name, Standort, Sprachpräferenz, Rolle, Unternehmen) als Metadata-Payload --- immer ohne Vektorsuche abrufbar und damit direkt für Begrüßung und Sitzungskonfiguration verfügbar.

Dieses dreikanalige Gedächtnisdesign entspricht dem Virtual Context Management-Konzept aus MemGPT, das zwischen einem kompakten Hauptkontext (hier: `summary` für Session-Start) und einem externen Speicher (hier: `facts_sentences`-Chunks für RAG mid-session) trennt @packer2024memgpt[S.~1--3].
Rohe Gesprächshistorie würde dagegen das Kontextfenster des Sprachmodells belasten, ohne die gezielte Abrufbarkeit einzelner Fakten zu gewährleisten --- zu diesem Effekt vgl. @liu2023lostinthemiddle[S.~4--6] und Kap.~2.3.1.
Die mehrkanalige Persistenz erlaubt stattdessen einen zielgerichteten Abruf je nach Bedarf: kompakter `summary`-Kontext beim Session-Start, semantisch passende `facts_sentences` mid-session via RAG, stabile `facts`-Metadaten jederzeit ohne Suchlatenz.

Wie die gespeicherten Chunks im nächsten Besuch für die kontextuelle Anreicherung während der laufenden Sitzung abgerufen werden, beschreibt der folgende Abschnitt 6.2.

== RAG-Retrieval und Kontext-Injektion

#figure(
  diagram(
    node-stroke: 0.5pt,
    node-corner-radius: 3pt,
    spacing: (10pt, 16pt),
    node((1,0), align(center)[Nutzeranfrage\ #text(size: 7.5pt)[(erstes Sprechen-Ereignis)]], name: <q>),
    node((1,1), align(center)[`embed(query)`\ #text(size: 7.5pt)[all-MiniLM-L12-v2, 384-dim, lokal]], width: 140pt, name: <emb>),
    node((1,2), align(center)[`find_relevant_chunks(person_id, k=3)`], width: 170pt, name: <find>),
    node((1,3), align(center)[Relevante Chunks\ gefunden?], shape: shapes.diamond, inset: 8pt, name: <d>),
    node((0,4), align(center)[Chunks als System-Nachricht\ in `session.instructions` injizieren], width: 130pt, name: <inj>),
    node((2,4), align(center)[Weiter ohne\ zusätzlichen Kontext], width: 110pt, name: <noctx>),
    node((0,5), align(center)[LLM antwortet mit\ personalisiertem Kontext], width: 130pt, name: <llmY>),
    node((2,5), [LLM antwortet], width: 110pt, name: <llmN>),
    edge(<q>,     <emb>,   "->"),
    edge(<emb>,   <find>,  "->"),
    edge(<find>,  <d>,     "->"),
    edge(<d>,     <inj>,   "->", label: text(size: 8pt)[Ja]),
    edge(<d>,     <noctx>, "->", label: text(size: 8pt)[Nein]),
    edge(<inj>,   <llmY>,  "->"),
    edge(<noctx>, <llmN>,  "->"),
  ),
  kind: image,
  caption: [RAG-Retrieval-Flow: Embedding der Anfrage, Qdrant-Suche, Kontext-Injektion],
) <fig:rag-flow>

Sobald die erste Spracheingabe eines Nutzers in der laufenden Sitzung eintrifft, beginnt das Mid-Session RAG-Retrieval.
Die Anfrage wird zunächst als semantischer Vektor repräsentiert: `embed()` in `backend/services/embedder.py` führt eine lokale Inferenz mit dem Modell `all-MiniLM-L12-v2` aus und liefert einen 384-dimensionalen Embedding-Vektor zurück (Laufzeit ~5 ms warm, ohne Remote-Verbindung --- dies ersetzt den früheren SAP-AI-Core-Remote-Aufruf mit einer Latenz von ~900 ms).
Dieser Vektor dient als Suchschlüssel für `find_relevant_chunks(person_id, k=3)` in `presence/db/store.py`, das den personenspezifischen Vektorindex nach den semantisch ähnlichsten `facts_sentences`-Chunks dieser Person durchsucht --- die Anfrage und die gespeicherten Sätze landen dabei in demselben 384-dimensionalen Raum, sodass thematische Nähe direkt als Skalarprodukt messbar ist @karpukhin2020dpr[S.~1--2].
Die Suche selbst läuft über den HNSW-Index von Qdrant (Kap.~2.2.1), der die für mid-session-Latenz nötige logarithmische Suchzeit liefert @malkov2020hnsw[S.~1--2].

Der tatsächlich aktive Aktualitätsmechanismus ist die Session-Start-Injektion: Beim `person_arrived`-Event wird der neueste `[summary]`-Chunk via `_get_last_summary()` in `session.instructions` eingebettet, sodass der LLM ab dem ersten Wort der Sitzung über den letzten Gesprächsstand des Besuchers grob informiert ist --- ohne dass dieser sein Vorwissen erneut erklären muss.
Das nicht-parametrische Gedächtnismodell von RAG (vgl. Kap.~2.3.3) @lewis2020rag[S.~4] kann auf diese Weise ohne Neutraining des Modells mit benutzerspezifischen, zeitlich aktualisierten Informationen angereichert werden.

Ein konkretes Beispiel verdeutlicht den Nutzen: Ein SAP-Berater nutzt den Kiosk zur Vorbereitung auf einen Kundentermin und fragt nach typischen Einstiegspunkten für eine S/4HANA-Migration --- das System speichert dabei, dass er für den Kunden Müller AG eine Migrationsstrategie ausarbeitet.
Beim nächsten Besuch, kurz vor dem Folgetermin, fragt er nach Lizenzoptionen für den Mittelstand.
Das System erkennt ihn wieder, ruft den gespeicherten Kontext ab --- Kunde Müller AG, Thema Migration --- und injiziert ihn in die laufende Sitzung.
Der Assistent weiß damit ohne weitere Erklärung, für wen die Antwort relevant ist, und kann direkt auf den bekannten Hintergrund eingehen.

Wurden relevante Chunks gefunden, injiziert das Backend sie als Systemnachricht in die laufende Realtime-Session.
`_inject_rag()` in `backend/routers/realtime.py` erstellt ein `conversation.item.create`-Event mit `role=system`, das dem LLM die personalisierten Fakten als zusätzlichen Systemkontext übergibt und damit `session.instructions` um benutzerspezifische Informationen aus vergangenen Besuchen erweitert.
Liefert die Suche keine relevanten Chunks, setzt das System die Session ohne zusätzlichen Kontext fort --- die Konversation bleibt funktionsfähig, lediglich ohne personalisierte Anreicherung.

Wie das System bei gleichzeitig anwesenden mehreren Personen mit dieser Injection-Logik umgeht, beschreibt der folgende Abschnitt 6.3.

== Gruppen-Sessions und History-Isolation

Sobald der Tracker aus Kap.~4.4 gleichzeitig mehrere aktive Personen erkennt und sie innerhalb des Sammel-Fensters von zwei Sekunden zu einem `group_arrived`-Event zusammenfasst, wechselt das System in den Gruppen-Modus.
In Einzel-Sessions wird beim `person_arrived`-Event der jüngste `[summary]`-Chunk via `_get_last_summary()` als `last_context` in `session.instructions` injiziert, sodass das personenspezifische Gesprächsgedächtnis des letzten Besuchs von Beginn an verfügbar ist; in Gruppen-Sessions findet dagegen keine individuelle Injektion statt, und das Fakt-Schema setzt das `facts`-Objekt per `_SUMMARIZE_PROMPT_GROUP` immer auf `{}` --- es werden keine stabilen Kerndaten wie Name, Rolle oder Unternehmen für die Gruppe extrahiert.

Das Kernproblem, das diese Sonderbehandlung motiviert, ist die fehlende Personenzuordnung in Gruppen: Wenn Klaus und eine unbekannte Person gemeinsam ein Gespräch führen --- etwa über SAP-BTP-Migrationsoptionen --- lässt sich nachträglich nicht rekonstruieren, welche Aussagen von Klaus und welche von der anderen Person stammen.
Würde das System eine solche Gruppenkonversation direkt in Klaus' individuelles Profil schreiben, flössen fremde Aussagen, Präferenzen und Themen in seine persönlichen Fakt-Chunks ein.
Dieser Effekt --- die unbeabsichtigte Vermischung individueller Profile durch Gruppenaussagen --- wird als Cross-Contamination bezeichnet.
Die History-Isolation verhindert Cross-Contamination zwischen Nutzerprofilen: Gruppen-Chunks werden ohne Personenzuordnung gespeichert, individuelle Profilaktualisierungen finden nicht statt, und die datenschutzrechtliche Zuordnung biometrischer Fakten zu Einzelpersonen bleibt auf eindeutig identifizierbare Einzel-Sessions beschränkt @hogenhout2025biometricprivacy[S.~2--4] (vgl. Kap.~3.5 für die datenschutzrechtliche Rahmenbewertung).

Darüber hinaus behandelt das System Übergänge zwischen Einzel- und Gruppenphase besonders, um individuelle Fakten nicht zu verlieren.
Wenn Klaus zunächst allein spricht und dann eine weitere Person dazukommt, sichert das System den bisherigen Solo-Teil als eigenständige Einzel-Session, bevor die Gruppenphase beginnt: Der `/api/summarize`-Aufruf wird mit dem Flag `was_group_session: false` ausgelöst, sodass die individuellen Fakten aus Klaus' Solo-Gespräch in sein Profil einfließen --- unabhängig davon, was in der folgenden Gruppenphase gesprochen wird.
Dieses Solo-Snapshot-Prinzip stellt sicher, dass der Beginn einer Gruppenphase keine bereits gespeicherten Einzel-Fakten überschreibt.

Gleiches gilt für den umgekehrten Übergang: Verlässt das zweite Gruppenmitglied den Raum und Klaus redet solo weiter, merkt sich das System den Startpunkt dieser neuen Solo-Phase.
Beim abschließenden Summarize werden nur Nachrichten ab diesem Startpunkt mit `was_group_session: false` verarbeitet --- Aussagen, die während der Gruppenphase gefallen sind, fließen nicht in Klaus' individuelles Profil.
Diese Solo-Restore-Grenze verhindert, dass Gruppenaussagen Dritter in individuelle Fakt-Chunks gelangen, selbst wenn die Person die Sitzung als Einzel-Session beendet.

Gruppen-Chunks selbst werden zwar im Vektorspeicher abgelegt, aber ohne Zuordnung zu einer Einzelperson.
Da in einer Gruppenkonversation nicht auflösbar ist, wer welche Aussage gemacht hat, erzwingt der Gruppen-Summarize-Prompt `facts: {}` --- stabile Kerndaten wie Name, Rolle oder Unternehmen werden für Gruppenkonversationen grundsätzlich nicht extrahiert.
Ob diese Isolation unter realen Nutzungsbedingungen robust genug ist und wie häufig das System in den Gruppen-Modus wechselt, evaluiert Kap.~7.
