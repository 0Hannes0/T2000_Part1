---
phase: 31-systematik
plan: "02"
subsystem: typst-content
tags: [typst, threshold, state-machine, syst-01, syst-02, wave-2]
dependency_graph:
  requires: [31-01]
  provides: [SYST-01-fix, SYST-02-fix]
  affects: [31-03-PLAN.md]
tech_stack:
  added: []
  patterns: [chirurgische-typst-edit, python-string-replace]
key_files:
  created: []
  modified:
    - T2000_Part1/chapters/methodology.typ
    - T2000_Part1/chapters/practical-1.typ
    - T2000_Part1/chapters/fundamentals-2.typ
decisions:
  - "SYST-01: Tab. 4.4 (methodology.typ:124) und Abb. 5.1 (practical-1.typ:59) auf 0,52 korrigiert — vier KEEP-Stellen der Kalibrierungs-Narrative unverändert"
  - "SYST-02: Definitionsabsatz in fundamentals-2.typ:38 eingefügt (vor Pipeline-Diagramm) — erfüllt zugleich DOKU-02 (Phase 40)"
metrics:
  duration: "~15min"
  completed: "2026-07-17"
  tasks: 2
  files_created: 0
  files_modified: 3
---

# Phase 31 Plan 02: Systematik Fixes Summary

## One-Liner

Drei chirurgische Typst-Edits: Tab. 4.4 und Abb. 5.1 von 0,65 auf 0,52 korrigiert (SYST-01), State-Machine-Definitionsabsatz in Kap. 3.1 vor dem Pipeline-Diagramm eingefügt (SYST-02).

## Tasks Completed

| Task | Name | Commit | Files |
|------|------|--------|-------|
| 1 | SYST-01: Schwellenwert 0,65 auf 0,52 in Tab. 4.4 und Abb. 5.1 | `3d49666` | `methodology.typ`, `practical-1.typ` |
| 2 | SYST-02: State-Machine-Definitionsabsatz in fundamentals-2.typ einfügen | `f9a40fc` | `fundamentals-2.typ` |

## What Was Done

### Task 1 (SYST-01): Schwellenwert-Korrekturen

Exakt zwei FIX-Stellen aus dem Audit bearbeitet:

| Datei | Zeile | Alt | Neu |
|-------|-------|-----|-----|
| `methodology.typ` | 124 | `[0,65]` | `[0,52 (kalibriert; vgl. Kap.~5.1)]` |
| `practical-1.typ` | 59 | `ArcFace-Score ≥ 0,65?` | `ArcFace-Score ≥ 0,52?` |

Alle vier KEEP-Stellen der Kalibrierungs-Narrative bleiben unverändert:
- `practical-1.typ:40` — Literaturwert 0,65 in Fließtext (historische Baseline)
- `discussion.typ:46` — Robustheitstabelle Vorher/Nachher-Experiment
- `discussion.typ:55` — Prosa Kalibrierungsexperiment-Narrative

### Task 2 (SYST-02): State-Machine-Definitionsabsatz

Neuer Absatz in `fundamentals-2.typ` nach der Kap.-3.1-Prosa (Zeile 36) und vor dem Pipeline-Diagramm (Abb. 3.2, vorher Zeile 38, jetzt Zeile 40) eingefügt:

```
Die Zustandsverwaltung jeder erkannten Person wird durch eine `PresenceStateMachine` modelliert,
die drei Zustände kennt: _IDLE_ (Person nicht aktiv erkannt), _CANDIDATE_ (Person erkannt,
Interaktionsabsicht wird durch den Gaze-Check geprüft) und _ACTIVE_ (Gaze-Check positiv,
Sitzung läuft). Kap.~4.3 beschreibt den Zustandsautomaten vollständig.
```

Dieser Absatz definiert alle drei Zustandsnamen vor ihrem ersten Erscheinen im Pipeline-Diagramm (Zeile 48: `PresenceStateMachine IDLE → CANDIDATE → ACTIVE`). Er erfüllt zugleich DOKU-02 (Phase 40).

## Verification Results

```
grep -n "ArcFace-Score.*0,65" T2000_Part1/chapters/practical-1.typ  → kein Treffer (PASS)
grep -c "0,65" T2000_Part1/chapters/methodology.typ                 → 0 (PASS)
grep -c "0,65" T2000_Part1/chapters/practical-1.typ                 → 1 (KEEP-Stelle intakt)
grep -c "0,65" T2000_Part1/chapters/discussion.typ                  → 2 (beide KEEP-Stellen intakt)
grep -q "Die Zustandsverwaltung jeder erkannten Person" fundamentals-2.typ → OK (PASS)
```

## Deviations from Plan

None — Plan executed exactly as written. Alle drei Edits wie im Audit beschrieben durchgeführt, Liniennummern stimmten exakt überein.

**Technische Anmerkung:** Da `T2000_Part1` ein eigenständiges Git-Repository (nested, kein konfiguriertes Submodul) ist, wurden die Commits direkt in das T2000_Part1-Repository geschrieben (nicht in den outer-repo-Worktree). Die Datei `user/abbreviations.typ` enthielt eine vorbestehende, unstaged Modifikation (zwei Abkürzungseinträge entfernt), die nicht Teil dieser Phase ist und unverändert belassen wurde.

## Known Stubs

None.

## Self-Check: PASSED

- `T2000_Part1/chapters/methodology.typ` — MODIFIED, contains `0,52 (kalibriert; vgl. Kap.~5.1)`
- `T2000_Part1/chapters/practical-1.typ` — MODIFIED, contains `ArcFace-Score ≥ 0,52?`
- `T2000_Part1/chapters/fundamentals-2.typ` — MODIFIED, contains Definitionsabsatz
- Commit `3d49666` — EXISTS in T2000_Part1 repo
- Commit `f9a40fc` — EXISTS in T2000_Part1 repo
