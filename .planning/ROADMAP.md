# Roadmap: T2000 — Biometrische Personalisierung eines KI-Assistenten

## Overview

Die Studienarbeit dokumentiert, begründet und evaluiert ein vollständig implementiertes kamerabasiertes Identifikationssystem. Der Weg führt von der systematischen Wissensextraktion aus dem Repo (Phase 1) über die akademische Quellenarbeit und das Schreiben der fünf Hauptkapitel (Phasen 2–6) bis zum Abschluss mit Einleitung, Evaluation und Fazit (Phase 7).

## Phases

**Phase Numbering:**

- Integer phases (1–7): Geplante Meilensteinarbeit in fester Reihenfolge

- [x] **Phase 1: Repo-Research** — Systematische Extraktion aller relevanten Informationen aus Codebase, Docs und Bewertungs-PDF in ein strukturiertes Forschungsdokument
- [x] **Phase 2: Grundlagen** — Quellenrecherche und Kapiteltext zu Gesichtsdetektion, biometrischer Identifikation und LLM-Gedächtnis (completed 2026-06-15)
- [x] **Phase 3: Konzeption** — Quellenrecherche und Kapiteltext zur Systemarchitektur und allen Designentscheidungen (completed 2026-06-15)
- [x] **Phase 4: Personenerkennung** — Quellenrecherche und Kapiteltext zur BlazeFace-Pipeline, Gaze-Validierung und State Machine (completed 2026-06-15)
- [x] **Phase 5: Identifikation** — Quellenrecherche und Kapiteltext zu InsightFace-Embeddings, zweistufigem Tracking und Qdrant-Persistenz (completed 2026-06-15)
- [x] **Phase 6: Personalisierung** — Quellenrecherche und Kapiteltext zu Zusammenfassung, RAG-Retrieval und Gruppen-Sessions (completed 2026-06-15)
- [x] **Phase 7: Abschluss** — Einleitung (Kap. 1), Evaluation (Kap. 7) und Fazit (Kap. 8) schreiben (completed 2026-06-16)

## Phase Details

### Phase 1: Repo-Research

**Goal**: Alle relevanten Informationen aus T2000, ai-infopoint-prototyp und dem Bewertungs-PDF sind in einem strukturierten Dokument verfügbar — als verlässliche Wissensgrundlage für alle folgenden Kapitelphasen.
**Depends on**: Nothing (first phase)
**Requirements**: VOR-01, VOR-02
**Success Criteria** (what must be TRUE):

  1. `.planning/research/REPO-RESEARCH.md` existiert und enthält strukturiert: Architekturentscheidungen mit Begründungen, Testergebnisse mit Messwerten, alle relevanten Code-Komponenten (state_machine, tracker, face_id, db/store) und die Evolutionsgeschichte v1→v2
  2. Die Bewertungskriterien aus `Bewertung_Projekt_Studien_Bachelor.pdf` sind als strukturiertes Markdown extrahiert und explizit auf Kapitel der Arbeit gemappt
  3. Jede der 8 Key Decisions aus PROJECT.md ist im Repo-Research-Dokument mit Quelldatei-Referenz und konkreten Messwerten belegt

**Plans**: 2 plans

Plans:

- [x] 01-01-PLAN.md — REPO-RESEARCH.md (Code, Docs, Changelogs nach Komponenten gegliedert)
- [x] 01-02-PLAN.md — BEWERTUNG-CRITERIA.md (Bewertungs-PDF strukturiert + Kapitel-Mapping)

### Phase 2: Grundlagen

**Goal**: Kapitel 2 ist fertig — akademisch fundierter Überblick über Gesichtsdetektion, biometrische Identifikation und LLM-Gedächtnis, der genau den theoretischen Rahmen für die eigene Implementierung aufspannt.
**Depends on**: Phase 1
**Requirements**: KAP2-01, KAP2-02, KAP2-03, KAP2-04, KAP2-05
**Success Criteria** (what must be TRUE):

  1. `kap2-grundlagen-sources.md` und `kap2-grundlagen-sources.bib` existieren mit annotierten Quellen (≥80% IEEE/ACM/Springer/Arxiv) für alle drei Abschnitte (2.1 Detektion, 2.2 Embeddings/ArcFace, 2.3 RAG/Gedächtnis)
  2. `kap2-grundlagen.md` enthält alle drei Abschnitte (2.1–2.3) mit Inline-Zitaten `[Autor Jahr, S. X]` und direktem Bezug zur eigenen Implementierung
  3. Jedes Konzept (BlazeFace, Angular Margin Loss, Kontextfenster-Problem, RAG) ist so erklärt, dass der Leser die Implementierungsentscheidungen in Kap. 3–6 versteht

**Plans**: 2 plans

Plans:
**Wave 1**

- [x] 02-01-PLAN.md — Wave 1: Quellenrecherche (kap2-grundlagen-sources.md + .bib)

**Wave 2** *(blocked on Wave 1 completion)*

- [x] 02-02-PLAN.md — Wave 2: Kapiteltext schreiben (kap2-grundlagen.md)

### Phase 3: Konzeption

**Goal**: Kapitel 3 ist fertig — jede architektonische Hauptentscheidung (Detektion, Erkennungsmodell, Persistenz, Datenschutz, Wirtschaftlichkeit) ist mit akademischen Quellen und konkreten Messwerten nachvollziehbar begründet.
**Depends on**: Phase 2
**Requirements**: KAP3-01, KAP3-02, KAP3-03, KAP3-04, KAP3-05, KAP3-06
**Success Criteria** (what must be TRUE):

  1. `kap3-konzeption-sources.md` und `kap3-konzeption-sources.bib` existieren mit Quellen für Systemarchitektur, Modellvergleiche und Datenschutzgrundlagen
  2. `kap3-konzeption.md` enthält alle Abschnitte 3.1–3.6 mit Entscheidungstabellen (MediaPipe vs. YOLO vs. Vision-LLM; InsightFace vs. DeepFace; SQLite vs. Qdrant) und quantitativen Belegen (z.B. 99,83% vs. 92%, 80ms vs. 300ms)
  3. Der Leser kann nach Kap. 3 jede Technologiewahl des Systems eigenständig nachvollziehen und bewerten

**Plans**: 2 plans

Plans:
**Wave 1**

- [x] 03-01-PLAN.md — Wave 1: Quellenrecherche (kap3-konzeption-sources.md + .bib)

**Wave 2** *(blocked on Wave 1 completion)*

- [x] 03-02-PLAN.md — Wave 2: Kapiteltext schreiben (kap3-konzeption.md)

### Phase 4: Personenerkennung

**Goal**: Kapitel 4 ist fertig — die vollständige Implementierung der Personenerkennungs-Pipeline (BlazeFace-Detektion, Gaze-Validierung, State Machine IDLE→CANDIDATE→ACTIVE, Multi-Person-Tracking) ist beschrieben und technisch erklärt.
**Depends on**: Phase 3
**Requirements**: KAP4-01, KAP4-02
**Success Criteria** (what must be TRUE):

  1. `kap4-personenerkennung-sources.md` und `.bib` existieren mit Quellen für BlazeFace/MediaPipe und Gaze-Estimation
  2. `kap4-personenerkennung.md` enthält alle vier Abschnitte (4.1–4.4): Die State-Machine-Übergänge sind mit Zustandsdiagramm-Beschreibung dokumentiert, das Gaze-Validierungsverfahren via Vision-LLM ist erklärt, und paralleles Multi-Person-Tracking ist dargestellt
  3. Ein Leser kann anhand von Kap. 4 allein die presence/state_machine.py und tracker.py nachvollziehen

**Plans**: 2 plans

Plans:

**Wave 1**

- [x] 04-01: Wave 1 — Quellenrecherche (kap4-personenerkennung-sources.md + .bib)

**Wave 2** *(blocked on Wave 1 completion)*

- [x] 04-02: Wave 2 — Kapiteltext schreiben (kap4-personenerkennung.md)

### Phase 5: Identifikation

**Goal**: Kapitel 5 ist fertig — die Identifikationslogik (InsightFace-Embeddings, zweistufiges Tracking mit positionsbasiertem Prä-Filter, Qdrant-Persistenz mit EMA-Blending) ist vollständig und nachvollziehbar dokumentiert.
**Depends on**: Phase 4
**Requirements**: KAP5-01, KAP5-02
**Success Criteria** (what must be TRUE):

  1. `kap5-identifikation-sources.md` und `.bib` existieren mit Quellen für InsightFace/buffalo_l, ArcFace-Loss, Vektordatenbanken und EMA
  2. `kap5-identifikation.md` enthält alle drei Abschnitte (5.1–5.3): Embedding-Berechnung mit ONNX-Optimierung erklärt, zweistufiges Tracking (Position → ArcFace-Score) begründet, Qdrant-Migration (SQLite-Deadlock auf K8s) dokumentiert
  3. Der FaceStore-Interface-Ansatz (Austauschbarkeit der Persistenzschicht) ist als Entwurfsentscheidung klar herausgearbeitet

