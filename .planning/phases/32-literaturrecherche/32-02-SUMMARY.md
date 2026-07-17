---
phase: 32-literaturrecherche
plan: "02"
subsystem: bibliography
tags: [bibtex, citations, dsgvo, arxiv-upgrade, vlm-gaze, hogenhout-replacement]
dependency_graph:
  requires: [32-01]
  provides: [LITR-01, LITR-02, LITR-03, LITR-04]
  affects: [T2000_Part1/user/sources.bib, T2000_Part1/chapters/fundamentals-1.typ, T2000_Part1/chapters/fundamentals-2.typ, T2000_Part1/chapters/conclusion.typ, T2000_Part1/chapters/methodology.typ, T2000_Part1/chapters/practical-2.typ]
tech_stack:
  added: []
  patterns: [bibtex-misc-to-inproceedings, dsgvo-misc-entry, pmlr-url-not-doi]
key_files:
  created: []
  modified:
    - T2000_Part1/user/sources.bib
    - T2000_Part1/chapters/fundamentals-2.typ
    - T2000_Part1/chapters/fundamentals-1.typ
    - T2000_Part1/chapters/conclusion.typ
    - T2000_Part1/chapters/methodology.typ
    - T2000_Part1/chapters/practical-2.typ
decisions:
  - "PMLR entries (radford2021clip, guu2020realm) use url field instead of doi — no classical DOI exists for PMLR proceedings"
  - "hogenhout completely replaced (not supplemented) by krivokucahahn2023biometricprotection — cleaner bibliography, no preprint"
  - "All 7 upgrades done (cheng, zhang, radford, guu, kellnhofer, bewley, wojke, zhu2021webface260m) plus barquero DOI/year fix"
metrics:
  duration: "~12 minutes"
  completed: "2026-07-17"
  tasks_completed: 2
  files_changed: 6
---

# Phase 32 Plan 02: Bibliographie-Umsetzung Summary

**One-liner:** DSGVO-@misc-Eintrag angelegt, 7 arXiv-@misc auf peer-reviewed @inproceedings/@article upgegradet, hogenhout durch IEEE-TIFS-2023-Artikel ersetzt, CLIP-Gaze + LG-Gaze als AAAI/ECCV-2024-Quellen eingetragen und inline zitiert.

---

## Was in jedem Schritt getan wurde

### Task 1: DSGVO-Eintrag anlegen und Inline-Zitate umstellen

**Step 1 — sources.bib:** Neuen `@misc{dsgvo2016,...}`-Eintrag nach dem `voigt2017gdpr`-Eintrag eingefügt (Kap.-3-Abschnitt). Enthält alle Pflichtfelder: title, author, year=2016, howpublished (Amtsblatt EU, L 119), note (Inkrafttreten 25. Mai 2018), url (EUR-Lex).

**Step 2 — fundamentals-2.typ:** Alle drei manuellen `[DSGVO 2016, Art.~X]`-Klammertexte auf Typst-`@dsgvo2016[Art.~X]`-Referenzen umgestellt:
- Zeile 166: `[DSGVO 2016, Art.~9 Abs.~1]` → `@dsgvo2016[Art.~9 Abs.~1]`
- Zeile 170: `[DSGVO 2016, Art.~17]` → `@dsgvo2016[Art.~17]`
- Zeile 170: `[DSGVO 2016, Art.~35]` → `@dsgvo2016[Art.~35]`

### Task 2A: 7 arXiv-Upgrades + barquero-Fix

Alle 7 `@misc`-Einträge auf publizierte Versionen upgegradet:

| Key | Vorher | Nachher | Venue |
|-----|--------|---------|-------|
| cheng2021gazesurvey | @misc | @article | IEEE TPAMI, vol. 46(12), S. 7509–7528, 2024 |
| zhang2015mpiigaze | @misc | @inproceedings | CVPR 2015, S. 4511–4520 |
| radford2021clip | @misc | @inproceedings | ICML 2021, PMLR vol. 139, S. 8748–8763 |
| guu2020realm | @misc | @inproceedings | ICML 2020, PMLR vol. 119, S. 3929–3938 |
| kellnhofer2019gaze360 | @misc | @inproceedings | ICCV 2019, S. 6911–6920 |
| bewley2016sort | @misc | @inproceedings | ICIP 2016, S. 3464–3468 |
| wojke2017deepsort | @misc | @inproceedings | ICIP 2017, S. 3645–3649 |
| zhu2021webface260m | @misc | @inproceedings | CVPR 2021, S. 10492–10502 |

Außerdem: `barquero2020longtermtracking` war bereits `@inproceedings`, aber hatte arXiv-DOI und falsches Jahr. Korrigiert:
- doi: `10.48550/arXiv.2010.08675` → `10.1109/IJCB48548.2020.9304892`
- year: `2021` → `2020`

PMLR-Einträge (radford, guu): Kein `doi`-Feld — stattdessen `url`-Feld mit proceedings.mlr.press-URL (PMLR hat keinen klassischen IEEE/ACM-DOI).

### Task 2B: hogenhout-Ersatz

`@misc{hogenhout2025biometricprivacy,...}` vollständig aus sources.bib gelöscht.

