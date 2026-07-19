# T2000 — Studienarbeit: Biometrische Personalisierung eines KI-Assistenten

## What This Is

Studienarbeit (T2000) bei SAP SE. Konzeption und Implementierung eines kamerabasierten
Identifikationssystems, das biometrische Gesichts-Embeddings nutzt, um wiederkehrende Nutzer
eines öffentlichen KI-Assistenten ohne expliziten Login zu erkennen und sitzungsübergreifend
zu personalisieren. Prototyp ist vollständig implementiert (volt-ai-assistant); diese Arbeit
dokumentiert, begründet und evaluiert die getroffenen Designentscheidungen.

## Core Value

Die Arbeit muss die **Entscheidungslogik** hinter jeder technischen Wahl nachvollziehbar
belegen — nicht nur beschreiben was gebaut wurde, sondern warum genau so und nicht anders.

## Forschungsfrage

Wie kann ein öffentlicher KI-Assistent durch kamerabasierte Gesichtserkennung mittels
Deep-Learning-Embeddings wiederkehrende Nutzer identifizieren und eine sitzungsübergreifend
personalisierte Konversationserfahrung bereitstellen?

## Inhaltsverzeichnis (final)

```
1  Einleitung
   1.1  Thematischer Hintergrund und Problemstellung
   1.2  Zielsetzung und Forschungsfrage
   1.3  Aufbau der Arbeit

2  Grundlagen
   2.1  Kamerabasierte Gesichtsdetektion
        2.1.1  Neuronale Netze zur Gesichtsdetektion
        2.1.2  Interaktionsvalidierung durch Blickrichtungsschätzung
   2.2  Biometrische Identifikation mit Gesichts-Embeddings
        2.2.1  Embedding-Räume und Kosinus-Ähnlichkeit
        2.2.2  Metrisches Lernen: Angular Margin Loss
   2.3  Sitzungsübergreifendes Gedächtnis in LLM-Systemen
        2.3.1  Das Kontextfenster-Problem
        2.3.2  Gesprächszusammenfassung als Langzeitgedächtnis
        2.3.3  Retrieval-Augmented Generation

3  Konzeption
   3.1  Gesamtarchitektur und Systemüberblick
   3.2  Auswahl des Detektionsansatzes
   3.3  Auswahl des Erkennungsmodells
   3.4  Auswahl der Persistenzschicht
   3.5  Datenschutz und biometrische Daten
   3.6  Wirtschaftliche Bewertung und Nachhaltigkeitsaspekte

4  Personenerkennung
   4.1  Gesichtsdetektion mit MediaPipe BlazeFace
   4.2  Gaze-Validierung via Vision-LLM
   4.3  State Machine: IDLE → CANDIDATE → ACTIVE
   4.4  Paralleles Multi-Person-Tracking und Gruppen-Erkennung

5  Biometrische Identifikation und Persistenz
   5.1  Embedding-Berechnung mit InsightFace buffalo_l
   5.2  Zweistufiges Tracking und Embedding-Stabilisierung
   5.3  Persistenz mit Qdrant

6  Sitzungsübergreifende Personalisierung
   6.1  Gesprächszusammenfassung und Fakt-Extraktion
   6.2  RAG-Chunk-Retrieval und Kontext-Injektion
   6.3  Gruppen-Sessions und History-Isolation

7  Evaluation
   7.1  Evaluationsaufbau und Methodik
   7.2  Erkennungsgenauigkeit
        7.2.1  Erkennungsrate: TAR, FAR und Schwellenwertanalyse
        7.2.2  Robustheit: Winkel, Beleuchtung und Multi-Person
   7.3  Latenz und Performance
   7.4  Diskussion der Ergebnisse

8  Fazit und Ausblick
   8.1  Fazit
   8.2  Ausblick
```

## Konventionen

- **Format:** Markdown als Arbeitsformat; LaTeX/Overleaf für finale Abgabe
- **Zitierformat:** Inline `[Autor Jahr, S. X]` im Rohtext; Seitenangabe zwingend
- **Quellenqualität:** ≥80% IEEE/ACM/Springer/Arxiv, keine Wikipedia
- **Commits:** Nach jedem abgeschlossenen Stand (Abschnitt, Quelldatei, Sektion)
- **Grundlagen:** Kurz und zweckgerichtet — alles mit Bezug zur eigenen Implementierung
- **Umfang:** ca. 30–40 Seiten

## Arbeitstrennung

