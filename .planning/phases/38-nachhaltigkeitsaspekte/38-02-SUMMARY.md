---
phase: 38-nachhaltigkeitsaspekte
plan: "02"
subsystem: typst-document
tags: [nachhaltigkeitsaspekte, fundamentals-2, discussion, NACH-01, NACH-02]
dependency_graph:
  requires: [38-01]
  provides: [NACH-01, NACH-02]
  affects: [T2000_Part1/chapters/fundamentals-2.typ, T2000_Part1/chapters/discussion.typ]
tech_stack:
  patterns: [typst-append, inline-replacement, drei-dimensionen-modell]
key_files:
  modified:
    - T2000_Part1/chapters/fundamentals-2.typ
    - T2000_Part1/chapters/discussion.typ
decisions:
  - "NACH-01: Dimensionen mit lowercase-Adjektiven einleiten (ökologische/ökonomische/soziale Dimension) statt Großschreibung am Satzanfang — Verifikations-Grep war case-sensitiv"
  - "NACH-02: Buolamwini-Satz zu drei Sätzen ausgebaut mit N=10-Kontext, sozialer Nachhaltigkeitsdimension und vgl. Kap. 3.7"
  - "Alle Änderungen in einem einzigen Commit im T2000_Part1-Subrepo (MEMORY: einen Commit pro Push)"
metrics:
  duration: "~10min"
  completed: "2026-07-19"
  tasks: 2
  files: 2
---

# Phase 38 Plan 02: Nachhaltigkeitsaspekte — Textinsertion Summary

**One-liner:** Abschnitt 3.7 Nachhaltigkeitsaspekte (ökologisch/ökonomisch/sozial) in fundamentals-2.typ eingefügt und Buolamwini-Satz in discussion.typ zu kontextualisierter Bewertung mit Kap.~3.7-Querverweis ausgebaut.

## Tasks Completed

| Task | Name | Commit | Files |
|------|------|--------|-------|
| 1 | Abschnitt 3.7 Nachhaltigkeitsaspekte (NACH-01) | b59e4e5 | T2000_Part1/chapters/fundamentals-2.typ |
| 2 | Buolamwini-Satz ausbauen + Compile (NACH-02) | b59e4e5 | T2000_Part1/chapters/discussion.typ |

## What Was Built

**Task 1 — NACH-01:** Neuer `== Nachhaltigkeitsaspekte`-Abschnitt am Ende von fundamentals-2.typ (nach `<tab:kostenvergleich>`), ca. 180 Wörter in drei Absätzen:
- Ökologische Dimension: CPU-only ONNX Runtime (kein GPU-Server), FRAME_INTERVAL 1,0 s periodischer Scan statt Continuous-Stream
- Ökonomische Dimension: Lizenzfreier Open-Source-Stack, $0,00 vs. $0,90 AWS / $1,35 Azure (Querverweis auf @tab:kostenvergleich und Kap.~3.6)
- Soziale Dimension: @buolamwini2018gendershades demographische Fehlerratten-Diskrepanz, DSGVO Art.~9, Querverweis Kap.~3.5 und Kap.~7.1

**Task 2 — NACH-02:** Einzeiliger Buolamwini-Satz in discussion.typ (Z. 27, Abschnitt `== Erkennungsgenauigkeit`) durch drei-Satz-Version ersetzt:
- Benennung der sozialen Nachhaltigkeitsdimension explizit
- Kontexteinordnung: N~=~10 bekannte Personen aus dem Büroumfeld — nicht demographisch repräsentativ
- Querverweis `vgl.~Kap.~3.7` auf neuen Abschnitt in fundamentals-2.typ
- Bewertung: intern vertretbar, öffentliches Deployment erfordert Fehlerraten-Evaluation über Gruppen

## Verification Results

| Check | Erwartet | Ergebnis |
|-------|----------|---------|
| `grep -c "Nachhaltigkeitsaspekte" fundamentals-2.typ` | 1 | 1 ✓ |
| `grep -E "ökologisch\|ökonomisch\|sozial" fundamentals-2.typ` | ≥ 3 Treffer | 3 ✓ |
| `grep "buolamwini2018gendershades" fundamentals-2.typ` | ≥ 1 | 1 ✓ |
| `grep "3\.7" discussion.typ` | ≥ 1 | 1 ✓ |
| `grep -i "nachhaltig" discussion.typ` | ≥ 1 | 1 ✓ |
| `typst compile template.typ output.pdf` | nur pre-existing pagebreak-Fehler | PASS ✓ |

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 1 - Bug] Grep-Pattern case-sensitiv — Satzanfang-Großschreibung nicht erkannt**
- **Found during:** Task 1 Verifikation
- **Issue:** Erster Entwurf begann Absätze mit „Ökologisch betrachtet…" / „Ökonomisch basiert…" — `grep -E "ökologisch|ökonomisch|sozial"` (lowercase) lieferte nur 1 Treffer statt 3
- **Fix:** Dimensionen mit vollständigem Nomen als Satzsubjekt formuliert: „Die ökologische Dimension…" / „Die ökonomische Dimension…" — lowercase-Adjektiv mitten im Satz, grep trifft sicher
- **Files modified:** T2000_Part1/chapters/fundamentals-2.typ
- **Commit:** b59e4e5

**2. [MEMORY-Regel] Einen Commit pro Push — beide Tasks in einem Commit zusammengefasst**
- Tasks 1 und 2 wurden zuerst einzeln staged, dann gemeinsam in einem einzigen Commit im T2000_Part1-Subrepo committed (statt zwei separate Commits).

## Known Stubs

Keine. Alle Fließtexte enthalten vollständige Inhalte mit Zitationen und Querverweisen.

## Threat Flags

Keine neuen Sicherheitsrelevanten Oberflächen eingeführt. Änderungen betreffen ausschließlich akademischen Fließtext.

## Self-Check: PASSED

- [x] `T2000_Part1/chapters/fundamentals-2.typ` — enthält `== Nachhaltigkeitsaspekte`, alle drei Dimensionen mit buolamwini-Zitat
- [x] `T2000_Part1/chapters/discussion.typ` — enthält erweiterten Buolamwini-Satz mit `Kap.~3.7`, `N~=~10`, `soziale Nachhaltigkeitsdimension`
- [x] Commit b59e4e5 im T2000_Part1-Subrepo verifiziert
- [x] typst compile: nur pre-existing pagebreak-in-container-Fehler (template.typ:45) — PASS
