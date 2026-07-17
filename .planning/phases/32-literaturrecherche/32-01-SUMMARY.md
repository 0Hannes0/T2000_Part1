---
phase: 32
plan: "01"
subsystem: bibliography-audit
tags: [audit, bibtex, misc, inline-citations, dsgvo, hogenhout, vlm, gaze]
dependency_graph:
  requires: []
  provides: [32-AUDIT.md]
  affects: [32-02-PLAN.md, 32-03-PLAN.md]
tech_stack:
  added: []
  patterns: [read-only audit via grep]
key_files:
  created:
    - .planning/phases/32-literaturrecherche/32-AUDIT.md
  modified: []
decisions:
  - "barquero2020longtermtracking: bereits @inproceedings, aber arXiv-DOI + year=2021 statt 2020 — Wave 2 prüft Korrektur"
  - "hogenhout: 3 Vorkommen (nicht 2) — practical-2.typ:94 zusätzlich zu RESEARCH.md-Dokumentation"
metrics:
  duration: "< 5 min"
  completed: "2026-07-17"
  tasks_completed: 2
  tasks_total: 2
  files_created: 1
  files_modified: 0
---

# Phase 32 Plan 01: @misc-Audit und Inline-Zitat-Kartierung Summary

**One-liner:** Vollständige Bestandsaufnahme aller 12 @misc-Einträge und 8 relevanter Inline-Zitat-Stellen mit zwei konkreten Abweichungen von RESEARCH.md.

---

## Was wurde gefunden

### @misc-Audit (Task 1)

- Genau **12 `@misc`-Einträge** in sources.bib — Zählung bestätigt.
- **7 Kategorie-A-Einträge** (upgrade-pflichtig): `cheng2021gazesurvey`, `zhang2015mpiigaze`, `radford2021clip`, `guu2020realm`, `kellnhofer2019gaze360`, `bewley2016sort`, `wojke2017deepsort`, `zhu2021webface260m`
- **4 Kategorie-B-Einträge** (bleiben @misc): `bazarevsky2019blazeface`, `lugaresi2019mediapipe`, `guo2021scrfd`, `hogenhout2025biometricprivacy`
- **barquero2020longtermtracking:** Steht als `@inproceedings` (Zeile 303), nicht @misc. Der DOI ist jedoch `10.48550/arXiv.2010.08675` (arXiv-DOI statt IJCB-DOI) und `year=2021` statt `year=2020`.

### Inline-Zitat-Audit (Task 2)

- **DSGVO-Klammertexte:** 3 Vorkommen in fundamentals-2.typ, Zeilen 166 (Art.~9 Abs.~1) und 170 (Art.~17 und Art.~35). Alle sind manuelle Klammertexte ohne Typst-`@`-Referenz.
- **hogenhout-Zitate:** **3 Vorkommen** (RESEARCH.md erwartete 2) — fundamentals-2.typ:166, conclusion.typ:25, practical-2.typ:94. Alle mit demselben Seitenbereich `[S.~2--4]`.
- **CLIP (radford2021clip):** Eingezitiert in fundamentals-1.typ Zeile 19 (Abschnitt 2.1.2).
- **Gaze360 (kellnhofer2019gaze360):** Eingezitiert in methodology.typ Zeile 50 (Abschnitt 4.2).

---

## Abweichungen vom Plan

### Auto-erfasste Abweichungen

**1. [Abweichung von RESEARCH.md] hogenhout: 3 statt 2 Vorkommen**
- Gefunden in: Task 2
- RESEARCH.md dokumentierte fundamentals-2.typ:166 und conclusion.typ:25.
- Tatsächlich gibt es ein drittes Vorkommen in `practical-2.typ` Zeile 94.
- Auswirkung: Wave 2 muss beim hogenhout-Ersatz auch `practical-2.typ:94` berücksichtigen.

**2. [Abweichung von RESEARCH.md] barquero: arXiv-DOI + falsches Jahr**
- RESEARCH.md nahm an, barquero sei "bereits korrekt als @inproceedings".
- Tatsächlich hat er `doi={10.48550/arXiv.2010.08675}` (arXiv-DOI) statt `doi={10.1109/IJCB48548.2020.9304892}` und `year=2021` statt `year=2020`.
- Barquero ist kein @misc-Eintrag und daher nicht Scope von LITR-02 — aber ein Qualitätsfehler, den Wave 2 nebenher korrigieren könnte.

---

## Self-Check: PASSED

- `.planning/phases/32-literaturrecherche/32-AUDIT.md` existiert: FOUND
- Commit `6b11081` existiert: FOUND
- `grep -c "@misc{"` gibt 12 zurück: VERIFIED
- `grep -rn "\[DSGVO" chapters/` gibt 2 Zeilen mit 3 Treffern zurück: VERIFIED
- `grep -rn "hogenhout" chapters/` gibt 3 Treffer zurück: VERIFIED (Abweichung dokumentiert)
- `## Inline-Zitat-Audit` section in 32-AUDIT.md: FOUND