**Plans**: 2 plans

Plans:

**Wave 1**

- [x] 05-01-PLAN.md — Wave 1: Quellenrecherche (kap5-identifikation-sources.md + .bib)

**Wave 2** *(blocked on Wave 1 completion)*

- [x] 05-02-PLAN.md — Wave 2: Kapiteltext schreiben (kap5-identifikation.md)

### Phase 6: Personalisierung

**Goal**: Kapitel 6 ist fertig — die sitzungsübergreifende Personalisierung (Zusammenfassung/Fakt-Extraktion per JSON-Schema, RAG-Chunk-Retrieval, Gruppen-Sessions mit History-Isolation) ist vollständig dokumentiert.
**Depends on**: Phase 5
**Requirements**: KAP6-01, KAP6-02
**Success Criteria** (what must be TRUE):

  1. `kap6-personalisierung-sources.md` und `.bib` existieren mit Quellen für RAG, LLM-Gedächtnisarchitekturen und Gesprächszusammenfassung
  2. `kap6-personalisierung.md` enthält alle drei Abschnitte (6.1–6.3): Zusammenfassungsstrategie (strukturierte Faktextraktion statt rohe History) mit Begründung, RAG-Retrieval-Mechanismus, und History-Isolation bei Gruppen-Sessions
  3. Der Leser versteht, warum strukturierte Faktextraktion statt roher Gesprächshistorie gewählt wurde (Kontextfenster-Problem)

**Plans**: 2 plans

Plans:

**Wave 1**

- [x] 06-01: Wave 1 — Quellenrecherche (kap6-personalisierung-sources.md + .bib)

**Wave 2** *(blocked on Wave 1 completion)*

- [x] 06-02: Wave 2 — Kapiteltext schreiben (kap6-personalisierung.md)

### Phase 7: Abschluss

**Goal**: Die Arbeit ist vollständig — Einleitung (Kap. 1), Evaluation (Kap. 7) mit Messwerten und Diskussion, und Fazit (Kap. 8) mit Ausblick sind fertig und referenzieren korrekt alle vorherigen Kapitel.
**Depends on**: Phase 6
**Requirements**: ABL-01, ABL-02, ABL-03
**Success Criteria** (what must be TRUE):

  1. `kap1-einleitung.md` enthält Abschnitte 1.1–1.3: Problemstellung (öffentlicher KI-Assistent ohne Login), Forschungsfrage explizit formuliert, und Kapitelüberblick der gesamten Arbeit
  2. `kap7-evaluation.md` enthält Abschnitte 7.1–7.4 mit konkreten Messwerten aus TESTRESULTS_v1.1.md: TAR/FAR-Werte, Latenzmessungen, Robustheitstest-Ergebnisse (Winkel, Beleuchtung, Multi-Person) und eine kritische Diskussion
  3. `kap8-fazit.md` beantwortet die Forschungsfrage direkt (8.1) und skizziert konkrete Weiterentwicklungsmöglichkeiten (8.2 Ausblick)
  4. Einleitung referenziert korrekt alle Kapitel 2–8; Fazit referenziert korrekt Evaluationsergebnisse aus Kap. 7

**Plans**: TBD

Plans:

**Wave 1**

- [x] 07-01: Einleitung schreiben (kap1-einleitung.md)

**Wave 2** *(blocked on Wave 1 completion)*

- [x] 07-02: Evaluation schreiben (kap7-evaluation.md)

**Wave 3** *(blocked on Wave 2 completion)*

- [x] 07-03: Fazit schreiben (kap8-fazit.md)

## Progress — Milestone v1.0 (abgeschlossen)

| Phase | Plans Complete | Status | Completed |
|-------|----------------|--------|-----------|
| 1. Repo-Research | 2/2 | Complete | 2026-06-12 |
| 2. Grundlagen | 2/2 | Complete | 2026-06-15 |
| 3. Konzeption | 2/2 | Complete | 2026-06-15 |
| 4. Personenerkennung | 2/2 | Complete | 2026-06-15 |
| 5. Identifikation | 2/2 | Complete | 2026-06-15 |
| 6. Personalisierung | 2/2 | Complete | 2026-06-15 |
| 7. Abschluss | 3/3 | Complete | 2026-06-16 |

---

## Milestone v2.0 — Revision aller Kapitel

**Ziel:** Jedes Kapitel wird eigenständig kritisch überarbeitet (Kritikpunkte → KRITIK.md), dann überarbeitet (Quellen aus IEEE/ACM/Springer/Arxiv), dann abschließend geprüft. Jeder Absatz erhält mind. 2 Belege. Abschließend: Quercheck aller Kapitel auf Konsistenz und Wiederholungen.

**Regel Quellen:** Nur IEEE / ACM / Springer / Arxiv. Keine Repos. Jeder Absatz mind. 2 Quellen (Wiederholungen erlaubt wo passend).

**Wave-Struktur pro Phase:**

- Wave 1 — Kapitel kritisch durchgehen, alle Schwächen in KRITIK.md (eigener Abschnitt)
- Wave 2 — Kritikpunkte im Kapitel beheben, fehlende Quellen recherchieren
- Wave 3 — Finaler Durchgang: keine offenen Kritikpunkte mehr

- [x] **Phase 8: Revision Kap. 1 — Einleitung** *(aktuell)* (completed 2026-06-16)
- [ ] **Phase 9: Revision Kap. 2 — Grundlagen**
- [x] **Phase 10: Revision Kap. 3 — Konzeption** (completed 2026-06-16)
- [x] **Phase 11: Revision Kap. 4 — Personenerkennung** (completed 2026-06-16)
- [x] **Phase 12: Revision Kap. 5 — Identifikation** (completed 2026-06-16)
- [ ] **Phase 13: Revision Kap. 6 — Personalisierung**
- [x] **Phase 14: Revision Kap. 7 — Evaluation** (completed 2026-06-16)
- [x] **Phase 15: Revision Kap. 8 — Fazit** (completed 2026-06-16)
- [x] **Phase 16: Querschnitt — Kapitelübergreifende Konsistenz** (completed 2026-06-17)

### Phase 8: Revision Kap. 1 — Einleitung

**Goal**: kap1-einleitung.md ist vollständig überarbeitet — alle Kritikpunkte aus KRITIK.md behoben, jeder Absatz hat mind. 2 Quellen (IEEE/ACM/Springer/Arxiv), sachlich korrekt, keine Lösungshinweise in der Problemstellung, kein doppelter Aufbau.
**Depends on**: Phase 7 (Milestone v1.0)
**File**: projektarbeit/kapitel/kap1-einleitung.md
**Kritik-Abschnitt**: KRITIK.md → ## Kap. 1 — Einleitung

**Plans:** 3/3 plans complete

Plans:
**Wave 1**

- [x] 08-01-PLAN.md — Wave 1: Kap. 1 kritisch analysieren, alle Schwächen in KRITIK.md dokumentieren (inkl. Quellencheck)

**Wave 2** *(blocked on Wave 1 completion)*

- [x] 08-02-PLAN.md — Wave 2: Alle Kritikpunkte beheben, fehlende Quellen recherchieren und einbauen (kap1-einleitung-sources.md + .bib)

**Wave 3** *(blocked on Wave 2 completion)*

- [x] 08-03-PLAN.md — Wave 3: Finalcheck — alle Kritikpunkte als behoben bestätigen, KRITIK.md abschließen

### Phase 9: Revision Kap. 2 — Grundlagen

**Goal**: kap2-grundlagen.md ist vollständig überarbeitet — nur Theorie die tatsächlich im System genutzt wird, jeder Absatz mind. 2 Quellen, kein Lehrbuch-Overhead, klarer Bezug zur eigenen Implementierung.
**Depends on**: Phase 8
**File**: projektarbeit/kapitel/kap2-grundlagen.md
**Kritik-Abschnitt**: KRITIK.md → ## Kap. 2 — Grundlagen

**Wave 1 — Kritik sammeln:**

- [x] 09-01: Kap. 2 eigenständig durchgehen → alle Unstimmigkeiten in KRITIK.md (Abschnitt Kap. 2)

**Wave 2 — Überarbeiten:**

- [x] 09-02: Alle Kritikpunkte beheben, fehlende Quellen recherchieren

**Wave 3 — Finalcheck:**

- [x] 09-03: Kap. 2 nochmals prüfen — keine offenen Kritikpunkte

### Phase 10: Revision Kap. 3 — Konzeption

**Goal**: kap3-konzeption.md ist vollständig überarbeitet — Tabellen vor Fließtext, alle Tabellenzeilen im Text besprochen, jeder Absatz mind. 2 Quellen.
**Depends on**: Phase 9
**File**: projektarbeit/kapitel/kap3-konzeption.md
**Kritik-Abschnitt**: KRITIK.md → ## Kap. 3 — Konzeption

