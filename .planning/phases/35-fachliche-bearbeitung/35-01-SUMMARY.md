# 35-01-SUMMARY

**Plan:** 35-01 — Audit discussion.typ for FACH gaps  
**Status:** COMPLETED  
**Wave:** 1

## Tasks completed

- T1: Audited all 73 lines of `T2000_Part1/chapters/discussion.typ`
  - FACH-01: No Versuchsbeschreibung paragraph before `== Erkennungsgenauigkeit` (line 5); insertion point: after line 3
  - FACH-02: No FP/FN text for Gaze-Check anywhere; insertion point: after line 48 (end of Systemlatenz prose), before `== Robustheit`
  - FACH-03: Multi-Person cell (line 63) contains only `[Gleichzeitige Ankünfte]` (descriptive, no metric); insertion point: replace cell + append to prose after line 72

## Output

- Created: `.planning/phases/35-fachliche-bearbeitung/35-AUDIT.md` with per-gap findings, exact line numbers, current cell content, and insertion points for Wave 2.

## Must-haves met

- [x] 35-AUDIT.md documents exact line numbers for all three FACH gaps
- [x] 35-AUDIT.md records current cell content of Multi-Person table row: `[Gleichzeitige Ankünfte]`
- [x] 35-AUDIT.md confirms no Versuchsbeschreibung paragraph exists before `== Erkennungsgenauigkeit`
- [x] 35-AUDIT.md confirms no Gaze-Check FP/FN evaluation exists in the Systemlatenz section