| Phase | Quellen | Kein Zugriff auf |
|-------|---------|-----------------|
| Repo-Research | Git-History, Changelogs, Code, Dokumente | Internet |
| Quellensuche | Web (IEEE/ACM/Springer/Arxiv) | Repo |
| Kapitelschreiben | Beides kombiniert | — |

## Repo-Struktur (Quellen)

| Pfad | Inhalt |
|------|--------|
| `T2000/volt-ai-assistant/` | Finales System (v2) — primäre Quelle |
| `T2000/volt-ai-assistant/docs/` | CHANGELOG, ARCHITECTURE, TESTRESULTS, TUNING, FACE_RECOGNITION, PRESENCE_SYSTEM |
| `T2000/volt-ai-assistant/presence/` | Kerncode: state_machine.py, tracker.py, face_id.py, db/store.py, greeting.py |
| `T2000/PRESENCE_SYSTEM.md` | Detaillierte Erklärung des Presence-Systems |
| `T2000/FACE_RECOGNITION_CONCEPT.md` | Konzept v2 (InsightFace, Qdrant) |
| `T2000/FACE_RECOGNITION_DESIGN_v1_prototype.md` | Konzept v1 (DeepFace, HANA) — für Entscheidungsbegründungen |
| `T2000/CHANGELOG.md` | Aggregierter v2-Changelog |
| `T2000/PRESENCE_CHANGELOG_V1.md` | v1-Changelog (ai-infopoint-prototyp) |
| `T2000/volt-ai-assistant/docs/TESTRESULTS_v1.1.md` | LLM-Evaluationsdaten |
| `T2000/volt-ai-assistant/docs/TUNING.md` | Parameter-Referenz (Schwellwerte, VAD, ArcFace) |
| `ai-infopoint-prototyp/` | V1-Prototyp — nur für Entscheidungshistorie |
| `T2000/Bewertung_Projekt_Studien_Bachelor.pdf` | Bewertungskriterien — eigenes Dokument |

## Key Decisions (aus Implementierung)

| Entscheidung | Rationale | Outcome |
|---|---|---|
| MediaPipe statt YOLO für Detektion | YOLO erkennt Seitenansichten → ungewollte Trigger; MediaPipe nur frontal | ✓ Richtig |
| InsightFace buffalo_l statt DeepFace | DeepFace ~92% real, 300ms; InsightFace 99.83%, 80ms via ONNX | ✓ Richtig |
| SQLite → Qdrant Migration | Azure SMB kein POSIX-fcntl → SQLite deadlock auf K8s | ✓ Erzwungen |
| Vision-LLM für Gaze-Check | Klassische Gaze Estimation zu aufwändig; LLM gibt Ja/Nein zuverlässig | ✓ Richtig |
| Zweistufiges Tracking (Position vor ArcFace) | ArcFace-Score bricht bei Kopfdrehung ein; Position robust | ✓ Richtig |
| Kumulatives EMA + graduelles Blending | In-Session: gleichgewichtete Frames; DB: neuere Visits stärker gewichten | ✓ Richtig |
| FaceStore als Interface | SQLite → Qdrant-Tausch ohne Umbau des Trackers | ✓ Richtig |
| Zusammenfassung statt rohe History | Kontextfenster-Problem; strukturierte Faktextraktion per JSON-Schema | ✓ Richtig |

## Requirements

### Validated

- [x] KAP4-01: Annotierte Bibliographie Kap. 4 (sources.md + .bib) — Validated in Phase 04: personenerkennung
- [x] KAP4-02: Kapiteltext kap4-personenerkennung.md (4.1–4.4) — Validated in Phase 04: personenerkennung
- [x] KAP5-01: Annotierte Bibliographie Kap. 5 (sources.md + .bib) — Validated in Phase 05: identifikation
- [x] KAP5-02: Kapiteltext kap5-identifikation.md (5.1–5.3) — Validated in Phase 05: identifikation
- [x] KAP1-01: Kapitel 1 (Einleitung) überarbeitet — alle 5 Kritikpunkte behoben, Quellen eingebaut — Validated in Phase 08: revision-kap-1-einleitung

(Implementierung vollständig — alle Features live)

### Active