Ersetzt durch:
```
@article{krivokucahahn2023biometricprotection,
  journal = {IEEE Transactions on Information Forensics and Security},
  volume = {18}, pages = {639--666}, year = {2023},
  doi = {10.1109/TIFS.2022.3228494}
}
```

Alle drei hogenhout-Zitierungen in .typ-Dateien ersetzt:
- `fundamentals-2.typ` Zeile 166: `@hogenhout2025biometricprivacy[S.~2--4]` → `@krivokucahahn2023biometricprotection[S.~639--641]`
- `conclusion.typ` Zeile 25: gleiche Ersetzung
- `practical-2.typ` Zeile 94: gleiche Ersetzung

### Task 2C: VLM/Gaze-Quellen eintragen

Zwei neue Einträge in sources.bib (nach cheng2021gazesurvey-Block im Kap.-2-Abschnitt):
- `@inproceedings{yin2024clipgaze,...}` — AAAI 2024, doi=10.1609/aaai.v38i7.28496
- `@inproceedings{yin2024lggaze,...}` — ECCV 2024 (Springer LNCS 15083), doi=10.1007/978-3-031-73010-8_1

### Task 2D: VLM/Gaze-Quellen inline zitieren

- `fundamentals-1.typ` Zeile 19: Nach `...per Prompt` eingefügt: `@yin2024clipgaze[S.~6729--6730], @yin2024lggaze[S.~1--2]`
- `methodology.typ` Zeile 50: Nach `@kellnhofer2019gaze360[S.~1]` eingefügt: `, @yin2024clipgaze[S.~6729--6730]`

---

## Verifizierungsergebnisse

| Check | Erwartet | Ergebnis |
|-------|----------|----------|
| `grep -rn "\[DSGVO" chapters/` | 0 Treffer | 0 hits |
| `grep -c "dsgvo2016" sources.bib` | ≥1 | 1 |
| `grep -o "@dsgvo2016" fundamentals-2.typ \| wc -l` | 3 | 3 |
| `grep -c "hogenhout" sources.bib` | 0 | 0 |
| `grep -rn "hogenhout" chapters/` | 0 Treffer | 0 hits |
| `grep -c "krivokucahahn2023biometricprotection" sources.bib` | ≥1 | 1 |
| `grep -c "yin2024clipgaze\|yin2024lggaze" sources.bib` | 2 | 2 |
| `grep -rn "@yin2024clipgaze" chapters/` | ≥2 Treffer | 2 (fundamentals-1.typ:19, methodology.typ:50) |
| `grep -rn "@yin2024lggaze" chapters/` | ≥1 Treffer | 1 (fundamentals-1.typ:19) |
| cheng2021gazesurvey journal | IEEE TPAMI | IEEE Transactions on Pattern Analysis and Machine Intelligence |
| zhang2015mpiigaze doi | 10.1109/CVPR.2015.7299081 | 10.1109/CVPR.2015.7299081 |
| kellnhofer2019gaze360 doi | 10.1109/ICCV.2019.00701 | 10.1109/ICCV.2019.00701 |
| bewley2016sort doi | 10.1109/ICIP.2016.7533003 | 10.1109/ICIP.2016.7533003 |
| wojke2017deepsort doi | 10.1109/ICIP.2017.8296962 | 10.1109/ICIP.2017.8296962 |
| barquero2020longtermtracking doi | 10.1109/IJCB48548.2020.9304892 | 10.1109/IJCB48548.2020.9304892 |
| barquero2020longtermtracking year | 2020 | 2020 |
| @inproceedings + @article Gesamtanzahl | gestiegenen von Ausgangswert | 33 (war ~25 vor Upgrades) |
| @misc Gesamtanzahl | gesunken | 4 (bazarevsky, lugaresi, guo2021scrfd + dsgvo2016) |

---

## Deviations from Plan

### Deviation 1: hogenhout hat 3 Stellen, nicht 2

**Found during:** Pre-execution audit (Wave 1 note in prompt context)
**Issue:** Der ursprüngliche Plan nannte 2 hogenhout-Stellen (fundamentals-2.typ + conclusion.typ). Eine dritte Stelle existiert in `practical-2.typ` Zeile 94.
**Fix:** Alle drei Stellen ersetzt (fundamentals-2.typ, conclusion.typ, practical-2.typ).
**Files modified:** T2000_Part1/chapters/practical-2.typ
**Rule applied:** Rule 2 (missing correctness fix — alle Instanzen einer zu ersetzenden Quelle müssen ersetzt werden)

### No other deviations

Plan executed exactly as written for all other steps.

---

## Known Stubs

None. All citation replacements are wired to real sources.bib entries.

---

## Threat Flags

None. No new network endpoints, auth paths, or schema changes introduced. BibTeX edits only.

---

## Self-Check: PASSED

- sources.bib exists and was modified: confirmed
- fundamentals-2.typ: @dsgvo2016 × 3, no [DSGVO bracket text, no hogenhout: confirmed
- fundamentals-1.typ: @yin2024clipgaze, @yin2024lggaze present: confirmed
- conclusion.typ: no hogenhout: confirmed
- methodology.typ: @yin2024clipgaze present: confirmed
- practical-2.typ: no hogenhout: confirmed
- sources.bib: hogenhout=0, krivokucahahn=1, yin2024clipgaze=1, yin2024lggaze=1, dsgvo2016=1: confirmed