**Plans:** 3/3 plans complete

Plans:
**Wave 1**

- [x] 10-01-PLAN.md — Wave 1: Kap. 3 kritisch analysieren, alle Schwächen in KRITIK.md dokumentieren (inkl. Quellencheck)

**Wave 2** *(blocked on Wave 1 completion)*

- [x] 10-02-PLAN.md — Wave 2: Alle Kritikpunkte beheben, fehlende Quellen recherchieren und einbauen (kap3-konzeption-sources.md + .bib)

**Wave 3** *(blocked on Wave 2 completion)*

- [x] 10-03-PLAN.md — Wave 3: Finalcheck — alle Kritikpunkte als behoben bestätigen, KRITIK.md abschließen

### Phase 11: Revision Kap. 4 — Personenerkennung

**Goal**: kap4-personenerkennung.md ist vollständig überarbeitet — kein falscher Einstieg mit verworfener Technologie, Sachfehler State Machine behoben, jeder Absatz mind. 2 Quellen.
**Depends on**: Phase 10
**File**: projektarbeit/kapitel/kap4-personenerkennung.md
**Kritik-Abschnitt**: KRITIK.md → ## Kap. 4 — Personenerkennung

**Wave 1 — Kritik sammeln:**

- [x] 11-01: Kap. 4 eigenständig durchgehen → alle Unstimmigkeiten in KRITIK.md

**Wave 2 — Überarbeiten:**

- [x] 11-02: Alle Kritikpunkte beheben, fehlende Quellen recherchieren

**Wave 3 — Finalcheck:**

- [x] 11-03: Kap. 4 nochmals prüfen — keine offenen Kritikpunkte

### Phase 12: Revision Kap. 5 — Identifikation

**Goal**: kap5-identifikation.md ist vollständig überarbeitet — kein dreifach-definierter Schwellenwert, keine ArcFace-Wiederholung, kein upsert_profile()-Vorgriff, jeder Absatz mind. 2 Quellen.
**Depends on**: Phase 11
**File**: projektarbeit/kapitel/kap5-identifikation.md
**Kritik-Abschnitt**: KRITIK.md → ## Kap. 5 — Identifikation

**Wave 1 — Kritik sammeln:**

- [x] 12-01: Kap. 5 eigenständig durchgehen → alle Unstimmigkeiten in KRITIK.md

**Wave 2 — Überarbeiten:**

- [x] 12-02: Alle Kritikpunkte beheben, fehlende Quellen recherchieren

**Wave 3 — Finalcheck:**

- [x] 12-03: Kap. 5 nochmals prüfen — keine offenen Kritikpunkte

### Phase 13: Revision Kap. 6 — Personalisierung

**Goal**: kap6-personalisierung.md ist vollständig überarbeitet, jeder Absatz mind. 2 Quellen.
**Depends on**: Phase 12
**File**: projektarbeit/kapitel/kap6-personalisierung.md
**Kritik-Abschnitt**: KRITIK.md → ## Kap. 6 — Personalisierung

**Wave 1 — Kritik sammeln:**

- [ ] 13-01: Kap. 6 eigenständig durchgehen → alle Unstimmigkeiten in KRITIK.md

**Wave 2 — Überarbeiten:**

- [ ] 13-02: Alle Kritikpunkte beheben, fehlende Quellen recherchieren

**Wave 3 — Finalcheck:**

- [ ] 13-03: Kap. 6 nochmals prüfen — keine offenen Kritikpunkte

### Phase 14: Revision Kap. 7 — Evaluation

**Goal**: kap7-evaluation.md ist vollständig überarbeitet, jeder Absatz mind. 2 Quellen.
**Depends on**: Phase 13
**File**: projektarbeit/kapitel/kap7-evaluation.md
**Kritik-Abschnitt**: KRITIK.md → ## Kap. 7 — Evaluation

**Wave 1 — Kritik sammeln:**

- [x] 14-01: Kap. 7 eigenständig durchgehen → alle Unstimmigkeiten in KRITIK.md

**Wave 2 — Überarbeiten:**

- [x] 14-02: Alle Kritikpunkte beheben, fehlende Quellen recherchieren

**Wave 3 — Finalcheck:**

- [x] 14-03: Kap. 7 nochmals prüfen — keine offenen Kritikpunkte

### Phase 15: Revision Kap. 8 — Fazit

**Goal**: kap8-fazit.md ist vollständig überarbeitet, jeder Absatz mind. 2 Quellen.
**Depends on**: Phase 14
**File**: projektarbeit/kapitel/kap8-fazit.md
**Kritik-Abschnitt**: KRITIK.md → ## Kap. 8 — Fazit

**Wave 1 — Kritik sammeln:**

- [x] 15-01: Kap. 8 eigenständig durchgehen → alle Unstimmigkeiten in KRITIK.md

**Wave 2 — Überarbeiten:**

- [x] 15-02: Alle Kritikpunkte beheben, fehlende Quellen recherchieren

**Wave 3 — Finalcheck:**

- [x] 15-03: Kap. 8 nochmals prüfen — keine offenen Kritikpunkte

### Phase 16: Querschnitt — Kapitelübergreifende Konsistenz

**Goal**: Alle Kapitel sind konsistent — keine Wiederholungen, keine widersprüchlichen Querverweise, alle Verweise (z.B. "Kap. 3", "vgl. 5.1") stimmen. Ergebnis: KONSISTENZ.md mit Befunden.
**Depends on**: Phase 15
**File**: projektarbeit/KONSISTENZ.md (wird neu angelegt)

**Plans:** 2/2 plans complete

Plans:
**Wave 1**

- [x] 16-01-PLAN.md — Wave 1: Alle Kapitel auf Wiederholungen und unstimmige Verweise prüfen → KONSISTENZ.md (Sektionen Querverweise, Wiederholungen, Begriffe, Inkonsistenzen, Arbeitspaket)

**Wave 2** *(blocked on Wave 1 completion)*

- [x] 16-02-PLAN.md — Wave 2: Befunde in den betroffenen Kapiteln beheben, KONSISTENZ.md mit Status-Spalte abschließen

### Phase 17: Konsolidierung Runde 4 — Projektweite Nachschau

**Goal**: Alle 9 offenen Kritikpunkte aus KRITIK.md „Runde 4" (KP-R4-01 bis KP-R4-09) sind in den betroffenen Kapiteln behoben — keine Erklärung nicht-genutzter Technologien, keine Quellen-Fehlattributionen, kein Inhalt im falschen Kapitel, keine Doppel-Argumentationen.
**Depends on**: Phase 16
**Files**: projektarbeit/kapitel/kap2-grundlagen.md, kap3-konzeption.md, kap5-identifikation.md, kap6-personalisierung.md, kap7-evaluation.md
**Kritik-Abschnitt**: KRITIK.md → ## Runde 4 — Projektweite Konsolidierungs-Nachschau

**Plans:** 2/2 plans complete

Plans:
**Wave 1**

- [x] 17-01-PLAN.md — Wave 1: KP-R4-01, -02, -03 (hoch) beheben — Kap. 2, 5, 6

**Wave 2** *(blocked on Wave 1 completion)*

- [x] 17-02-PLAN.md — Wave 2: KP-R4-04 bis -09 (mittel/niedrig) beheben + alle Status auf behoben setzen + KRITIK.md abschließen

## Progress — Milestone v2.0 (laufend)

**Execution Order:** 8 → 9 → 10 → 11 → 12 → 13 → 14 → 15 → 16 → 17

| Phase | Waves | Status | Gestartet |
|-------|-------|--------|-----------|
| 8. Revision Kap. 1 | 3/3 | Complete   | 2026-06-16 |
| 9. Revision Kap. 2 | 0/3 | Pending | — |
| 10. Revision Kap. 3 | 3/3 | Complete    | 2026-06-16 |
| 11. Revision Kap. 4 | 3/3 | Complete    | 2026-06-16 |
| 12. Revision Kap. 5 | 3/3 | Complete    | 2026-06-16 |
| 13. Revision Kap. 6 | 0/3 | Pending | — |
| 14. Revision Kap. 7 | 3/3 | Complete   | 2026-06-16 |
| 15. Revision Kap. 8 | 3/3 | Complete    | 2026-06-16 |
| 16. Querschnitt | 2/2 | Complete    | 2026-06-17 |
| 17. Konsolidierung Runde 4 | 2/2 | Complete    | 2026-06-17 |

---

## Milestone v3.0 — Stilrevision & Inhaltliche Bereinigung (final_kritik.md)

**Ziel:** Alle Kritikpunkte aus `final_kritik.md → # Eigene kritik` (Kap. 2–6) sind behoben — Sprache klingt wie von einem Studenten (nicht gestochen), Fachbegriffe nur mit Erklärung, veraltete/falsche Fakten aus dem Repo verifiziert und korrigiert, praxisferne technische Details gestrichen, fehlende Begründungen ergänzt.