- [ ] QA-KAP1: Kap. 1 Quellenaudit — Passgenauigkeit + fehlende Zweitquellen
- [ ] QA-KAP2: Kap. 2 Quellenaudit — Johnson 2019 (HNSW) einfügen, VLM-Zweitquelle
- [ ] QA-KAP3: Kap. 3 Quellenaudit — DSGVO Art. 17/35 direkt zitieren, fehlende Zweitquellen
- [ ] QA-KAP4: Kap. 4 Quellenaudit KRITISCH — 4.1 + 4.2 haben keine Inline-Zitate
- [ ] QA-KAP5: Kap. 5 Quellenaudit — Verifikation, wenig Lücken erwartet
- [ ] QA-KAP6: Kap. 6 Quellenaudit — 6.3 nur 1 Quelle, Zweitquellen ergänzen
- [ ] QA-KAP7: Kap. 7 (NEU) Quellenaudit — 7.1.3 Robustheit ohne Beleg

## Current Milestone: v4.0 Bestnoten-Optimierung (1,0-Ziel)

**Goal:** Jedes der 12 DHBW-Bewertungskriterien wird durch eine dedizierte Phase auf volle Punktzahl gebracht — Ziel 100/100 Punkte, Note 1,0.

**Target features (12 Kriterien → 12 Phasen 31–42):**
- Phase 31 — Systematik (10P): Threshold-Inkonsistenz (0,65 vs. 0,52 in Abb. 5.1) + Terminologie-Einführung IDLE/CANDIDATE/ACTIVE beheben
- Phase 32 — Literaturrecherche (10P): DSGVO-BibTeX-Eintrag + arXiv-Preprints durch Peer-reviewed ersetzen + VLM/Gaze-Literatur ergänzen
- Phase 33 — Verwendung der Literatur (10P): CLIP-Argumentationssprung reparieren + EMA-α-Beleg spezifizieren + Barquero-Zitate präzisieren
- Phase 34 — Methoden/Werkzeuge (10P): Explizite Anforderungsanalyse in Kap. 3 + Schwellenwert-ROC-Diskussion in Kap. 7
- Phase 35 — Fachliche Bearbeitung (15P): Kap. 7 Evaluation wissenschaftlich substanziell stärken (N-Werte, Versuchsaufbau, Gaze-Check-Vergleich)
- Phase 36 — Nutzung Fachwissen (10P): ArcFace vs. CosFace geometrisch erklären + RAG-Modellwahl (all-MiniLM) belegen + EMA-α-Literaturkontext
- [x] Phase 37 — Wirtschaftliche Bewertung (5P): Konkrete Kostenschätzung mit Zahlen (API-Calls/Tag, Azure-Pod, Alternativvergleich) — Validated in Phase 37: WIRT-01/02 erfüllt
- [x] Phase 38 — Nachhaltigkeitsaspekte (5P): Eigenständiger Abschnitt 3.7 mit ökologischen, ökonomischen und sozialen Aspekten — Validated in Phase 38: NACH-01/02 erfüllt
- [x] Phase 39 — Umsetzbarkeit (5P): Skalierbarkeitsaussagen (HNSW-Laufzeit bei N Profilen) + Produktivierungs-Roadmap (DSGVO-Maßnahmen) — Validated in Phase 39: UMSE-01/02 erfüllt
- [x] Phase 40 — Dokumentation (10P): Anhang A2 Systemparameter (6 Parameter) + IDLE/CANDIDATE/ACTIVE-Definition in fundamentals-2.typ — Validated in Phase 40: DOKU-01/02 erfüllt
- Phase 41 — Kreativität (5P): Originelle Beiträge (Vision-LLM-Gaze, spekulatives Pre-Computing, dreikanaliges Gedächtnis) explizit als eigene Leistung benennen
- Phase 42 — Selbstständigkeit (5P): Eigenständige Entscheidungslogik durch Kontrastierung mit naiver Lösung an Schlüsselstellen sichtbar machen

_Quellenaudit (ursprünglich Phasen 24–30) ist vollständig in die Phasen 31–36 integriert._

### Out of Scope

- Deployment-Dokumentation (K8s, SAP AI Core) — kein Untersuchungsgegenstand
- V1-Prototyp als eigenes Kapitel — nur für Entscheidungsbegründungen erwähnen
- Semantischer Feinschliff — kommt in Milestone v2

## Evolution

Dieses Dokument entwickelt sich an Phasenübergängen weiter.

**Nach jeder Phase:**
1. Anforderungen erfüllt? → In Validated verschieben
2. Neue Anforderungen? → In Active ergänzen
3. "What This Is" noch korrekt? → Ggf. anpassen

---
*Last updated: 2026-07-19 — Phase 39 complete: UMSE-01/02 erfüllt (HNSW log(N)-Einschub mit 10.000/100.000-Profilzahlen in Kap. 3.4, DSGVO-Dreischritt Art. 9/35/17 in Kap. 8.2)*
