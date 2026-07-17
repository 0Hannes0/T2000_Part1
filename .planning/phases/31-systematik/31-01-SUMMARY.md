---
phase: 31-systematik
plan: "01"
subsystem: audit
tags: [typst, threshold, state-machine, audit, wave-1]
dependency_graph:
  requires: []
  provides: [31-AUDIT.md]
  affects: [31-02-PLAN.md, 31-03-PLAN.md]
tech_stack:
  added: []
  patterns: [grep-based-audit]
key_files:
  created:
    - .planning/phases/31-systematik/31-AUDIT.md
  modified: []
decisions:
  - "Tab.-4.4-Annotation: [0,65] → [0,52 (kalibriert; vgl. Kap.~5.1)] für Konsistenz mit Tab. 5.1"
  - "Einfügeposition SYST-02: fundamentals-2.typ nach Zeile 37 (vor #figure bei Zeile 38)"
  - "SYST-02-Fix dient gleichzeitig DOKU-02 (Phase 40) — keine Doppelarbeit nötig"
metrics:
  duration: "~10min"
  completed: "2026-07-17"
  tasks: 2
  files_created: 1
  files_modified: 0
---

# Phase 31 Plan 01: Systematik Audit Summary

## One-Liner

Vollständige Inventarisierung aller 0,65/0,52-Schwellenwert-Vorkommen (5 Stellen, 2 FIX / 3 KEEP) und IDLE/CANDIDATE/ACTIVE-Terminologie-Vorkommen vor Kap.-4.3-Definition (7 Stellen) mit exakter Einfügeposition in fundamentals-2.typ:37.

## Tasks Completed

| Task | Name | Commit | Files |
|------|------|--------|-------|
| 1 | Schwellenwert-Vorkommen kartieren (SYST-01) | 8a8eff4 | `.planning/phases/31-systematik/31-AUDIT.md` |
| 2 | Terminologie-Vorkommen vor Definition kartieren (SYST-02) | 8a8eff4 | `.planning/phases/31-systematik/31-AUDIT.md` |

## What Was Done

### Task 1 (SYST-01): Schwellenwert-Klassifikation

`grep -n "0,65" T2000_Part1/chapters/*.typ` lieferte exakt 5 Vorkommen:

| Datei | Zeile | Klassifikation |
|-------|-------|---------------|
| `methodology.typ` | 124 | **FIX** — Tab. 4.4 zeigt 0,65 als operativen Parameter |
| `practical-1.typ` | 59 | **FIX** — Fletcher-Diagramm Abb. 5.1 Rautenknoten |
| `practical-1.typ` | 40 | KEEP — Kalibrierungs-Narrative (Literaturwert erklärt, warum er verworfen wurde) |
| `discussion.typ` | 46 | KEEP — Robustheitstabelle Vorher/Nachher-Experiment |
| `discussion.typ` | 55 | KEEP — Prosa Kalibrierungsexperiment-Narrative |

Zusätzliche Entscheidung dokumentiert: Tab. 4.4 erhält bei der Änderung `(kalibriert; vgl. Kap.~5.1)` als Annotation (analog Tab. 5.1 in practical-1.typ:28).

### Task 2 (SYST-02): Terminologie-Kartierung

`grep -n "IDLE\|CANDIDATE\|ACTIVE"` in fundamentals-2.typ und methodology.typ:

- Formale Definitionssektion beginnt: `methodology.typ:60 == State Machine: IDLE → CANDIDATE → ACTIVE`
- Vorkommen vor dieser Grenze: 7 (fundamentals-2.typ: 3, methodology.typ vor Zeile 60: 4)
- Exakte Einfügeposition: fundamentals-2.typ nach Zeile 37 (Leerzeile nach Prosa-Absatz), vor `#figure(` bei Zeile 38
- Definitions-Wortlaut aus 31-RESEARCH.md in 31-AUDIT.md festgehalten

## Deviations from Plan

None — Plan executed exactly as written. Beide Tasks haben die vollständige 31-AUDIT.md in einem Write erzeugt (Datei ist identisch, beide Tabellen enthalten).

## Verification Results

- `grep -n "0,65" T2000_Part1/chapters/*.typ` liefert weiterhin 5 Vorkommen — Wave 1 hat keine Quelldateien geändert
- 31-AUDIT.md enthält beide Tabellen (Schwellenwert + Terminologie) mit allen geforderten Klassifikationen
- Genau 2 FIX-Einträge (methodology.typ:124, practical-1.typ:59)
- Mindestens 7 JA-Vorkommen (vor Kap.-4.3-Definition) dokumentiert
- Einfügeposition fundamentals-2.typ:37 und Definitions-Wortlaut fixiert
- DOKU-02-Doppelnutzen vermerkt

## Known Stubs

None — 31-AUDIT.md ist ein vollständiges Audit-Dokument ohne Platzhalter.

## Self-Check: PASSED

- `.planning/phases/31-systematik/31-AUDIT.md` — EXISTS
- Commit `8a8eff4` — EXISTS (git rev-parse verified)
- 0,65 occurrences unchanged (5) — CONFIRMED by grep
