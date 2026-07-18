---
phase: 36-nutzung-fachwissen
verified: 2026-07-18T14:20:00Z
status: passed
score: 7/7 must-haves verified
overrides_applied: 0
re_verification: false
---

# Phase 36: Nutzung Fachwissen — Verification Report

**Phase Goal:** Drei fachliche Tiefenlücken schließen — WISS-01 (geometrische ArcFace/CosFace-Erklärung), WISS-02 (RAG-Modell MTEB-Benchmark-Begründung), WISS-03 (EMA-Literaturkontext mit biometrischem Dilemma)
**Verified:** 2026-07-18T14:20:00Z
**Status:** PASSED
**Re-verification:** No — initial verification

---

## Goal Achievement

### Observable Truths

| # | Truth | Status | Evidence |
|---|-------|--------|----------|
| 1 | Kap. 2.2.2 explains the geometric difference: cos(theta + m) vs. cos(theta) - m with geodetic-distance rationale | VERIFIED | Lines 46-48 fundamentals-1.typ: "CosFace addiert die Marge direkt auf den Kosinuswert ($cos(theta) - m$), während ArcFace die Marge auf den Winkel selbst aufschlägt ($cos(theta + m)$)" + geodätisch on line 48 |
| 2 | practical-2.typ Kap. 6.2 cites muennighoff2023mteb with MTEB score 56,53 | VERIFIED | Line 72 practical-2.typ: score 56,53, 79,80, 58,44 with @muennighoff2023mteb[S.~2020--2022] |
| 3 | sources.bib contains a valid muennighoff2023mteb @inproceedings entry with doi 10.18653/v1/2023.eacl-main.148 | VERIFIED | Lines 302-314 sources.bib: complete @inproceedings entry with correct DOI, pages 2014--2037, EACL 2023, Lo{"i}c umlaut escape |
| 4 | practical-1.typ Kap. 5.3 contains a biometric dilemma paragraph before the EMA sentence | VERIFIED | Line 122 practical-1.typ: "Ein statisches Template veraltet..." + "das biometrische Dilemma besteht darin..." + "Adaptive Erscheinungsmodelle lösen dieses Dilemma...@dewan2016adaptiveappearance[S.~129--131]" |
| 5 | Anchor sentences in all three source files are intact (no existing text removed or modified) | VERIFIED | Anchor sentence line 45 fundamentals-1.typ unchanged; anchor sentence line 71 practical-2.typ unchanged; EMA anchor "Dieses Exponential Weighted Moving Average-Verfahren" line 123 practical-1.typ unchanged; EMA formula line 117 unchanged |
| 6 | Dual citation deng2019arcface + wang2018cosface present in WISS-01 insertion | VERIFIED | Both keys appear on line 48 in inserted text; deng2019arcface appears on lines 45, 46, 48 (3 hits); wang2018cosface on lines 43, 45, 48 (3 hits) |
| 7 | dewan2016adaptiveappearance cited >= 2 times in practical-1.typ (existing + new) | VERIFIED | grep -c returns 2: line 122 (new dilemma paragraph) + line 123 (existing EMA sentence) |

**Score:** 7/7 truths verified

---

## Required Artifacts

| Artifact | Expected | Status | Details |
|----------|----------|--------|---------|
| `T2000_Part1/chapters/fundamentals-1.typ` | Kap. 2.2.2 extended with 4-sentence geometric ArcFace/CosFace explanation; contains "geodätisch" | VERIFIED | Lines 46-48 inserted after anchor line 45; "geodätisch" present on line 48; "Winkelmarge"/"Kosinusmarge" each present; causal explanation via nonlinear cosine function and geodetic distance on unit hypersphere |
| `T2000_Part1/chapters/practical-2.typ` | Kap. 6.2 extended with MTEB-score sentence after Sentence-BERT anchor; contains "muennighoff2023mteb" | VERIFIED | Line 72 inserted after anchor line 71; citation @muennighoff2023mteb present; score 56,53 present |
| `T2000_Part1/user/sources.bib` | New muennighoff2023mteb @inproceedings entry with doi 10.18653/v1/2023.eacl-main.148 | VERIFIED | Lines 302-314: all required fields present — title, author (4 authors with Lo{"i}c escape), booktitle, pages 2014--2037, year 2023, publisher, address Dubrovnik, doi, eprint 2210.07316, archivePrefix arXiv |
| `T2000_Part1/chapters/practical-1.typ` | Kap. 5.3 biometric dilemma paragraph before EMA sentence; contains "veraltet" | VERIFIED | Line 122 inserted before EMA anchor line 123; "veraltet", "Dilemma", "Ausreißer" all present on line 122; @dewan2016adaptiveappearance cited; EMA formula on line 117 unchanged |
| `.planning/phases/36-nutzung-fachwissen/36-AUDIT.md` | Insertion-point anchors for all 3 WISS requirements (Wave 1 output) | VERIFIED | File exists; provided anchor strings consumed correctly by Wave 2 executor |
| `.planning/phases/36-nutzung-fachwissen/36-FINALCHECK.md` | PASS verdicts for WISS-01, WISS-02, WISS-03 (Wave 3 output) | VERIFIED | File exists; WISS-01, WISS-02, WISS-03 all record PASS; compilation failure documented as pre-existing |

---

## Key Link Verification

| From | To | Via | Status | Details |
|------|----|-----|--------|---------|
| `T2000_Part1/chapters/practical-2.typ` | `T2000_Part1/user/sources.bib` | @muennighoff2023mteb citation in text | WIRED | Citation on line 72 practical-2.typ; key muennighoff2023mteb found on line 302 sources.bib; DOI verified |

---

## Data-Flow Trace (Level 4)

Not applicable. This phase modifies academic paper source files (Typst + BibTeX), not software components with data flows. Artifacts are static text documents, not dynamic renderers.

---

## Behavioral Spot-Checks

| Behavior | Command | Result | Status |
|----------|---------|--------|--------|
| "geodätisch" present in fundamentals-1.typ | `grep -c "geodätisch" fundamentals-1.typ` | 1 hit (line 48) | PASS |
| MTEB score 56,53 present in practical-2.typ | `grep -c "56,53" practical-2.typ` | 1 hit (line 72) | PASS |
| muennighoff2023mteb in sources.bib | `grep -c "muennighoff2023mteb" sources.bib` | 1 hit (line 302) | PASS |
| DOI correct in sources.bib | `grep -c "10.18653/v1/2023.eacl-main.148" sources.bib` | 1 hit (line 310) | PASS |
| "veraltet" present in practical-1.typ | `grep -c "veraltet" practical-1.typ` | 1 hit (line 122) | PASS |
| "Dilemma" present in practical-1.typ | `grep -n "Dilemma" practical-1.typ` | 1 hit (line 122) | PASS |
| dewan2016adaptiveappearance >= 2 hits | `grep -c "dewan2016adaptiveappearance" practical-1.typ` | 2 hits (lines 122, 123) | PASS |
| EMA formula line unchanged | `grep -n "bold(e)_" practical-1.typ` | Present (line 117) | PASS |
| Anchor sentence WISS-01 intact | `grep -n "geometrischen Art" fundamentals-1.typ` | Present (line 45) | PASS |
| Anchor sentence WISS-02 intact | `grep -n "kompakten Einbettungsräumen optimiert" practical-2.typ` | Present (line 71) | PASS |
| EMA anchor sentence WISS-03 intact | `grep -n "Dieses Exponential Weighted" practical-1.typ` | Present (line 123) | PASS |

---

## Probe Execution

| Probe | Command | Result | Status |
|-------|---------|--------|--------|
| Typst compilation | `typst compile template.typ /tmp/out.pdf` (from T2000_Part1/) | Exit 1 — `pagebreaks are not allowed inside of containers` at template.typ:45 | FAIL — PRE-EXISTING |

**Pre-existing finding:** The compilation error at template.typ:45 (`pagebreak(weak: true)` inside a `#show heading` block) is a Typst 0.15 regression. Git log of Wave-2 commits (101a65e, b3ef97d, ab66607) shows `template.typ` was not modified in any of the three Wave-2 commits. The file `template.typ` contains this construct on line 45, and none of Phase 36's changes touch it. This is outside the scope of WISS-01/02/03. The last successful compilation predates Phase 36.

---

## Requirements Coverage

| Requirement | Source Plan | Description | Status | Evidence |
|-------------|-------------|-------------|--------|----------|
| WISS-01 | 36-01-PLAN, 36-02-PLAN, 36-03-PLAN | Geometric difference ArcFace (angular margin) vs. CosFace (cosine margin) explained in Kap. 2.2.2 | SATISFIED | Lines 46-48 fundamentals-1.typ contain 4-sentence causal explanation with cos(theta+m)/cos(theta)-m formulas, nonlinearity argument, geodetic distance conclusion, dual citation |
| WISS-02 | 36-01-PLAN, 36-02-PLAN, 36-03-PLAN | all-MiniLM-L12-v2 model choice justified with MTEB benchmark score in Kap. 6.2 | SATISFIED | Line 72 practical-2.typ: score 56,53 over 56 tasks with sub-scores 79,80/58,44; @muennighoff2023mteb citation; valid BibTeX entry in sources.bib |
| WISS-03 | 36-01-PLAN, 36-02-PLAN, 36-03-PLAN | EMA alpha=0,2 given literature context on adaptive appearance models and biometric dilemma in Kap. 5.3 | SATISFIED | Line 122 practical-1.typ: biometric dilemma paragraph covers template decay, overwrite risk, and adaptive weighting solution; @dewan2016adaptiveappearance[S.~129--131] |

**Orphaned requirements:** None. REQUIREMENTS.md maps WISS-01, WISS-02, WISS-03 to Phase 36 and all three are addressed.

---

## Anti-Patterns Found

| File | Line | Pattern | Severity | Impact |
|------|------|---------|----------|--------|
| — | — | — | — | — |

No anti-patterns found. No TBD/FIXME/XXX/TODO markers in modified files. No stub implementations. No placeholder text. All inserted paragraphs contain substantive content with literature citations.

---

## Human Verification Required

None. All three WISS criteria are verifiable by grep against source file content. The causal quality of the WISS-01 geometric explanation (not just an assertion) was confirmed by reading the actual inserted text in the FINALCHECK — the nichtlineare Kosinus-Funktion argument and geodätische Distanz argument are present as causal statements, not assertions.

---

## Gaps Summary

No gaps. All seven must-have truths are verified against actual file content. The Typst compilation failure is pre-existing and outside Phase 36 scope (template.typ untouched by Phase 36 commits).

---

_Verified: 2026-07-18T14:20:00Z_
_Verifier: Claude (gsd-verifier)_