**Quell-Dokument:** `projektarbeit/final_kritik.md` — Abschnitt `# Eigene kritik` (Zeilen 551–797)

**Leit-Prinzip:** Der Leser ist kein Experte. Jeder Fachbegriff entweder erklären oder streichen. Sprache: präzise aber verständlich, keine „diskriminativen Embeddings im Vektorraum", stattdessen „Gesichter derselben Person liegen nah beieinander, Gesichter verschiedener Personen weiter auseinander."

**Fakten-Regel:** Alle konkreten Werte (Schwellwerte, Modellnamen, Dimensionen, Timeouts) **immer gegen das Repo** verifizieren — Quelle: `volt-ai-assistant/presence/config.py`, `face_id.py`, `tracker.py`, `db/store.py`, `backend/routers/summarize.py`.

**Bekannte Repo-Fakten (verifiziert 2026-07-13):**
- `SIMILARITY_THRESHOLD` = 0.65 (Code-Default) — via Env `SIMILARITY_THRESHOLD=0.22` in `.env`-Beispiel → `.env`-Wert gilt im Betrieb
- `CANDIDATE_SECS` = 4.0 s ✓
- `LEAVE_SECS` = 10.0 s ✓
- `EMBEDDING_BLEND_ALPHA` = 0.2 ✓ (= α in EMA)
- RAG-Embedding-Modell: `text-embedding-3-small` (OpenAI-kompatibel via SAP AI Core)
- `RAG_ENABLED` = false (laut `.env`-Beispiel in final_kritik.md)
- Greeting-Modell: `gemini-2.5-flash`
- `pin_latest`-Mechanismus: existiert im Code ✓
- ResNet: `w600k_r50` = ResNet**50** (nicht ResNet100)

---

### Phase 18: Kap. 2 — Sprache & Inhalt bereinigen

**Goal:** kap2-grundlagen.md klingt durchgehend wie eine verständliche Studentenarbeit — kein gestochen-akademischer Jargon, alle Fachbegriffe erklärt oder gestrichen, die drei größten inhaltlichen Probleme behoben (HNSW-Absatz überarbeitet, ArcFace-Loss-Formel-Block vereinfacht, MemGPT-Absatz entfernt/gekürzt, embedding-Dimension verifiziert).
**Depends on:** Milestone v2.0
**File:** projektarbeit/kapitel/kap2-grundlagen.md

**Kritikpunkte (aus final_kritik.md):**
1. Fachbegriffe ohne Erklärung: „Single-Shot-Detektor", „Anchor-Schema", „Lightweight-Detektoren", „Zero-Shot-Klassifikation", „CNN", „diskriminativen Embeddings im Vektorraum"
2. HNSW-Absatz (Approximate-Nearest-Neighbor) wirkt fehl am Platz und zu technisch — überarbeiten oder kürzen
3. ArcFace-Loss-Block mit Formel und geometrischen Erklärungen: viel zu komplex/gestochen — nur die verständlichen Kernaussagen behalten
4. MemGPT/Virtual-Context-Absatz: Zusammenhang zum System ist schwach — kürzen oder entfernen
5. Embedding-Dimensionen (`text-embedding-3-small` = 1536?) — gegen Repo verifizieren
6. Inferenz-Zeit-Infos entfernen (zu viel Implementierungsdetail in Kap. 2)

**Wave-Struktur:**
- Wave 1 — Repo-Fakten verifizieren (config.py, llm.py, store.py), alle Sprachprobleme sammeln und im Text markieren
- Wave 2 — Überarbeitung: Jargon ersetzen, Formel-Block kürzen, MemGPT prüfen, HNSW vereinfachen
- Wave 3 — Finalcheck: kein unerklärer Fachbegriff, keine rein technischen Implementierungsdetails, Sprache „Studenten-tauglich"

Plans:
**Wave 1**
- [ ] 18-01-PLAN.md — Kap. 2 Sprach- und Inhalts-Audit: alle Jargon-Stellen + Faktenprobleme markieren

**Wave 2** *(blocked on Wave 1)*
- [ ] 18-02-PLAN.md — Überarbeitung: Jargon → verständliche Sprache, Inhalt bereinigen

**Wave 3** *(blocked on Wave 2)*
- [ ] 18-03-PLAN.md — Finalcheck Kap. 2

---

### Phase 19: Kap. 3 — Fakten, Sprache, Inhalt

**Goal:** kap3-konzeption.md enthält keine veralteten Fakten, keine gestochen-technischen Formulierungen, SQLite-Deadlock-Absatz ist entweder gestrichen oder vereinfacht, HANA-Passage ist korrekt begründet (nicht Betriebskosten als Argument bei SAP).
**Depends on:** Phase 18
**File:** projektarbeit/kapitel/kap3-konzeption.md

**Kritikpunkte (aus final_kritik.md):**
1. Faktenfehler: Modell-Name für STT prüfen — „Whisper large-v3-turbo" noch aktuell?
2. Systemdiagramm (Mermaid): Gegen aktuellen Repo-Stand verifizieren — v.a. Modellnamen, State-Machine-Zustände, Service-Namen
3. Erklärung fehlt: „Seitenansichten = Passanten" — das Prinzip (wer nur vorbeigeht vs. wer aktiv schaut) besser in Klartext erklären, nicht nur technisch
4. Zu gestochen: „Zero-Shot-Fähigkeit multimodaler Modelle", „Tracking-by-Detection-Muster"
5. SQLite-Deadlock-Absatz: zu technisch und unnötig — entweder kürzen oder komplett streichen
6. HANA-Passage: Betriebskosten-Argument unpassend (SAP-Kontext) — mit korrekter Begründung ersetzen
7. `conversation_chunks` 1536-dim: gegen Repo verifizieren

**Wave-Struktur:**
- Wave 1 — Fakten verifizieren (Mermaid-Diagramm gegen Code, Modellnamen, Dimensionen), Sprach-Probleme sammeln
- Wave 2 — Überarbeitung: Diagramm korrigieren, Jargon ersetzen, SQLite-Block kürzen, HANA-Begründung überarbeiten
- Wave 3 — Finalcheck

Plans:
**Wave 1**
- [x] 19-01-PLAN.md — Kap. 3 Fakten-Audit + Sprach-Sammlung (Mermaid vs. Code, Modellnamen)

**Wave 2** *(blocked on Wave 1)*
- [x] 19-02-PLAN.md — Überarbeitung Kap. 3

**Wave 3** *(blocked on Wave 2)*
- [x] 19-03-PLAN.md — Finalcheck Kap. 3

---

### Phase 20: Kap. 4 — Begründungen & Sprache

**Goal:** kap4-personenerkennung.md erklärt die Designentscheidungen praxisnah (warum 6%-Filter, warum 4s-Fenster, wie Wegschauen toleriert wird), kein unnötiger BlazeFace-Rückverweis-Satz, keine gestochen-technische Sprache.
**Depends on:** Phase 19
**File:** projektarbeit/kapitel/kap4-personenerkennung.md

**Kritikpunkte (aus final_kritik.md):**
1. Unnötiger Meta-Satz: „BlazeFace — Architektur und Echtzeit-Eignung sind in Kap. 2.1.1 beschrieben — wird hier über die MediaPipe-Perception-Pipeline angesprochen, die das TFLite-Modell..." → streichen
2. `MIN_FACE_WIDTH_RATIO = 0.06` — Begründung fehlt: warum ist es schlecht wenn zu weit entfernte Personen erkannt werden? Praxisbeispiel ergänzen
3. `CANDIDATE_SECS = 4.0` — gegen config.py verifizieren ✓ (korrekt)
4. Toleranz-Mechanismus für kurzes Wegschauen: wie es technisch gemacht wird fehlt — `gone_since`-Timer erklären
5. Sprache: wo zu gestochen → vereinfachen

**Wave-Struktur:**
- Wave 1 — Stellen mit fehlender Begründung identifizieren, Sprachprobleme sammeln
- Wave 2 — Überarbeitung: Begründungen ergänzen, Jargon ersetzen, unnötige Rückverweise streichen
- Wave 3 — Finalcheck

Plans: 3 plans

**Wave 1**
- [x] 20-01-PLAN.md — Kap. 4 Audit: fünf Kritikpunkte lokalisieren (Rückverweis, 6%-Filter-Begründung, gone_since, Sprache, Kürzel D-02/D-05) → 20-AUDIT.md

**Wave 2** *(blocked on Wave 1)*
- [x] 20-02-PLAN.md — Überarbeitung Kap. 4: Rückverweis streichen, Begründungen ergänzen, Sprache vereinfachen, Kürzel entfernen

**Wave 3** *(blocked on Wave 2)*
- [x] 20-03-PLAN.md — Finalcheck Kap. 4: Wave-3-Checkliste, Zahlenwerte unverändert → 20-FINALCHECK.md

