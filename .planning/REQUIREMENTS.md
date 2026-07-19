# Requirements: T2000 Studienarbeit

**Defined:** 2026-06-12
**Core Value:** Entscheidungslogik hinter jeder technischen Wahl nachvollziehbar belegen — nicht nur was gebaut wurde, sondern warum genau so.

## v1 Requirements

### Vorarbeit

- [x] **VOR-01**: Alle relevanten Informationen aus T2000 und ai-infopoint-prototyp systematisch extrahiert und in `.planning/research/REPO-RESEARCH.md` strukturiert
- [x] **VOR-02**: Bewertungs-PDF (`Bewertung_Projekt_Studien_Bachelor.pdf`) als strukturiertes Markdown-Dokument extrahiert

### Kapitel 2 — Grundlagen

- [ ] **KAP2-01**: Quelldatei `kap2-grundlagen-sources.md` mit annotierten Quellen für alle drei Grundlagenabschnitte
- [ ] **KAP2-02**: BibTeX-Datei `kap2-grundlagen-sources.bib` mit allen Quellen
- [ ] **KAP2-03**: Kapiteltext `kap2-grundlagen.md` — Kap. 2.1 Gesichtsdetektion (BlazeFace, neuronale Netze)
- [ ] **KAP2-04**: Kapiteltext — Kap. 2.2 Biometrische Identifikation (Embedding-Räume, ArcFace/Angular Margin)
- [ ] **KAP2-05**: Kapiteltext — Kap. 2.3 LLM-Gedächtnis (Kontextfenster, Zusammenfassung, RAG)

### Kapitel 3 — Konzeption

- [ ] **KAP3-01**: Quelldatei `kap3-konzeption-sources.md` + `kap3-konzeption-sources.bib`
- [ ] **KAP3-02**: Kapiteltext `kap3-konzeption.md` — Kap. 3.1 Gesamtarchitektur
- [ ] **KAP3-03**: Kapiteltext — Kap. 3.2 Detektionsansatz (MediaPipe vs. YOLO vs. Vision-LLM)
- [ ] **KAP3-04**: Kapiteltext — Kap. 3.3 Erkennungsmodell (InsightFace vs. DeepFace, Tabelle)
- [ ] **KAP3-05**: Kapiteltext — Kap. 3.4 Persistenzschicht (FaceStore-Interface, SQLite→Qdrant)
- [ ] **KAP3-06**: Kapiteltext — Kap. 3.5 Datenschutz & 3.6 Wirtschaftliche Bewertung

### Kapitel 4 — Personenerkennung

- [ ] **KAP4-01**: Quelldatei `kap4-personenerkennung-sources.md` + `.bib`
- [ ] **KAP4-02**: Kapiteltext `kap4-personenerkennung.md` — Kap. 4.1–4.4 vollständig

### Kapitel 5 — Biometrische Identifikation

- [ ] **KAP5-01**: Quelldatei `kap5-identifikation-sources.md` + `.bib`
- [ ] **KAP5-02**: Kapiteltext `kap5-identifikation.md` — Kap. 5.1–5.3 vollständig

### Kapitel 6 — Personalisierung

- [ ] **KAP6-01**: Quelldatei `kap6-personalisierung-sources.md` + `.bib`
- [ ] **KAP6-02**: Kapiteltext `kap6-personalisierung.md` — Kap. 6.1–6.3 vollständig

### Abschluss

- [x] **ABL-01**: Kapiteltext `kap1-einleitung.md` — Kap. 1.1–1.3
- [x] **ABL-02**: Kapiteltext `kap7-evaluation.md` — Kap. 7.1–7.4 mit Messwerten aus Testresults
- [x] **ABL-03**: Kapiteltext `kap8-fazit.md` — Kap. 8.1–8.2

## v2 Requirements

- Semantischer Feinschliff und stilistische Überarbeitung (Milestone v2)
- LaTeX-Konvertierung für Overleaf
- Abbildungsverzeichnis und Anhänge
- Zusammenführung aller .bib-Dateien in Gesamt-Bibliographie

## v4 Requirements — Milestone v4.0 Bestnoten-Optimierung

Jedes Requirement adressiert konkrete Lücken, die das Bewertungsformular auf weniger als volle Punktzahl drücken.
Zielzustand: Jedes der 12 Kriterien ist lückenlos erfüllt, alle Belege sind formell korrekt.

### SYST — Systematik

