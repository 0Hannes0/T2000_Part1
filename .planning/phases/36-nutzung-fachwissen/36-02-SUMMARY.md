---
phase: 36-nutzung-fachwissen
plan: "02"
subsystem: content
tags: [typst, bibtex, arcface, cosface, mteb, ema, biometrics, rag]

# Dependency graph
requires:
  - phase: 36-nutzung-fachwissen
    provides: "Wave 1 audit — exact anchor strings and line numbers for three WISS gaps"

provides:
  - "Extended Kap. 2.2.2 with 4-sentence geometric ArcFace/CosFace explanation including geodetic distance argument"
  - "Extended Kap. 6.2 with MTEB benchmark sentence citing muennighoff2023mteb (score 56,53)"
  - "New muennighoff2023mteb BibTeX entry in sources.bib (EACL 2023, doi 10.18653/v1/2023.eacl-main.148)"
  - "New biometric dilemma paragraph in Kap. 5.3 before EMA sentence, citing dewan2016adaptiveappearance"

affects: [wave-3-compile-check, kap-2-revision, kap-5-revision, kap-6-revision]

# Tech tracking
tech-stack:
  added: []
  patterns:
    - "Anchor-sentence insertion: new paragraphs appended after existing anchor sentence, never modifying surrounding text"
    - "Typst inline math: dollar signs without spaces, e.g. $cos(theta + m)$"

key-files:
  created: []
  modified:
    - "T2000_Part1/chapters/fundamentals-1.typ"
    - "T2000_Part1/chapters/practical-2.typ"
    - "T2000_Part1/chapters/practical-1.typ"
    - "T2000_Part1/user/sources.bib"

key-decisions:
  - "4 sentences inserted for WISS-01 (not 3) to fully cover CosFace vs. ArcFace distinction, nonlinearity, and geodetic conclusion"
  - "MTEB sentence kept as single dense sentence per plan instruction (under 2 sentences)"
  - "Biometric dilemma encoded as single compound sentence covering both failure modes plus resolution, satisfying veraltet + Dilemma + Ausreißer acceptance criteria"

requirements-completed: [WISS-01, WISS-02, WISS-03]

# Metrics
duration: 2min
completed: 2026-07-18
---

# Phase 36 Plan 02: Nutzung Fachwissen — Wave 2 Einschübe Summary

**Drei fachliche Tiefenlücken geschlossen: geometrische ArcFace/CosFace-Erklärung (cos-Marge vs. Winkelmarge + geodätische Distanz), MTEB-Benchmark-Begründung (Score 56,53 über 56 Tasks) und biometrisches Dilemma-Paragraph (Template-Veralterung vs. Ausreißer-Risiko) — 4 Dateien, 3 Commits**

## Performance

- **Duration:** ~2 min
- **Started:** 2026-07-18T12:46:38Z
- **Completed:** 2026-07-18T12:48:23Z
- **Tasks:** 3
- **Files modified:** 4

## Accomplishments

- WISS-01: 4 Sätze nach CosFace-Ankersatz in fundamentals-1.typ (Kap. 2.2.2) erklären erstmals den geometrischen Unterschied: CosFace addiert Marge auf Kosinus ($cos(theta) - m$), ArcFace auf den Winkel ($cos(theta + m)$); Nichtlinearität und geodätische Distanz auf Einheitshypersphäre begründen die gleichmäßigere Klassentrennung
- WISS-02: MTEB-Benchmark-Satz in practical-2.typ (Kap. 6.2) belegt die Modellwahl all-MiniLM-L12-v2 mit konkreten Scores (56,53 / 79,80 / 58,44); neuer BibTeX-Eintrag muennighoff2023mteb korrekt nach reimers2019sbert in sources.bib
- WISS-03: Biometrisches Dilemma-Paragraph in practical-1.typ (Kap. 5.3) vor EMA-Ankersatz erklärt Template-Veralterung bei Erscheinungsveränderung und Ausreißer-Risiko bei direktem Überschreiben; adaptive Erscheinungsmodelle als Lösung zitiert

## Task Commits

Each task was committed atomically (inside T2000_Part1 submodule):

1. **Task 1: WISS-01 — Geometrische ArcFace/CosFace-Erklärung** - `101a65e` (feat)
2. **Task 2: WISS-02 — MTEB-Satz + muennighoff2023mteb BibTeX** - `b3ef97d` (feat)
3. **Task 3: WISS-03 — Biometrisches Dilemma-Paragraph** - `ab66607` (feat)

## Files Created/Modified

- `T2000_Part1/chapters/fundamentals-1.typ` — 4 Sätze nach Zeile 45 eingefügt (WISS-01: geometrische Marge-Erklärung mit "geodätisch")
- `T2000_Part1/chapters/practical-2.typ` — 1 Satz nach Zeile 71 eingefügt (WISS-02: MTEB-Score 56,53 mit @muennighoff2023mteb)
- `T2000_Part1/user/sources.bib` — Neuer @inproceedings{muennighoff2023mteb}-Eintrag nach reimers2019sbert (WISS-02)
- `T2000_Part1/chapters/practical-1.typ` — 1 Absatz zwischen Zeile 121 und 122 eingefügt (WISS-03: biometrisches Dilemma mit @dewan2016adaptiveappearance)

## Decisions Made

- 4 Sätze statt 3 für WISS-01: Maximale Satzanzahl laut Plan war 4; alle vier nötig, um CosFace-vs-ArcFace-Unterschied, Nichtlinearitäts-Argument und geodätische Distanz vollständig zu begründen
- MTEB-Satz als eine dichte Sentence mit Klammerzusatz (79,80 / 58,44) statt zwei separater Sätze, um unter dem 2-Satz-Limit zu bleiben
- Biometrisches Dilemma als Compound-Sentence (beide Risiken + Lösung in 3 Hauptteilen) kodiert, damit "veraltet", "Dilemma" und "Ausreißer" alle in derselben Zeile erscheinen und die Acceptance-Criteria erfüllt sind

## Deviations from Plan

None — plan executed exactly as written.

## Issues Encountered

- T2000_Part1 ist ein Git-Submodul; Commits wurden direkt im Submodul-Repository durchgeführt (nicht im Root-Repo), da `git add T2000_Part1/...` im Root mit "Pathspec is in submodule" fehlschlägt. Dies ist normales Submodul-Verhalten und kein Fehler.

## Known Stubs

None — alle Einschübe enthalten echte Fachinhalte mit Literaturbelegen; keine Platzhalter.

## Threat Flags

Keine neuen Trust-Boundary-Oberflächen eingeführt. Inline-Math in fundamentals-1.typ folgt dem bestehenden $cos(theta)$-Muster derselben Datei (T-36-02 mitigiert). BibTeX-DOI-Feld exakt geprüft (T-36-03 mitigiert).

## Next Phase Readiness

- WISS-01, WISS-02, WISS-03 alle erfüllt — Phase 36 Wave 2 abgeschlossen
- Wave 3 (36-03): Typst-Compile-Check und Abschlusskontrolle kann beginnen
- Alle vier geänderten Dateien korrekt in Submodul-History committet

---
*Phase: 36-nutzung-fachwissen*
*Completed: 2026-07-18*