---

### Phase 21: Kap. 5 — Wiederholungen & Technik-Overhead

**Goal:** kap5-identifikation.md enthält keine Informationswiederholungen aus Kap. 2–4, keine technisch-irrelevanten Detailangaben, alle Fakten sind korrekt (Modellname, α-Wert).
**Depends on:** Phase 20
**File:** projektarbeit/kapitel/kap5-identifikation.md

**Kritikpunkte (aus final_kritik.md):**
1. Eröffnungspassage: „wurde mit ArcFace-Loss auf dem WebFace600K-Datensatz trainiert [...] buffalo_l-Paket bündelt w600k_r50 mit dem SCRFD-Detektor und ONNX-Exportfunktionen" — zu technisch/random, kürzen
2. Tabelle mit `POSITION_MATCH_RADIUS` und `SIMILARITY_THRESHOLD`: Werte werden in umliegenden Abschnitten bereits erklärt — Wiederholung entfernen oder zusammenführen
3. Allgemein: Kapitel wirkt repetitiv — Infos aus Kap. 2–4 nochmals aufgezählt; bereinigen ohne neue Lücken zu reißen

**Wave-Struktur:**
- Wave 1 — Wiederholungen identifizieren (Vergleich Kap. 2–4 vs. Kap. 5), tech-overhead markieren
- Wave 2 — Überarbeitung: Redundanzen entfernen, Technik-Overhead kürzen
- Wave 3 — Finalcheck

**Plans:** 3/3 plans complete

Plans:
**Wave 1**
- [x] 21-01-PLAN.md — Wiederholungs-Audit: alle Fundstellen in 21-AUDIT.md kartieren

**Wave 2** *(blocked on Wave 1)*
- [x] 21-02-PLAN.md — Überarbeitung: SCRFD-Satz + SIMD-Einschub + SIMILARITY_THRESHOLD-Zeile entfernen

**Wave 3** *(blocked on Wave 2)*
- [x] 21-03-PLAN.md — Finalcheck: Wave-3-Checkliste, 21-FINALCHECK.md erstellen

---

### Phase 22: Kap. 6 — Praxisbeispiel, RAG-Fakten, Gruppen-Isolation

**Goal:** kap6-personalisierung.md enthält ein konkretes SAP-bezogenes Beispiel für den RAG-Nutzen, alle technischen Fakten sind korrekt (Chunk-Mechanismus, pin_latest, RAG_ENABLED-Status), Gruppen-Isolation ist vollständig begründet unter Verweis auf PRESENCE_SYSTEM.md.
**Depends on:** Phase 21
**File:** projektarbeit/kapitel/kap6-personalisierung.md

**Kritikpunkte (aus final_kritik.md):**
1. Chunk-Schema: „Bis zu 5 atomare Sätze; ein Fakt pro Satz" — nicht ganz korrekt, nur sinnvolle Fakten extrahieren → umformulieren
2. RAG-Retrieval-Block: kein konkretes SAP-Beispiel — z.B. „Person hat beim letzten Besuch nach SAP BTP gefragt, Assistent greift beim nächsten Gespräch darauf zurück"
3. `pin_latest`-Mechanismus: gegen Code verifizieren (existiert in `store.py` ✓) — aktuell korrekt?
4. `text-embedding-3-small` und 1536-dim: gegen `backend/services/llm.py` verifizieren ✓
5. `RAG_ENABLED=false` in `.env`-Beispiel — im Text klarstellen ob RAG aktiv oder nur als Feature vorhanden
6. Gruppen-Isolation: mehr begründen — `PRESENCE_SYSTEM.md` enthält gute Erklärung; inhaltlich einarbeiten

**Wave-Struktur:**
- Wave 1 — Fakten verifizieren (pin_latest, Chunk-Schema, embedding-Dimensionen), Lücken markieren
- Wave 2 — Überarbeitung: Beispiel einbauen, Chunk-Satz korrigieren, Gruppen-Isolation ausbauen
- Wave 3 — Finalcheck

Plans:
**Wave 1**
- [x] 22-01-PLAN.md — Kap. 6 Fakten-Audit + Lücken-Sammlung

**Wave 2** *(blocked on Wave 1)*
- [x] 22-02-PLAN.md — Überarbeitung Kap. 6

**Wave 3** *(blocked on Wave 2)*
- [x] 22-03-PLAN.md — Finalcheck Kap. 6

---

### Phase 23: Abschluss-Querschnitt v3 — Sachfehler & Sprache final

**Goal:** Alle Sachfehler aus `final_kritik.md → ## Kap. X FUNDE` (hoch-Priorität) und der Querschnittsfund QF-1 (ResNet50/100) sind in den Kapiteln behoben, Sprache ist durchgehend konsistent auf „Studenten-Niveau".
**Depends on:** Phase 22

**Enthält:**
1. **[QF-1] ResNet100 → ResNet50** in Kap. 3.3, 7.2.1, 8.1
2. **[4-F5] D-02/D-05** interne Kürzel aus Kap. 4.2 und 4.3 entfernen
3. **[6-F2] Dangling-Referenz** „diese Cross-Contamination" in Kap. 6 beheben
4. **[7-F6] „Autoren" → „Autors"** in Kap. 7.1
5. **[2-F5] „für die eigene Implementierung wurde ArcFace gewählt"** aus Kap. 2.2.2 entfernen (Architekturentscheidung gehört nach Kap. 3.3)
6. Sprach-Konsistenz-Check über alle Kapitel: keine neu eingeschlichenen Jargon-Stellen

Plans:
**Plans:** 2/2 plans complete

**Wave 1**
- [x] 23-01-PLAN.md — Sachfehler QF-1 + 4-F5 + 6-F2 + 7-F6 + 2-F5 beheben (alle Kapitel)

**Wave 2** *(blocked on Wave 1)*
- [x] 23-02-PLAN.md — Sprach-Konsistenz-Check über alle Kapitel, letzter Gesamt-Durchgang

---

## Progress — Milestone v3.0 (offen)

**Execution Order:** 18 → 19 → 20 → 21 → 22 → 23

| Phase | Waves | Status | Gestartet |
|-------|-------|--------|-----------|
| 18. Kap. 2 Stilrevision | 0/3 | Pending | — |
| 19. Kap. 3 Fakten & Sprache | 3/3 | Complete    | 2026-07-13 |
| 20. Kap. 4 Begründungen & Sprache | 3/3 | Complete    | 2026-07-13 |
| 21. Kap. 5 Wiederholungen | 3/3 | Complete    | 2026-07-14 |
| 22. Kap. 6 Praxisbeispiel & RAG | 3/3 | Complete    | 2026-07-14 |
| 23. Abschluss-Querschnitt v3 | 2/2 | Complete    | 2026-07-14 |


---

## Milestone v4.0 — Bestnoten-Optimierung (1,0-Ziel)

**Ziel:** Jedes der 12 DHBW-Bewertungskriterien wird durch eine dedizierte Phase auf volle Punktzahl gebracht — Ziel 100/100 Punkte, Note 1,0. Alle Änderungen erfolgen direkt in den Typst-Quelldateien (`T2000_Part1/chapters/*.typ`) und `T2000_Part1/user/sources.bib`.

**Wave-Struktur pro Phase:**
- Wave 1 — Audit/Analyse: Bestandsaufnahme der betroffenen Stellen im Typst-Dokument
- Wave 2 — Umsetzung: Konkrete Änderungen in .typ-Dateien und sources.bib
- Wave 3 — Finalcheck: Verifikation aller Success Criteria

**Bewertungspunkte:** 100P gesamt (10+10+10+10+15+10+5+5+5+10+5+5)

- [ ] **Phase 31: Systematik** — Schwellenwert-Inkonsistenz 0,65→0,52 + State-Machine-Terminologie einführen (10P)
- [ ] **Phase 32: Literaturrecherche** — DSGVO-BibTeX + arXiv→Peer-reviewed + VLM/Gaze-Quellen + hogenhout ersetzen (10P)
- [ ] **Phase 33: Verwendung der Literatur** — CLIP-Sprung reparieren + EMA-α-Beleg spezifizieren + Barquero-Audit (10P)
- [ ] **Phase 34: Methoden und Werkzeuge** — Anforderungsanalyse in Kap. 3 + ROC/Threshold-Diskussion in Kap. 7.1 (10P)
- [ ] **Phase 35: Fachliche Bearbeitung** — Versuchsbeschreibung Kap. 7 + Gaze-Check-Evaluation + Gruppen-Sessions-Beleg (15P)
- [ ] **Phase 36: Nutzung Fachwissen** — ArcFace vs. CosFace geometrisch + all-MiniLM-Begründung + EMA-α-Kontext (10P)
- [ ] **Phase 37: Wirtschaftliche Bewertung** — Konkrete Kostenschätzung + Cloud-API-Vergleich (5P)
- [ ] **Phase 38: Nachhaltigkeitsaspekte** — Abschnitt 3.7 (drei Dimensionen) + Buolamwini-Verweis Kap. 7 (5P)
- [ ] **Phase 39: Umsetzbarkeit** — HNSW-Skalierbarkeit mit Zahlen + DSGVO-Produktivierungspfad Kap. 8.2 (5P)
- [ ] **Phase 40: Dokumentation** — Anhang A Systemparameter + IDLE/CANDIDATE/ACTIVE-Definition verifizieren (10P)
- [ ] **Phase 41: Kreativität** — Originelle Beiträge in Kap. 8.1 + naive Alternative kontrastieren (5P)
- [ ] **Phase 42: Selbstständigkeit** — Iterative Eigenentscheidungslogik an 3 Schlüsselstellen (5P)