- [x] **SYST-01**: In Abb. 5.1 (Kap. 5.2) wird der veraltete Schwellenwert 0,65 durch den korrekt kalibrierten Wert 0,52 ersetzt — alle drei Darstellungen (Tab. 4.4, Tab. 5.1, Abb. 5.1) zeigen konsistent denselben Wert
- [x] **SYST-02**: Die State-Machine-Zustände IDLE, CANDIDATE, ACTIVE werden beim ersten Auftreten (Kap. 3.1 oder Kap. 4.3) explizit eingeführt und definiert, bevor sie in Kap. 4+ als bekannt vorausgesetzt werden

### LIT-R — Literaturrecherche

- [x] **LITR-01**: Ein BibTeX-Eintrag für die DSGVO (Verordnung 2016/679) wird in `user/sources.bib` ergänzt; alle bisherigen `[DSGVO 2016, Art. X]`-Zitate verweisen auf diesen Eintrag
- [x] **LITR-02**: Für mindestens 5 der arXiv-only-Quellen wird die veröffentlichte Konferenz-/Journal-Version identifiziert und der BibTeX-Eintrag auf die publizierte Version aktualisiert (CVPR/NeurIPS/ECCV/TPAMI-Proceedings bevorzugt)
- [x] **LITR-03**: Für den Vision-LLM Gaze-Check (Kap. 2.1.2, 3.2, 4.2) werden ≥2 aktuelle Peer-reviewed-Quellen zu VLM-basierter Bildklassifikation/Gaze-Schätzung recherchiert und eingebunden
- [x] **LITR-04**: `hogenhout2025biometricprivacy` (Preprint, noch nicht peer-reviewed) wird durch eine etablierte Datenschutz-/Biometrie-Quelle ergänzt oder ersetzt

### LIT-V — Verwendung der Literatur

- [x] **LITV-01**: Der CLIP-Absatz in Kap. 2.1.2 wird überarbeitet: entweder CLIP wird gestrichen und die Argumentation für den VLM-Ansatz direkt über Gemini/Instruction-Following-Literatur geführt, oder der Zusammenhang zu Gemini 2.5 Flash wird explizit und korrekt erklärt
- [x] **LITV-02**: Der Wert α=0,2 für das EMA-Blending (Kap. 5.3) wird mit einer spezifischen Quelle belegt, die EMA-Parameterwahl in Gesichtserkennungs- oder Embedding-Update-Kontexten behandelt — nicht nur Gardner 2006 (allgemeine Zeitreihen)
- [x] **LITV-03**: Alle fünf `barquero2020longtermtracking`-Zitate in Kap. 4–5 werden auf Relevanz geprüft: nur Stellen, an denen der Originalgehalt der Studie tatsächlich zur Argumentation beiträgt, werden beibehalten

### METH — Methoden und Werkzeuge

- [x] **METH-01**: Kap. 3 (Konzeption) wird um eine explizite Anforderungsanalyse erweitert: messbare Anforderungen (Latenz ≤ X ms, Erkennungsrate ≥ Y %, CPU-only) werden formuliert, gegen die Designentscheidungen nachvollziehbar geprüft werden können
- [x] **METH-02**: Kap. 7.1 (Evaluation) erhält eine ROC/Threshold-Kurven-Diskussion: der Tradeoff zwischen FAR und FRR bei unterschiedlichen Schwellenwerten wird explizit beschrieben und der gewählte Betriebspunkt (0,52) mit diesem Rahmen begründet

### FACH — Fachliche Bearbeitung

