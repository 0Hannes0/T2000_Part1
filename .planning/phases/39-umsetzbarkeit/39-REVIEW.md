---
phase: 39-umsetzbarkeit
reviewed: 2026-07-19T00:00:00Z
depth: standard
files_reviewed: 2
files_reviewed_list:
  - T2000_Part1/chapters/fundamentals-2.typ
  - T2000_Part1/chapters/conclusion.typ
findings:
  critical: 2
  warning: 1
  info: 1
  total: 4
status: issues_found
---

# Phase 39: Code Review Report

**Reviewed:** 2026-07-19
**Depth:** standard
**Files Reviewed:** 2
**Status:** issues_found

## Summary

Reviewed two Typst markup files: `fundamentals-2.typ` (Kap. 3, Konzeption, 239 lines) and `conclusion.typ` (Kap. 8, Fazit und Ausblick, 32 lines). All citation keys exist in `sources.bib` — no missing keys were found. DSGVO article references (Art. 9 Abs. 1, Art. 9 Abs. 2 lit. a, Art. 17, Art. 35) are factually correct. Typst markup structure is syntactically intact; all `#figure(...)` blocks are properly closed. Two blockers were found: a wrong citation used to support a gaze-estimation claim, and a hardcoded table number that will not match what Typst renders. One warning concerns a secondary citation used in a role it does not support. One informational item concerns an unconventional abbreviation.

---

## Critical Issues

### CR-01: Citation `@radford2021clip` does not support the gaze-estimation calibration claim

**File:** `T2000_Part1/chapters/fundamentals-2.typ:127`
**Issue:** The sentence claims that classical gaze estimation loses accuracy without individual calibration under real conditions, and cites `@cheng2021gazesurvey` and `@radford2021clip` as joint evidence. The CLIP paper (Radford et al., ICML 2021) is about learning visual representations from natural language supervision — it says nothing about gaze estimation accuracy or the need for user-specific calibration. Citing it here is factually wrong: the source neither makes nor supports the claim attributed to it. A reader who checks the citation will find no relevant content on pages S. 1–3 of that paper regarding gaze estimation.

**Fix:** Remove `@radford2021clip[S.~1--3]` from this sentence. The existing `@cheng2021gazesurvey[§1, S.~1--2]` already covers the calibration-dependency claim adequately, as it is a dedicated gaze survey. If a second citation is desired, use `@zhang2015mpiigaze` (already in the bib), which demonstrates accuracy degradation in uncalibrated "in the wild" conditions.

```diff
- klassische Gaze-Estimation ohne individuelle Kalibrierungsstufe unter realen Bedingungen erheblich an Genauigkeit verliert @cheng2021gazesurvey[§1, S.~1--2], @radford2021clip[S.~1--3].
+ klassische Gaze-Estimation ohne individuelle Kalibrierungsstufe unter realen Bedingungen erheblich an Genauigkeit verliert @cheng2021gazesurvey[§1, S.~1--2], @zhang2015mpiigaze[S.~1--2].
```

---

### CR-02: Hardcoded `Tabelle~3.2` will not match the rendered table number

**File:** `T2000_Part1/chapters/fundamentals-2.typ:161`
**Issue:** The text reads `(vgl. Tabelle~3.2)`. Typst uses global sequential numbering for tables (no chapter prefix is configured in `template.typ`). The table being referenced (`<tab:modellvergleich>`) is the third table in the document (after `<tab:anforderungen>` and `<tab:detektionsvergleich>`); Typst will render its caption as "Tabelle 3", not "Tabelle 3.2". The hardcoded string `Tabelle~3.2` will therefore produce a cross-reference that points to a number that does not exist in the document, confusing readers.

By contrast, the cross-reference to the cost table at line 236 correctly uses `@tab:kostenvergleich` — the same label-based approach should be used here.

**Fix:** Replace the hardcoded number with the Typst label reference:

```diff
- Die übrigen Alternativen liegen in Genauigkeit, Latenz oder beidem unter buffalo\_l (vgl. Tabelle~3.2).
+ Die übrigen Alternativen liegen in Genauigkeit, Latenz oder beidem unter buffalo\_l (vgl.~@tab:modellvergleich).
```

---

## Warnings

### WR-01: `@krivokucahahn2023biometricprotection` misused as a GDPR Art. 17 erasure-right citation

**File:** `T2000_Part1/chapters/conclusion.typ:28`
**Issue:** The sentence describes implementing a deletion function under GDPR Art. 17 and cites `@krivokucahahn2023biometricprotection[S.~639--641]` as supporting evidence. That paper is titled "Biometric Template Protection for Neural-Network-Based Face Recognition Systems: A Survey of Methods and Evaluation Techniques" (IEEE TIFS, 2023). Its subject is cryptographic template protection and evaluation metrics for biometric systems — not the legal right to erasure under Art. 17 DSGVO. Pages 639–641 discuss threat models for biometric templates, not GDPR compliance obligations.

The same citation appears in `fundamentals-2.typ:194` to support the statement that the DSGVO framework recognises "Identifizierbarkeit" as a protected interest (`@krivokucahahn2023biometricprotection[S.~639--641]`) — this usage is at least thematically adjacent (biometric data protection). But in `conclusion.typ:28`, attached to a concrete GDPR Art. 17 implementation requirement, the citation adds nothing the primary `@dsgvo2016[Art.~17]` does not already provide, and it misleads the reader about what the Krivokuca Hahn paper says.

**Fix:** Remove the secondary citation from this sentence. The legal obligation is fully established by `@dsgvo2016[Art.~17]` alone. If a technical implementation reference is desired, `@voigt2017gdpr` (already cited elsewhere in the chapter at S. 152–160 for Art. 35 obligations) provides GDPR Art. 17 guidance.

```diff
- ... auf Anfrage vollständig gelöscht werden können @krivokucahahn2023biometricprotection[S.~639--641].
+ ... auf Anfrage vollständig gelöscht werden können.
```

---

## Info

### IN-01: Non-standard abbreviation "DSFA" for Datenschutz-Folgenabschätzung

**File:** `T2000_Part1/chapters/conclusion.typ:27`
**Issue:** The text introduces "(DSFA)" as an abbreviation for "Datenschutz-Folgenabschätzung". The DSGVO itself uses no abbreviation; German supervisory authorities and standard legal commentary use "DSFA" (from the German) or "DPIA" (from the English "Data Protection Impact Assessment"). "DSFA" is not wrong, but it is non-standard in German practice — official BfDI guidance and most German DSGVO commentaries use "DSFA" only informally. If the abbreviation is introduced here for re-use, it should be added to `user/abbreviations.typ`. If it is used only once, the abbreviation can simply be dropped in favour of the full term.

**Fix:** Either add an entry to `user/abbreviations.typ`, or drop the parenthetical abbreviation if it is not re-used in the text:

```diff
- (2) _Datenschutz-Folgenabschätzung_ (DSFA) gemäß Art.~35 DSGVO
+ (2) _Datenschutz-Folgenabschätzung_ gemäß Art.~35 DSGVO
```

---

_Reviewed: 2026-07-19_
_Reviewer: Claude (gsd-code-reviewer)_
_Depth: standard_