---

### Phase 31: Systematik

**Goal**: Das Typst-Dokument ist intern konsistent — der Schwellenwert 0,52 steht in allen drei Darstellungen gleich, und die State-Machine-Begriffe IDLE, CANDIDATE, ACTIVE sind beim ersten Auftreten explizit definiert.
**Depends on**: Phase 23 (Milestone v3.0)
**Requirements**: SYST-01, SYST-02
**Target files**: T2000_Part1/chapters/kap5.typ, T2000_Part1/chapters/kap4.typ, T2000_Part1/chapters/kap3.typ
**Success Criteria** (what must be TRUE):
  1. In kap5.typ zeigt Abb. 5.1 den Schwellenwert 0,52 — Tab. 4.4 und Tab. 5.1 sind identisch mit diesem Wert; eine Suche nach „0,65" im Erkennungsschwellenwert-Kontext liefert keinen Treffer
  2. In kap3.typ oder kap4.typ werden IDLE, CANDIDATE und ACTIVE beim ersten Auftreten mit Kurzdefinition eingeführt, bevor diese Bezeichnungen in Kap. 4+ ohne Erklärung vorkommen
  3. Alle drei betroffenen Tabellen/Abbildungen (Tab. 4.4, Tab. 5.1, Abb. 5.1) zeigen konsistent denselben Schwellenwert
**Plans**: 3 plans

