# Redaktions-Referenz für die Überarbeitung der Projektarbeit (T2000_Part1)

Verbindliche Grundlage für ALLE Kapitel-Überarbeitungen. Ziel: Note **mindestens 1,3**.

## KONTEXT
- DHBW-Praxisprojektarbeit eines dualen Studenten bei SAP (kein Forschungspaper).
- Thema: öffentlicher KI-Kiosk-Assistent ("AIKO"), der Besucher per Gesichtserkennung wiedererkennt und über Sitzungen hinweg personalisiert antwortet.
- Sprache: Deutsch. Zitate im Format `@key[S.~X]` bzw. `@key[S.~X--Y]` beibehalten.
- Dateien sind **Typst** (.typ). Syntax NICHT beschädigen.

## SPRACHZIEL (WICHTIGSTER PUNKT — direkte Anweisung des Studenten)
Es muss klingen, als hätte ein **Student** es geschrieben: fachlich korrekt, aber NICHT aufgeblasen-akademisch ("gestochen"). Der Leser (Gutachter) ist kein Spezialist für Gesichtserkennung.

REGELN:
1. **Keine aufgeblähten Nominalphrasen / kein Selbstlob.** Verboten: „Pareto-optimales Geschwindigkeit-Leistungs-Segment", „geometrische Diskriminierbarkeit im Vektorraum", „Kreativitätsmehrwert", „originelle Beiträge". Streichen oder schlicht/konkret ersetzen.
2. **Fachbegriffe nur wenn nötig — und dann erklärt.** Beim ERSTEN Auftreten eines für Laien unklaren Begriffs kurze Klammer-Erklärung in Alltagssprache. Schon früher erklärte Begriffe NICHT erneut erklären. Verbotene unerklärte Beispiele: „Single-Shot-Detektor", „Anchor-Schema", „Zero-Shot" (ohne Erklärung), „CNN" (ohne Erklärung), „Lightweight-Detektor".
3. **Keine Schachtelsätze.** Sätze über ~3 Zeilen aufsplitten. Ein Gedanke pro Satz.
4. **Keine random Fakten / kein Fakten-Spam.** Zahlen/Benchmarks nur, wenn sie die eigene Argumentation stützen UND eingeordnet sind. Kennzahlen ohne Bezug streichen.
5. **Praxisnah erklären.** Wo ein Konzept zum ersten Mal vorkommt, kurz in Alltagssprache erklären, wie es praktisch funktioniert (Beispiel: „Passanten" = Personen, die am Kiosk vorbeilaufen oder nur seitlich zu sehen sind, ohne stehenzubleiben).
6. **Keine Quellen-Referate.** Nicht „Autor X zeigt, dass ..." als Hauptsatz. Eigene Aussage als Hauptsatz, Quelle als Beleg dahinter. Autoren, die etwas als „bewusstes Merkmal" beschreiben, sind KEIN Beleg für unsere Entscheidung — schreibe, warum es FÜR UNS relevant ist.
7. **Keine internen Kürzel** (D-02, D-05, KP-R4-... etc.).
8. **Keine internen Projektdokumente als Quelle** (CHANGELOG, TUNING.md, REPO-RESEARCH.md). Stattdessen „eigene Messung"/„eigene Beobachtung" bzw. echte Testdaten (siehe unten).

STIL-BEISPIEL (Zielton), dieselbe Aussage:
- ZU GESTOCHEN: „Der positionsbasierte Vorfilter unterbindet Fehlauslösungen durch Passanten: Unterschreitet die Bounding-Box eines detektierten Gesichts 6 % der Frame-Breite, wird die Person als außerhalb des Interaktionsbereichs klassifiziert."
- ZIEL (Student, klar): „Der Positionsfilter sorgt dafür, dass Personen, die nur kurz am Kiosk vorbeigehen, gar nicht erst als Nutzer gewertet werden. Nimmt ein erkanntes Gesicht weniger als 6 % der Bildbreite ein, steht die Person zu weit weg, um wirklich interagieren zu wollen — sie wird deshalb aussortiert."

## KÜRZUNGSAUFTRAG
Body ~43 S., Ziel ≤30. Beim Überarbeiten **straffen**: Redundanzen, doppelte Begründungen und Wiederholungen von Zahlen aus früheren Kapiteln raus (stattdessen „vgl. Kap. X"). Substanz, Tabellen und Diagramme NICHT löschen. Ziel: jedes Kapitel ~15–25 % kürzer, ohne Informationsverlust.

## GRUNDWAHRHEIT (gegen den echten Code verifiziert — NUR das ist korrekt)
- **Konversation/Dialog:** läuft über ein **Realtime-Sprachmodell (gpt-4o Realtime)** über SAP AI Core — Sprache rein UND raus in einem Modell. NICHT Gemini für den Chat.
- **Gemini 2.5 Flash:** nur für Gaze-Check, Begrüßungsgenerierung und Sitzungszusammenfassung.
- **Whisper:** erzeugt zusätzlich ein Transkript der Nutzeräußerung; dieses löst den RAG-Kontextabruf aus. Ehrlich: die Realtime-API hätte selbst ein Transkript, aber diese Funktion stand über SAP AI Core nicht bereit, deshalb Whisper separat — max. 1–2 Sätze, nicht dramatisieren.
- **KEIN Kokoro TTS** (nur konfiguriert, nie live). Sprachausgabe = Stimme der Realtime-API. „Kokoro" nirgends erwähnen.
- **KEIN LangGraph.** Nirgends erwähnen.
- **Gesichtserkennung:** InsightFace `buffalo_l`, Modell `w600k_r50` = **ArcFace ResNet50** (NICHT ResNet100), 512-dim, ONNX Runtime CPU, ~80 ms, LFW 99,83 %.
- **RAG-Embedding:** `all-MiniLM-L12-v2`, **384-dim**, lokal. NICHT text-embedding-3-small, NICHT 1536-dim.
- **SIMILARITY_THRESHOLD:** 0,52 (aus Literatur-Startwert 0,65 abgesenkt).
- **EMA-Blending α = 0,2.** Formel: `e_neu = normalize((1-α)·e_alt + α·e_aktuell)`.
- **State-Machine (alle korrekt):** CANDIDATE_SECS=4,0 s; LEAVE_SECS=10,0 s; GAZE_TIMEOUT_SECS=9,0 s; GREETING_WAIT_SECS=1,5 s; FRAME_INTERVAL=1,0 s; GROUP_ARRIVAL_WINDOW_SECS=2,0 s; IDLE-Eviction≈60 s.
- **Detektion:** MIN_DETECTION_CONFIDENCE=0,5; MIN_FACE_WIDTH_RATIO=0,06; DETECTION_UPSCALE=2,5.
- **Gaze-Check:** Gemini 2.5 Flash, thinking_budget=0, temperature=0, max_output_tokens=50, JPEG-Qualität 70.
- **RAG:** k=3; personenspezifisch gefiltert; Score-Schwelle ~0,3. Aktiv im K8s-/Deploy-Betrieb (RAG_ENABLED=true), lokal standardmäßig aus. Wenn erwähnt: läuft im deployten Betrieb.
- **pin_latest:** existiert, im aktuellen RAG-Pfad NICHT aktiv (Default False). NICHT breit als Feature beschreiben; wenn nur deaktiviert, weglassen. Die Session-Start-Injektion des letzten `[summary]`-Chunks beim Wiedererkennen ist der reale Aktualitätsmechanismus.
- **Drei-Kanal-Gedächtnis:** `summary` (1–2 Sätze, 1 Chunk mit [summary]-Tag), `facts_sentences` (bis zu 5 atomare Sätze, NUR wo sinnvoll — nicht jeder Satz wird ein Fakt; je 1 Chunk, 384-dim), `facts` (stabile Kerndaten: name, location, language_preference, role, company; Metadata, kein Embedding). Gruppen: facts = {}.
- **Ports:** Frontend :5173, Backend :8000, MCP :8001, Presence :8002, Qdrant :6333.
- **Persistenz:** FaceStore-Interface (ABC), Backends SQLite (lokal) + Qdrant (K8s), Wahl per ENV. HANA NICHT implementiert — nur als „austauschbar denkbar" erwähnen.

## HANA-BEGRÜNDUNG (Kap. 3.4) — Betriebskosten zählen NICHT (SAP-intern)
NICHT mit „Vendor Lock-in" oder „höheren Betriebskosten" begründen. Ehrliche Gründe: Qdrant ist ein spezialisiertes Vektor-Werkzeug (schlanke Konfiguration, HNSW-Index direkt zugänglich, praktisch erprobt); HANA ist primär relational, Vektorsuche ist Erweiterung — für einen reinen Vektor-Anwendungsfall unnötiger Overhead. KEINE Entscheidung gegen SAP, sondern für das passende Werkzeug beim Prototyp.

## ECHTE TESTDATEN (dokumentiert, keine Erfindung, dürfen genutzt werden)
- Face-Recognition-Kalibrierung: konstanter Standort → Ersterkennung 10/10. Nach Standortwechsel mit veränderter Beleuchtung: mit 0,65 nur 5/10, nach Absenkung auf 0,52 dann 9/10. In gesamter Entwicklungs-/Testphase KEIN False-Accept.
- Score-Verteilung: konstantes Licht Kosinus 0,72–0,85; nach Lichtwechsel/Aussehensänderung 0,53–0,58. Kopfdrehung > 30°: Score ~0,80 → ~0,15.
- Multi-Person: ca. 20 % der Sessions mit mehr als einer Person; Gruppen-Mechanismus griff, keine Fehlzuordnung.
- Latenz: End-to-End ~6 s (4,0 s bewusste CANDIDATE-Wartezeit + ~2 s Gaze-Check, dominiert); Embedding ~80 ms + Begrüßung laufen parallel.
- Versuchsrahmen: N=10 bekannte Personen aus dem Büroumfeld über mehrere Wochen, Innenraum-Bürobeleuchtung. KEINE formale Probandenstudie — ehrlich benennen, aber NICHT dramatisieren; Praxisprototyp, getestet, funktioniert.

## GRUPPEN / HISTORY-ISOLATION (Kap. 6.3) — mehr Substanz erlaubt
Kernproblem: In Gruppen lässt sich nicht zuordnen, wer was gesagt hat. Würde man das Gruppengespräch ins Einzelprofil schreiben, landeten fremde Aussagen in den persönlichen Fakten (Cross-Contamination). Lösung: in Gruppen keine individuelle Injektion, facts={}, Chunks ohne Personenzuordnung. Solo-Snapshot beim Dazukommen (person_joined → summarize mit was_group_session:false sichert den Solo-Teil VOR der Gruppenphase). Solo-Restore-Grenze beim umgekehrten Übergang (nur Nachrichten ab Solo-Neustart zählen zum Einzelprofil). Echte, gut begründbare Datenschutz-Designentscheidung.

## SAP-BEISPIEL für RAG-Nutzen (Kap. 6.2) — so soll es lauten (Studenten-Wunsch)
Ein SAP-Berater nutzt den Kiosk zur Vorbereitung auf einen Kundentermin und sucht Infos für einen bestimmten Kunden (z. B. Müller AG — S/4HANA-Migration). Beim nächsten Besuch, kurz vor dem Folgetermin, fragt er weitere Infos zu genau diesem Kunden. Das System hat den Kontext (Kunde Müller AG, Thema Migration) gespeichert, erkennt ihn wieder, ruft den Kontext ab und der Assistent weiß direkt, für wen die Antwort relevant ist — ohne dass der Berater seinen Hintergrund erneut erklären muss.

## TYPST-SICHERHEIT
- Tabellenzelle, die mit `=` beginnt (z. B. `[= 0]`), wird als Überschrift fehlinterpretiert → IMMER escapen: `[\= 0]`. Ebenso Zeilenanfänge mit `=`.
- `#figure(...) <label>` und `@ref`/`<label>` nicht verändern, sonst brechen Querverweise.
- Nach dem Editieren muss `typst compile template.typ` weiter durchlaufen. Formeln (`$...$`), `#import`, fletcher-Diagramme nicht beschädigen.
