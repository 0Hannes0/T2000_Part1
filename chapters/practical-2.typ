= Sitzungsübergreifende Personalisierung
#import "@preview/fletcher:0.5.7": diagram, node, edge, shapes

Damit AIKO einen Besucher beim nächsten Mal wiedererkennt und an das letzte Gespräch anknüpfen kann, muss aus jeder Sitzung etwas Brauchbares übrig bleiben.
Dieses Kapitel zeigt, wie das System Gespräche speichert und beim nächsten Besuch wieder abruft.
Der Aufbau folgt dem Ablauf: Kap.~6.1 zeigt, wie ein Gespräch beim Verlassen einer Person zusammengefasst und in drei Kanäle abgelegt wird; Kap.~6.2 beschreibt, wie das System die passenden Fakten während der Sitzung wieder heraussucht und einspielt; Kap.~6.3 behandelt den Sonderfall Gruppen-Session.
Warum überhaupt strukturierte Fakten statt der rohen Gesprächshistorie gespeichert werden, ist in Kap.~2.3 begründet.

== Strukturierte Fakt-Extraktion

Verlässt eine erkannte Person das Blickfeld, löst das `person_left`-Event die Zusammenfassung der Sitzung aus.
Das System legt die Informationen in drei getrennten Kanälen ab, die sich in Detailtiefe und Abrufweg unterscheiden:

#figure(
  table(
    columns: (auto, 1fr, 1fr),
    stroke: 0.5pt,
    inset: (x: 6pt, y: 5pt),
    align: (left, left, left),
    table.header(
      strong[Feld], strong[Inhalt], strong[Persistenz],
    ),
    [`summary`], [1--2 Sätze, die die Session kurz zusammenfassen (neutral, dritte Person)], [1 Chunk mit `[summary]`-Tag; beim nächsten Besuch zu Sitzungsbeginn eingespielt (`_get_last_summary()`)],
    [`facts_sentences`], [Bis zu 5 kurze Einzelaussagen --- aber nur, wo es sich lohnt: persönliche Vorlieben und Themen, nicht jeder Satz und keine Tool-Ergebnisse], [Je 1 Chunk pro Satz; 384-dim Vektor für das RAG-Retrieval],
    [`facts`], [Stabile Kerndaten: name, location, language\_preference, role, company], [Als metadata-Payload im Profil; kein Chunk-Embedding],
  ),
  kind: table,
  caption: [Dreikanaliges Gedächtnisdesign: Persistenzfelder der Fakt-Extraktion],
) <tab:extraktion-kanaele>

Auslöser ist das `person_left`-Event, das die State Machine aus Kap.~4.3 an den Presence Listener meldet.
Es ruft den Endpunkt `/api/summarize` auf, der die Gesprächshistorie an ein Sprachmodell übergibt.
Ein fester JSON-Schema-Prompt zwingt das Modell, genau die drei Felder `summary`, `facts_sentences` und `facts` zurückzugeben @brown2020gpt3[S.~7--9] --- die Ausgabe ist damit direkt maschinenlesbar.

Die `facts_sentences` sind bewusst als kurze Einzelaussagen gespeichert --- ein Fakt pro Chunk.
Das ist für die spätere Suche wichtig: Ein einzelner, klarer Satz liegt im Vektorraum an einer eindeutigen Stelle, während ein längerer Absatz mehrere Themen mischt und dadurch schwerer wiederzufinden ist @xu2022beyondgoldfish[S.~1].
Dabei wird nicht jeder Satz zu einem Fakt: Das Modell extrahiert nur dort Aussagen, wo es einen persönlichen Bezug gibt --- etwa eine Vorliebe oder ein wiederkehrendes Thema --- und höchstens fünf davon.
Das `facts`-Feld enthält dagegen stabile Kerndaten als Metadaten, die ohne Vektorsuche sofort für Begrüßung und Sitzungskonfiguration bereitstehen.