Plans:
**Wave 1**
- [ ] 31-01-PLAN.md — Audit: alle Vorkommen von 0,65/0,52 in chapters/*.typ kartieren; alle Vorkommen von IDLE/CANDIDATE/ACTIVE vor ihrer Definition lokalisieren

**Wave 2** *(blocked on Wave 1)*
- [ ] 31-02-PLAN.md — Umsetzung: Schwellenwert 0,65 → 0,52 in Abb. 5.1 ersetzen; State-Machine-Definitionen an erster Stelle einfügen

**Wave 3** *(blocked on Wave 2)*
- [ ] 31-03-PLAN.md — Finalcheck: Kriterien 1–3 verifizieren, kein 0,65-Rest, Terminologie konsistent

---

### Phase 32: Literaturrecherche

**Goal**: sources.bib enthält für alle im Text zitierten Quellen formell korrekte, überwiegend peer-reviewed Einträge — DSGVO als eigener Eintrag, ≥5 arXiv-only Quellen auf Konferenzpaper aktualisiert, ≥2 VLM/Gaze-Peer-reviewed-Quellen ergänzt, hogenhout2025 durch etablierte Quelle ersetzt/ergänzt.
**Depends on**: Phase 31
**Requirements**: LITR-01, LITR-02, LITR-03, LITR-04
**Target files**: T2000_Part1/user/sources.bib, T2000_Part1/chapters/kap2.typ, T2000_Part1/chapters/kap4.typ
**Success Criteria** (what must be TRUE):
  1. sources.bib enthält einen formal korrekten BibTeX-Eintrag für die DSGVO (Verordnung (EU) 2016/679); alle Inline-Zitate `[DSGVO 2016, Art. X]` im Dokument referenzieren diesen Schlüssel
  2. Mindestens 5 vormals arXiv-only BibTeX-Einträge zeigen jetzt booktitle oder journal einer peer-reviewed Konferenz oder Zeitschrift (CVPR, NeurIPS, ECCV, TPAMI o.ä.)
  3. Mindestens 2 neue peer-reviewed Quellen zu VLM-basierter Gaze-Schätzung oder Bildklassifikation sind in sources.bib eingetragen und in Kap. 2.1.2 oder 4.2 inline zitiert
  4. hogenhout2025biometricprivacy ist entweder durch eine etablierte Datenschutz-/Biometrie-Quelle ersetzt oder durch mindestens eine solche Quelle ergänzt
**Plans**: TBD

Plans:
**Wave 1**
- [ ] 32-01-PLAN.md — Audit: alle arXiv-only Einträge in sources.bib identifizieren; VLM/Gaze-Lücken in Kap. 2.1.2 + 4.2 kartieren; hogenhout-Status prüfen

**Wave 2** *(blocked on Wave 1)*
- [ ] 32-02-PLAN.md — Umsetzung: DSGVO-Eintrag anlegen; ≥5 arXiv-Einträge auf publizierte Versionen aktualisieren; ≥2 VLM/Gaze-Quellen recherchieren, eintragen und einzitieren; hogenhout ersetzen/ergänzen

**Wave 3** *(blocked on Wave 2)*
- [ ] 32-03-PLAN.md — Finalcheck: Kriterien 1–4 verifizieren; BibTeX-Syntax prüfen; Inline-Zitate auf DSGVO-Schlüssel geprüft

---

### Phase 33: Verwendung der Literatur

**Goal**: Jede Quellenreferenz im Typst-Dokument trägt direkt zur Argumentation bei — kein Argumentationssprung beim CLIP-Absatz, α=0,2 mit domänenspezifischem Beleg, Barquero-Zitate auf tatsächlich relevante Stellen reduziert.
**Depends on**: Phase 32
**Requirements**: LITV-01, LITV-02, LITV-03
**Target files**: T2000_Part1/chapters/kap2.typ, T2000_Part1/chapters/kap5.typ, T2000_Part1/chapters/kap4.typ
**Success Criteria** (what must be TRUE):
  1. In kap2.typ (Abschnitt 2.1.2) ist entweder kein CLIP-Absatz mehr vorhanden, oder der Text erklärt explizit den Zusammenhang CLIP → Instruction-Following → Gemini 2.5 Flash ohne Argumentationslücke
  2. In kap5.typ (Abschnitt 5.3) ist der α=0,2-Wert mit einer Quelle aus dem Bereich biometrischer Embedding-Updates oder Tracking belegt — nicht ausschließlich Gardner 2006 (allgemeine Zeitreihen)
  3. barquero2020longtermtracking wird im Dokument nur noch an Stellen zitiert, an denen der Originalgehalt der Studie (Long-Term Re-Identification) die Argumentation direkt stützt
**Plans**: TBD

Plans:
**Wave 1**
- [ ] 33-01-PLAN.md — Audit: CLIP-Absatz in Kap. 2.1.2 lesen und Argumentationsbruch dokumentieren; alle 5 barquero-Zitate auf Relevanz prüfen; Gardner-Beleg in Kap. 5.3 verorten

**Wave 2** *(blocked on Wave 1)*
- [ ] 33-02-PLAN.md — Umsetzung: CLIP-Absatz überarbeiten oder streichen; α=0,2-Beleg durch domänenspezifische Quelle ersetzen/ergänzen; irrelevante barquero-Zitate entfernen

**Wave 3** *(blocked on Wave 2)*
- [ ] 33-03-PLAN.md — Finalcheck: Kriterien 1–3 verifizieren; kein Argumentationssprung mehr; barquero-Zitierzahl gegen Audit-Ergebnis geprüft

---

### Phase 34: Methoden und Werkzeuge

**Goal**: Das methodische Vorgehen ist explizit dokumentiert — messbare Anforderungen stehen vor den Designentscheidungen in Kap. 3, die Evaluation in Kap. 7 diskutiert den FAR/FRR-Tradeoff und begründet den Betriebspunkt.
**Depends on**: Phase 33
**Requirements**: METH-01, METH-02
**Target files**: T2000_Part1/chapters/kap3.typ, T2000_Part1/chapters/kap7.typ
**Success Criteria** (what must be TRUE):
  1. In kap3.typ enthält Kap. 3 vor den Entscheidungsabschnitten 3.2–3.5 eine explizite Anforderungsanalyse mit mindestens drei messbaren Anforderungen (Latenz ≤ X ms, Erkennungsrate ≥ Y %, CPU-only), die als nachvollziehbarer Entscheidungsrahmen dienen
  2. In kap7.typ beschreibt Kap. 7.1 den FAR/FRR-Tradeoff bei unterschiedlichen Schwellenwerten und begründet den gewählten Betriebspunkt 0,52 innerhalb dieses ROC-Rahmens
**Plans**: TBD

Plans:
**Wave 1**
- [ ] 34-01-PLAN.md — Audit: Kap. 3 auf Anforderungsanalyse prüfen (fehlt/implizit?); Kap. 7.1 auf ROC/Threshold-Diskussion prüfen

**Wave 2** *(blocked on Wave 1)*
- [ ] 34-02-PLAN.md — Umsetzung: Anforderungsanalyse in Kap. 3 einfügen; ROC/Threshold-Passage in Kap. 7.1 ergänzen

**Wave 3** *(blocked on Wave 2)*
- [ ] 34-03-PLAN.md — Finalcheck: Kriterien 1–2 verifizieren; Anforderungsnummern stimmen; 0,52-Begründung steht im ROC-Kontext

---

### Phase 35: Fachliche Bearbeitung

**Goal**: Kap. 7 ist wissenschaftlich substanziell — Versuchsrahmen ist beschrieben, der Gaze-Check ist qualitativ bewertet, die Gruppen-Sessions-Dimension ist belegt.
**Depends on**: Phase 34
**Requirements**: FACH-01, FACH-02, FACH-03
**Target files**: T2000_Part1/chapters/kap7.typ
**Success Criteria** (what must be TRUE):
  1. In kap7.typ (Kap. 7.1) stehen Personenanzahl N, Sitzungsanzahl, Beleuchtungsbedingungen und Messprotokolldauer als explizite Versuchsbeschreibung — auch wenn N klein ist, ist der Rahmen vollständig
  2. In kap7.typ existiert für den Gaze-Check (Vision-LLM) eine qualitative Evaluation mit beobachteten False-Positive- und False-Negative-Raten aus dem Entwicklungsbetrieb
  3. In kap7.typ (Robustheit oder Kap. 7.3) ist die Gruppen-Sessions-Dimension mit mindestens einer beobachteten Messgröße belegt (z. B. Anteil Sessions mit mehr als einer Person)
**Plans**: TBD
**UI hint**: no

Plans:
**Wave 1**
- [ ] 35-01-PLAN.md — Audit: Versuchsbeschreibungs-Lücken in Kap. 7.1 kartieren; Gaze-Check-Eval-Lücke (Tab. 3.1 „Nicht evaluiert") lokalisieren; Gruppen-Sessions-Beleg-Lücke in Kap. 7.3 lokalisieren

**Wave 2** *(blocked on Wave 1)*
- [ ] 35-02-PLAN.md — Umsetzung: Versuchsbeschreibung ergänzen; qualitative Gaze-Check-Evaluation aus Entwicklungsbetrieb-Beobachtungen formulieren; Gruppen-Sessions-Größe eintragen

**Wave 3** *(blocked on Wave 2)*
- [ ] 35-03-PLAN.md — Finalcheck: Kriterien 1–3 verifizieren; alle drei Ergänzungen im Typst nachgewiesen

---

### Phase 36: Nutzung Fachwissen

**Goal**: Das Fachwissen ist tief verankert — ArcFace/CosFace-Unterschied geometrisch erklärt, RAG-Modellwahl quellengestützt begründet, EMA-α mit Literaturkontext für biometrische Embedding-Updates versehen.
**Depends on**: Phase 35
**Requirements**: WISS-01, WISS-02, WISS-03
**Target files**: T2000_Part1/chapters/kap2.typ, T2000_Part1/chapters/kap6.typ, T2000_Part1/chapters/kap5.typ
**Success Criteria** (what must be TRUE):
  1. In kap2.typ (Kap. 2.2.2) erklärt ein Absatz den geometrischen Unterschied zwischen Winkelmarge (ArcFace) und Kosinusmarge (CosFace) mit der Begründung, warum additive Winkelmarge stärker diskriminiert
  2. In kap6.typ (Kap. 6.2) ist die Wahl des RAG-Embedding-Modells mit einem nachvollziehbaren, quellengestützten Kriterium (MTEB-Benchmark-Rang, Sentence-BERT-Vergleich o.ä.) begründet
  3. In kap5.typ (Kap. 5.3) hat der α=0,2-Wert einen Literaturkontext: ein Verweis auf adaptive Embedding-Update-Methoden erklärt, warum graduelles Blending für biometrische Langzeit-Embeddings sinnvoll ist
**Plans**: TBD

Plans:
**Wave 1**
- [ ] 36-01-PLAN.md — Audit: Kap. 2.2.2 auf ArcFace/CosFace-Erklärungstiefe prüfen; Kap. 6.2 auf RAG-Modell-Begründung prüfen; Kap. 5.3 auf EMA-α-Literaturkontext prüfen

**Wave 2** *(blocked on Wave 1)*
- [ ] 36-02-PLAN.md — Umsetzung: ArcFace/CosFace-Absatz erweitern; RAG-Modell-Begründung mit Quelle ergänzen; EMA-α-Literaturkontext einfügen

**Wave 3** *(blocked on Wave 2)*
- [ ] 36-03-PLAN.md — Finalcheck: Kriterien 1–3 verifizieren; geometrische Erklärung verständlich; Quellenbelege vorhanden

---

### Phase 37: Wirtschaftliche Bewertung

**Goal**: Kap. 3.6 enthält konkrete Kostenzahlen und einen direkten Vergleich mit einer Cloud-API-Alternative, sodass die Open-Source/ONNX-Kosteneinsparung beziffert ist.
**Depends on**: Phase 36
**Requirements**: WIRT-01, WIRT-02
**Target files**: T2000_Part1/chapters/kap3.typ
**Success Criteria** (what must be TRUE):
  1. In kap3.typ (Kap. 3.6) steht eine Kostenschätzung mit konkreten Zahlen: geschätzte Gemini-API-Calls pro 8-Stunden-Kiosk-Tag (Gaze-Checks + Begrüßungen + Chats) und daraus resultierende Monatskosten
  2. In kap3.typ (Kap. 3.6) steht ein Kostenvergleich mit konkreten Listenpreisen einer Cloud-Alternative (AWS Rekognition oder Azure Face API), der die Einsparung durch den Open-Source/ONNX-Ansatz beziffert
**Plans**: TBD

Plans:
**Wave 1**
- [ ] 37-01-PLAN.md — Audit: aktuellen Stand von Kap. 3.6 lesen; fehlende Kostenzahlen und fehlenden Cloud-Vergleich dokumentieren

**Wave 2** *(blocked on Wave 1)*
- [ ] 37-02-PLAN.md — Umsetzung: Kostenschätzung mit Rechenweg einfügen; Cloud-API-Preisvergleich ergänzen

**Wave 3** *(blocked on Wave 2)*
- [ ] 37-03-PLAN.md — Finalcheck: Kriterien 1–2 verifizieren; Zahlen plausibel und konsistent

---

### Phase 38: Nachhaltigkeitsaspekte

**Goal**: Das Dokument behandelt Nachhaltigkeit eigenständig und vollständig — Abschnitt 3.7 mit drei Dimensionen, expliziter Bias-Verweis auf Buolamwini 2018 in Kap. 7.
**Depends on**: Phase 37
**Requirements**: NACH-01, NACH-02
**Target files**: T2000_Part1/chapters/kap3.typ, T2000_Part1/chapters/kap7.typ, T2000_Part1/user/sources.bib
**Success Criteria** (what must be TRUE):
  1. In kap3.typ existiert Abschnitt 3.7 „Nachhaltigkeitsaspekte" mit drei erkennbaren Dimensionen: ökologisch (CPU-Inferenz, Energieverbrauch im Dauerbetrieb), ökonomisch (TCO Open-Source vs. proprietär), sozial (demographische Fehlerraten, gesellschaftliche Implikationen von Gesichtserkennung im öffentlichen Raum)
  2. In kap7.typ verweist die Diskussion der Erkennungsgenauigkeit explizit auf Buolamwini 2018 und bewertet die Implikation demographischer Bias für den SAP-Kiosk-Kontext
  3. Buolamwini 2018 ist als formal korrekter BibTeX-Eintrag in sources.bib vorhanden
**Plans**: TBD

Plans:
**Wave 1**
- [ ] 38-01-PLAN.md — Audit: prüfen ob 3.7 existiert und was fehlt; Buolamwini-Eintrag in sources.bib und Kap. 7 prüfen

**Wave 2** *(blocked on Wave 1)*
- [ ] 38-02-PLAN.md — Umsetzung: Abschnitt 3.7 in kap3.typ anlegen (ca. ½ Seite, drei Dimensionen); Buolamwini-Verweis in Kap. 7 einfügen; BibTeX-Eintrag ergänzen

**Wave 3** *(blocked on Wave 2)*
- [ ] 38-03-PLAN.md — Finalcheck: Kriterien 1–3 verifizieren; Abschnitt 3.7 vollständig; Bias-Bewertung vorhanden

---

### Phase 39: Umsetzbarkeit

**Goal**: Die Arbeit belegt Umsetzbarkeit konkret — HNSW-Skalierbarkeit ist mit Zahlen untermauert, der DSGVO-Produktivierungspfad in Kap. 8.2 ist als umsetzbare Roadmap formuliert.
**Depends on**: Phase 38
**Requirements**: UMSE-01, UMSE-02
**Target files**: T2000_Part1/chapters/kap3.typ, T2000_Part1/chapters/kap7.typ, T2000_Part1/chapters/kap8.typ
**Success Criteria** (what must be TRUE):
  1. In kap3.typ (Kap. 3.4) oder kap7.typ enthält eine Skalierbarkeitsaussage die HNSW O(log N)-Komplexität angewendet auf das konkrete Szenario mit konkreten Profilzahlen (z. B. 10.000 / 100.000 Profile) und abgeschätzter Latenzauswirkung
  2. In kap8.typ (Kap. 8.2) sind Opt-in, DSFA (Art. 35) und Löschfunktion (Art. 17) als drei konkrete, umsetzbare Produktivierungsschritte formuliert
**Plans**: TBD

Plans:
**Wave 1**
- [ ] 39-01-PLAN.md — Audit: HNSW-Skalierbarkeitsaussage in Kap. 3.4 / Kap. 7 suchen und Lücke dokumentieren; Kap. 8.2 auf DSGVO-Roadmap prüfen

**Wave 2** *(blocked on Wave 1)*
- [ ] 39-02-PLAN.md — Umsetzung: HNSW-Skalierbarkeitsabsatz ergänzen; DSGVO-Produktivierungsschritte in Kap. 8.2 formulieren

**Wave 3** *(blocked on Wave 2)*
- [ ] 39-03-PLAN.md — Finalcheck: Kriterien 1–2 verifizieren; Zahlen konkret; drei DSGVO-Schritte benannt

---

### Phase 40: Dokumentation

**Goal**: Das Dokument ist vollständig dokumentiert — ein Parameteranhang mit allen konfigurierbaren Systemwerten existiert, IDLE/CANDIDATE/ACTIVE sind beim ersten Auftreten im Fließtext definiert.
**Depends on**: Phase 39
**Requirements**: DOKU-01, DOKU-02
**Target files**: T2000_Part1/chapters/ (neues appendix.typ o.ä.), T2000_Part1/chapters/kap3.typ oder kap4.typ
**Success Criteria** (what must be TRUE):
  1. In T2000_Part1/chapters/ existiert ein Anhang A „Systemparameter" mit einer Tabelle aller konfigurierbaren Parameter: CANDIDATE_SECS, LEAVE_SECS, SIMILARITY_THRESHOLD, FRAME_INTERVAL, GROUP_ARRIVAL_WINDOW_SECS, EMA-α — jeweils mit Wert, Einheit und Kapitelreferenz
  2. In kap3.typ oder kap4.typ sind IDLE, CANDIDATE und ACTIVE als definierte Bezeichnungen mit Kurzerklärung eingeführt, bevor diese Begriffe in Kap. 4+ ohne Erklärung verwendet werden
**Plans**: TBD

Plans:
**Wave 1**
- [ ] 40-01-PLAN.md — Audit: prüfen ob Anhang A existiert und welche Parameter fehlen; IDLE/CANDIDATE/ACTIVE-Erstdefinition im Dokument lokalisieren

**Wave 2** *(blocked on Wave 1)*
- [ ] 40-02-PLAN.md — Umsetzung: Anhang A anlegen mit vollständiger Parametertabelle; Terminologie-Einführung an erster Stelle sicherstellen

**Wave 3** *(blocked on Wave 2)*
- [ ] 40-03-PLAN.md — Finalcheck: Kriterien 1–2 verifizieren; alle 6 Parameter in Tabelle; Definitionen vor erstem Gebrauch vorhanden

---

### Phase 41: Kreativität

**Goal**: Die originellen Beiträge der Arbeit sind explizit benannt und der Kreativitätsmehrwert ist durch Kontrast mit naiven Alternativen sichtbar gemacht.
**Depends on**: Phase 40
**Requirements**: KREA-01, KREA-02
**Target files**: T2000_Part1/chapters/kap8.typ, T2000_Part1/chapters/kap3.typ oder kap4.typ
**Success Criteria** (what must be TRUE):
  1. In kap8.typ (Kap. 8.1) hebt ein eigener Absatz explizit drei originelle Beiträge hervor: (1) Vision-LLM als kalibrierungsfreie Interaktionsvalidierung, (2) spekulatives Pre-Computing der Begrüßung als Latenz-Engineering-Muster, (3) dreikanaliges Gedächtnisdesign (summary / facts_sentences / facts) als differenziertes Personalisierungskonzept
  2. In kap3.typ oder kap4.typ beschreibt ein Absatz für die Gaze-Check-Entscheidung das verdrängte naive Alternativvorgehen (klassische Gaze-Estimation mit Kalibrierung) und macht den Kreativitätsmehrwert des gewählten Ansatzes explizit
**Plans**: TBD

Plans:
**Wave 1**
- [ ] 41-01-PLAN.md — Audit: Kap. 8.1 auf explizite Originalitätsbenennung prüfen; Gaze-Check-Abschnitt auf Kontrastierung mit naiver Alternative prüfen

**Wave 2** *(blocked on Wave 1)*
- [ ] 41-02-PLAN.md — Umsetzung: Originalitäts-Absatz in Kap. 8.1 einfügen; Kontrastierungs-Passage für Gaze-Check ergänzen

**Wave 3** *(blocked on Wave 2)*
- [ ] 41-03-PLAN.md — Finalcheck: Kriterien 1–2 verifizieren; drei Beiträge explizit benannt; naive Alternative kontrastiert

---

### Phase 42: Selbstständigkeit

**Goal**: An drei Schlüsselstellen der Arbeit ist die iterative Eigenentscheidungslogik sichtbar — naive Ausgangslösung, Verwerfungsgrund, eigene Erkenntnis als Formulierungsmuster.
**Depends on**: Phase 41
**Requirements**: SELB-01
**Target files**: T2000_Part1/chapters/kap3.typ, T2000_Part1/chapters/kap5.typ
**Success Criteria** (what must be TRUE):
  1. In kap3.typ (Kap. 3.3) ist der Modellwahlprozess als iterativer Eigenentscheid formuliert: naive Ausgangslösung (DeepFace), beobachtetes Problem (Genauigkeit/Latenz), eigene Erkenntnis die zu InsightFace buffalo_l führte
  2. In kap5.typ (Kap. 5.1) ist die Schwellenwert-Kalibrierung (0,65 → 0,52) als iterativer Eigenentscheid dargestellt: Ausgangswert, beobachtete Fehlerrate, eigene Kalibrierungsentscheidung
  3. In kap5.typ (Kap. 5.3) ist α=0,2 als bewusst getroffene Eigenentscheidung formuliert: warum nicht gleichgewichtig (α=0,5), welche eigene Beobachtung führte zur Wahl α=0,2
**Plans**: TBD

Plans:
**Wave 1**
- [ ] 42-01-PLAN.md — Audit: drei Schlüsselstellen (Kap. 3.3, Kap. 5.1, Kap. 5.3) auf Eigenentscheidungs-Formulierung prüfen; fehlende oder implizite Stellen dokumentieren

**Wave 2** *(blocked on Wave 1)*
- [ ] 42-02-PLAN.md — Umsetzung: an allen drei Stellen Eigenentscheidungslogik explizit formulieren (naive Lösung → Problem → Erkenntnis → Entscheidung)

**Wave 3** *(blocked on Wave 2)*
- [ ] 42-03-PLAN.md — Finalcheck: Kriterien 1–3 verifizieren; alle drei Stellen formuliert; Formulierungsmuster konsistent

---

## Progress — Milestone v4.0 (gestartet)

**Execution Order:** 31 → 32 → 33 → 34 → 35 → 36 → 37 → 38 → 39 → 40 → 41 → 42

| Phase | Waves | Status | Gestartet |
|-------|-------|--------|-----------|
| 31. Systematik (10P) | 0/3 | Pending | — |
| 32. Literaturrecherche (10P) | 0/3 | Pending | — |
| 33. Verwendung der Literatur (10P) | 0/3 | Pending | — |
| 34. Methoden und Werkzeuge (10P) | 0/3 | Pending | — |
| 35. Fachliche Bearbeitung (15P) | 0/3 | Pending | — |
| 36. Nutzung Fachwissen (10P) | 0/3 | Pending | — |
| 37. Wirtschaftliche Bewertung (5P) | 0/3 | Pending | — |
| 38. Nachhaltigkeitsaspekte (5P) | 0/3 | Pending | — |
| 39. Umsetzbarkeit (5P) | 0/3 | Pending | — |
| 40. Dokumentation (10P) | 0/3 | Pending | — |
| 41. Kreativität (5P) | 0/3 | Pending | — |
| 42. Selbstständigkeit (5P) | 0/3 | Pending | — |