- [ ] **FACH-01**: Kap. 7 (Evaluation) erhält eine explizite Versuchsbeschreibung: Personenanzahl (N), Sitzungsanzahl, Beleuchtungsbedingungen und Messprotokolldauer werden angegeben — auch wenn N klein ist, muss der Rahmen beschrieben sein
- [ ] **FACH-02**: Der Gaze-Check via Vision-LLM (Tab. 3.1: „Nicht evaluiert") erhält zumindest eine qualitative Evaluation: False-Positive-Rate (Nicht-Interagierende werden fälschlich erkannt), False-Negative-Rate (aktive Nutzer werden abgewiesen) aus Beobachtungen im Entwicklungsbetrieb
- [ ] **FACH-03**: Die Robustheitsdimension Gruppen-Sessions (Kap. 6.3) wird in Kap. 7.3 mit mindestens einer beobachteten Größe belegt (z. B. Anteil Sessions mit >1 Person im Testbetrieb)

### WISS — Nutzung Fachwissen

- [x] **WISS-01**: Kap. 2.2.2 wird erweitert: der geometrische Unterschied zwischen ArcFace (Winkelmarge) und CosFace (Kosinusmarge) wird explizit erklärt — warum eine additive Winkelmarge stärker diskriminiert als eine Kosinusmarge
- [x] **WISS-02**: Die Wahl von `all-MiniLM-L12-v2` als RAG-Embedding-Modell (Kap. 6.2) wird mit einer Quelle oder einem messbaren Kriterium begründet (z. B. MTEB-Benchmark-Rang, Sentence-BERT-Vergleich)
- [x] **WISS-03**: Der α=0,2-Wert aus Kap. 5.3 erhält einen Literaturkontext: warum ist graduelles Blending für biometrische Langzeit-Embeddings sinnvoll (Verweis auf adaptive Embedding-Update-Methoden)

### WIRT — Wirtschaftliche Bewertung

- [x] **WIRT-01**: Kap. 3.6 (Wirtschaftliche Bewertung) wird um konkrete Kostenschätzungen erweitert: geschätzte Anzahl Gemini-API-Calls pro 8-Stunden-Kiosk-Tag (Gaze-Checks + Begrüßungen + Chats) und daraus resultierende Monatskosten bei SAP AI Core
- [x] **WIRT-02**: Ein Vergleich mit einer Cloud-API-Alternative (z. B. AWS Rekognition oder Azure Face API — Listenpreise öffentlich verfügbar) stellt die Open-Source/ONNX-Kosteneinsparung konkret dar

### NACH — Nachhaltigkeitsaspekte

- [x] **NACH-01**: Kap. 3 erhält einen eigenständigen Abschnitt 3.7 „Nachhaltigkeitsaspekte" (ca. 1/2 Seite), der drei Dimensionen behandelt: (1) ökologisch — CPU-Inferenz vs. GPU, Energieverbrauch im Dauerbetrieb; (2) ökonomisch — TCO Open-Source vs. proprietär; (3) sozial — demographische Fehlerraten biometrischer Systeme (Verweis auf Buolamwini/Gebru), gesellschaftliche Implikationen von Gesichtserkennung im öffentlichen Raum
- [x] **NACH-02**: Kap. 7 (Evaluation) verweist im Abschnitt Erkennungsgenauigkeit explizit auf die soziale Nachhaltigkeitsdimension (demographische Bias, Buolamwini 2018) und bewertet die Implikation für den SAP-Kiosk-Kontext

### UMSE — Umsetzbarkeit

- [x] **UMSE-01**: Kap. 3.4 oder 7 enthält eine Skalierbarkeitsaussage: HNSW-Suchkomplexität O(log N) wird auf das konkrete Szenario angewendet — ab welcher Profilanzahl (z. B. 10.000, 100.000) ist mit messbarer Latenzerhöhung zu rechnen?
- [x] **UMSE-02**: Kap. 8.2 (Ausblick) benennt einen konkreten Produktivierungspfad: die drei für einen DSGVO-konformen Produktiveinsatz noch fehlenden Schritte (Opt-in, DSFA Art. 35, Löschfunktion Art. 17) werden als umsetzbare Roadmap formuliert

### DOKU — Dokumentation

- [x] **DOKU-01**: Ein Anhang A „Systemparameter" wird angelegt und enthält eine Tabelle aller konfigurierbaren Parameter des Systems (CANDIDATE_SECS, LEAVE_SECS, SIMILARITY_THRESHOLD, FRAME_INTERVAL, GROUP_ARRIVAL_WINDOW_SECS, EMA-α) mit Wert, Einheit und Kap.-Verweis
- [x] **DOKU-02**: IDLE, CANDIDATE und ACTIVE werden am ersten Auftreten im Fließtext (spätestens Kap. 3.1) als definierte Bezeichnungen eingeführt, bevor sie ohne Erklärung in Kap. 4+ verwendet werden

### KREA — Kreativität

- [ ] **KREA-01**: Kap. 8.1 (Fazit) hebt explizit drei originelle Beiträge der Arbeit hervor: (1) Vision-LLM statt klassischer Gaze-Estimation als kalibrierungsfreie Interaktionsvalidierung, (2) spekulatives Pre-Computing der Begrüßung als Latenz-Engineering-Muster, (3) dreikanaliges Gedächtnisdesign (summary/facts_sentences/facts) als differenziertes Personalisierungskonzept
- [ ] **KREA-02**: Im Methodenabschnitt (Kap. 3 oder 4) wird für die ungewöhnlichste Designentscheidung (Vision-LLM-Gaze) explizit das verdrängerte naive Alternativvorgehen (klassische Gaze-Estimation mit Kalibrierung) beschrieben — um den Kreativitäts-Mehrwert kontrastierend sichtbar zu machen

### SELB — Selbstständigkeit

- [ ] **SELB-01**: An drei Schlüsselstellen der Arbeit (Modellwahl Kap. 3.3, Schwellenwert-Kalibrierung Kap. 5.1, EMA-α Kap. 5.3) wird die iterative Eigenentscheidung explizit formuliert: was war die naive/naheliegende Lösung, warum wurde sie verworfen, welche eigene Erkenntnis führte zur gewählten Lösung

## Out of Scope

| Feature | Reason |
|---------|--------|
| Deployment-Dokumentation (K8s, SAP AI Core) | Kein Untersuchungsgegenstand der Arbeit |
| V1-Prototyp als eigenes Kapitel | Nur für Entscheidungsbegründungen als Referenz |
| Neue Implementierungsarbeiten am Code | Arbeit dokumentiert bestehende Implementierung |
| Wikipedia als Quelle | Qualitätsanforderung ≥80% IEEE/ACM/Springer/Arxiv |

## Traceability

| Requirement | Phase | Status |
|-------------|-------|--------|
| VOR-01 | Phase 1 — Repo-Research | Complete |
| VOR-02 | Phase 1 — Repo-Research | Complete |
| KAP2-01 | Phase 2 — Grundlagen | Pending |
| KAP2-02 | Phase 2 — Grundlagen | Pending |
| KAP2-03 | Phase 2 — Grundlagen | Pending |
| KAP2-04 | Phase 2 — Grundlagen | Pending |
| KAP2-05 | Phase 2 — Grundlagen | Pending |
| KAP3-01 | Phase 3 — Konzeption | Pending |
| KAP3-02 | Phase 3 — Konzeption | Pending |
| KAP3-03 | Phase 3 — Konzeption | Pending |
| KAP3-04 | Phase 3 — Konzeption | Pending |
| KAP3-05 | Phase 3 — Konzeption | Pending |
| KAP3-06 | Phase 3 — Konzeption | Pending |
| KAP4-01 | Phase 4 — Personenerkennung | Pending |
| KAP4-02 | Phase 4 — Personenerkennung | Pending |
| KAP5-01 | Phase 5 — Identifikation | Pending |
| KAP5-02 | Phase 5 — Identifikation | Pending |
| KAP6-01 | Phase 6 — Personalisierung | Pending |
| KAP6-02 | Phase 6 — Personalisierung | Pending |
| ABL-01 | Phase 7 — Abschluss | Complete |
| ABL-02 | Phase 7 — Abschluss | Complete |
| ABL-03 | Phase 7 — Abschluss | Complete |
| SYST-01 | Phase 31 — Systematik | Complete |
| SYST-02 | Phase 31 — Systematik | Complete |
| LITR-01 | Phase 32 — Literaturrecherche | Complete |
| LITR-02 | Phase 32 — Literaturrecherche | Complete |
| LITR-03 | Phase 32 — Literaturrecherche | Complete |
| LITR-04 | Phase 32 — Literaturrecherche | Complete |
| LITV-01 | Phase 33 — Verwendung der Literatur | Complete |
| LITV-02 | Phase 33 — Verwendung der Literatur | Complete |
| LITV-03 | Phase 33 — Verwendung der Literatur | Complete |
| METH-01 | Phase 34 — Methoden und Werkzeuge | Complete |
| METH-02 | Phase 34 — Methoden und Werkzeuge | Complete |
| FACH-01 | Phase 35 — Fachliche Bearbeitung | Pending |
| FACH-02 | Phase 35 — Fachliche Bearbeitung | Pending |
| FACH-03 | Phase 35 — Fachliche Bearbeitung | Pending |
| WISS-01 | Phase 36 — Nutzung Fachwissen | Complete |
| WISS-02 | Phase 36 — Nutzung Fachwissen | Complete |
| WISS-03 | Phase 36 — Nutzung Fachwissen | Complete |
| WIRT-01 | Phase 37 — Wirtschaftliche Bewertung | Complete |
| WIRT-02 | Phase 37 — Wirtschaftliche Bewertung | Complete |
| NACH-01 | Phase 38 — Nachhaltigkeitsaspekte | Complete |
| NACH-02 | Phase 38 — Nachhaltigkeitsaspekte | Complete |
| UMSE-01 | Phase 39 — Umsetzbarkeit | Complete |
| UMSE-02 | Phase 39 — Umsetzbarkeit | Complete |
| DOKU-01 | Phase 40 — Dokumentation | Complete |
| DOKU-02 | Phase 40 — Dokumentation | Complete |
| KREA-01 | Phase 41 — Kreativität | Pending |
| KREA-02 | Phase 41 — Kreativität | Pending |
| SELB-01 | Phase 42 — Selbstständigkeit | Pending |

**Coverage:**
- v1 requirements: 22 total
- v4 requirements: 27 total
- Mapped to phases: 49
- Unmapped: 0 ✓

---
*Requirements defined: 2026-06-12*
*Last updated: 2026-07-17 — Traceability um v4-Anforderungen (Phasen 31–42) erweitert*