Das Aufteilen in drei Kanäle folgt dem Grundgedanken von MemGPT: ein kompakter Hauptkontext (hier `summary` beim Session-Start) neben einem externen Speicher (hier die `facts_sentences`-Chunks für die Suche während der Sitzung) @packer2024memgpt[S.~1--3]. Die komplette Gesprächshistorie mitzuschleppen, würde dagegen nur das Kontextfenster füllen, ohne dass sich einzelne Fakten gezielt abrufen ließen (vgl. @liu2023lostinthemiddle[S.~4--6] und Kap.~2.3.1).

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

Sobald der Nutzer in der laufenden Sitzung zum ersten Mal etwas sagt, startet der RAG-Abruf.
Die Anfrage wird zunächst in einen Vektor umgewandelt: `embed()` in `backend/services/embedder.py` lässt das Modell `all-MiniLM-L12-v2` lokal laufen und liefert einen 384-dimensionalen Vektor zurück.
Das geht schnell und ohne Netzwerk (~5~ms bei warmem Modell) --- früher lief dieser Schritt als Remote-Aufruf über SAP AI Core und dauerte rund 900~ms.
Das Modell baut auf der Sentence-BERT-Architektur auf und ist auf semantische Ähnlichkeitssuche in kompakten Vektorräumen ausgelegt @reimers2019sbert[S.~3984--3985]; für uns zählte vor allem, dass es lokal läuft, kleine Vektoren liefert und treffsicher genug ist @muennighoff2023mteb[S.~2020--2022].
Dieser Vektor ist der Suchschlüssel für `find_relevant_chunks(person_id, k=3)` in `presence/db/store.py`: Die Funktion durchsucht nur die Chunks dieser Person nach den drei ähnlichsten `facts_sentences`.
Anfrage und gespeicherte Sätze liegen im selben 384-dimensionalen Raum, sodass sich thematische Nähe direkt messen lässt @karpukhin2020dpr[S.~1--2]; die Suche läuft über den HNSW-Index von Qdrant (vgl. Kap.~3.4) @malkov2020hnsw[S.~1--2].

Für die Aktualität sorgt zusätzlich die Injektion zum Sitzungsbeginn: Beim `person_arrived`-Event holt `_get_last_summary()` den neuesten `[summary]`-Chunk und schreibt ihn in `session.instructions`.
So kennt das Sprachmodell schon ab dem ersten Wort grob den letzten Gesprächsstand des Besuchers --- ohne dass dieser sein Vorwissen erneut erklären muss.
Der Vorteil von RAG ist dabei, dass sich das Modell mit neuen, nutzerspezifischen Informationen anreichern lässt, ohne es neu zu trainieren (vgl. Kap.~2.3.3) @lewis2020rag[S.~4].

Ein Beispiel aus dem SAP-Alltag macht den Nutzen greifbar: Ein SAP-Berater bereitet am Kiosk einen Kundentermin vor und sucht Infos für einen bestimmten Kunden --- etwa die Müller AG, die eine S/4HANA-Migration plant.
Das System merkt sich diesen Kontext (Kunde Müller AG, Thema Migration).
Beim nächsten Besuch, kurz vor dem Folgetermin, fragt der Berater weitere Infos zu genau diesem Kunden.
Das System erkennt ihn wieder, ruft den gespeicherten Kontext ab und spielt ihn in die laufende Sitzung ein.
Der Assistent weiß dadurch direkt, für welchen Kunden die Antwort gedacht ist --- der Berater muss seinen Hintergrund nicht noch einmal erklären.

Findet die Suche passende Chunks, spielt das Backend sie als Systemnachricht in die laufende Realtime-Session ein.
Findet sie nichts, läuft die Sitzung ohne Zusatzkontext weiter --- das Gespräch funktioniert trotzdem, nur eben ohne persönliche Anreicherung.

Der RAG-Abruf hat aber eine eingebaute Schwachstelle: Gibt die Suche thematisch unpassende Chunks zurück --- weil die Anfrage zufällig ähnliche Vektorwerte wie ein fremdes Thema hat --- landen diese als vermeintlich relevanter Kontext beim Sprachmodell, ohne dass das System den Fehler bemerkt.
Solche stillen Fehltreffer sind ein bekanntes Problem bei RAG-Systemen @karpukhin2020dpr[S.~2].
Zwei Designentscheidungen halten das Risiko klein: die kurzen Einzelaussagen der `facts_sentences` (ein Fakt pro Chunk, vgl. Kap.~6.1), sodass ein Chunk nie mehrere Themen mischt, und die Filterung auf `person_id`, sodass fremde Profile gar nicht in die Suche geraten.
Ein Restrisiko bleibt --- thematisch ähnliche, aber inhaltlich unpassende Fakten derselben Person ---, wird durch `k=3` und die Ähnlichkeitsschwelle des Index aber begrenzt.

== Gruppen-Sessions und History-Isolation

Sobald der Tracker aus Kap.~4.4 gleichzeitig mehrere Personen erkennt und sie innerhalb des Sammel-Fensters von zwei Sekunden zu einem `group_arrived`-Event zusammenfasst, wechselt das System in den Gruppen-Modus.
In Einzel-Sessions wird beim `person_arrived`-Event der jüngste `[summary]`-Chunk via `_get_last_summary()` als `last_context` eingespielt, sodass das Gesprächsgedächtnis des letzten Besuchs von Anfang an bereitsteht.
In Gruppen-Sessions passiert das bewusst nicht: keine individuelle Injektion, und das Fakt-Schema setzt das `facts`-Objekt per `_SUMMARIZE_PROMPT_GROUP` immer auf `{}` --- für eine Gruppe werden also keine stabilen Kerndaten wie Name, Rolle oder Unternehmen gespeichert.

Der Grund dafür ist, dass sich in einer Gruppe nicht sauber zuordnen lässt, wer was gesagt hat.
Reden Klaus und eine unbekannte Person gemeinsam --- etwa über SAP-BTP-Migrationsoptionen ---, kann das System hinterher nicht auseinanderhalten, welche Aussage von wem stammt.
Würde es dieses Gruppengespräch trotzdem in Klaus' persönliches Profil schreiben, landeten fremde Aussagen und Vorlieben in seinen Fakt-Chunks --- diese unbeabsichtigte Vermischung bezeichnet man als Cross-Contamination.
Um das zu verhindern, speichert das System Gruppen-Chunks ohne Zuordnung zu einer Person und aktualisiert keine Einzelprofile.
So bleiben biometrische Fakten datenschutzrechtlich nur eindeutig identifizierbaren Einzel-Sessions zugeordnet @krivokucahahn2023biometricprotection[S.~639--641] (vgl. Kap.~3.5).

Heikel sind vor allem die Übergänge zwischen Einzel- und Gruppenphase, denn dabei dürfen echte Einzel-Fakten nicht verloren gehen und keine Gruppenaussagen hineinrutschen.
Spricht Klaus zunächst allein und kommt dann jemand dazu, sichert das System den Solo-Teil, bevor die Gruppenphase startet: `/api/summarize` wird mit dem Flag `was_group_session: false` aufgerufen, sodass Klaus' Einzel-Fakten aus der Solo-Phase in sein Profil einfließen --- egal, was danach in der Gruppe gesprochen wird.
Beim umgekehrten Übergang gilt dasselbe: Verlässt die zweite Person den Raum und Klaus redet allein weiter, merkt sich das System den Startpunkt dieser neuen Solo-Phase; beim abschließenden Summarize zählen nur Nachrichten ab diesem Punkt. So gelangen weder beim Start noch beim Ende einer Gruppenphase fremde Aussagen in Klaus' Einzelprofil.

Ob diese Trennung unter realen Bedingungen robust genug ist und wie oft das System überhaupt in den Gruppen-Modus wechselt, prüft Kap.~7.
