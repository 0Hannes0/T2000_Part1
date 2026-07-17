# Phase 32: Literaturrecherche — Finalcheck

**Datum:** 2026-07-17

## LITR-01: DSGVO

| P# | Prüfung | Befund | Status |
|---|---------|--------|--------|
| P1 | grep -rn "\[DSGVO" chapters/ | 0 Treffer | OK |
| P2 | @dsgvo2016 in fundamentals-2.typ (Vorkommen) | 3 Vorkommen auf 2 Zeilen (Z. 170 hat 2× auf einer Zeile) | OK |
| P3 | @misc{dsgvo2016 in sources.bib | 1 Eintrag | OK |
| P4 | dsgvo2016 hat Felder title/author/year/howpublished/url | title, author, year={2016}, howpublished (Amtsblatt L 119), url vorhanden | OK |

## LITR-02: arXiv-Upgrades

| P# | Key | Typ jetzt | Befund | Status |
|---|-----|-----------|--------|--------|
| P5a | cheng2021gazesurvey | @article | Appearance-Based Gaze Estimation With Deep Learning: A Review and Benchmark | OK |
| P5b | zhang2015mpiigaze | @inproceedings | Appearance-Based Gaze Estimation in the Wild | OK |
| P5c | kellnhofer2019gaze360 | @inproceedings | Gaze360: Physically Unconstrained Gaze Estimation in the Wild | OK |
| P5d | bewley2016sort | @inproceedings | Simple Online and Realtime Tracking | OK |
| P5e | wojke2017deepsort | @inproceedings | Simple Online and Realtime Tracking with a Deep Association Metric | OK |
| P7 | @misc gesamt count | 4 (war 12, Grenzwert ≤5) | — |
| P8 | barquero doi + year | year={2020}, doi={10.1109/IJCB48548.2020.9304892} | OK |

Verbleibende @misc-Einträge (4): bazarevsky, lugaresi, guo2021scrfd, dsgvo2016 — alle legitim (Google-interne Libs bzw. EU-Rechtsverordnung).

## LITR-03: VLM/Gaze

| P# | Prüfung | Befund | Status |
|---|---------|--------|--------|
| P9 | yin2024clipgaze in sources.bib | 1 Eintrag | OK |
| P10 | yin2024lggaze in sources.bib | 1 Eintrag | OK |
| P11 | @yin2024clipgaze in chapters/ | 2 Treffer: fundamentals-1.typ:19, methodology.typ:50 | OK |
| P12 | @yin2024lggaze in chapters/ | 1 Treffer: fundamentals-1.typ:19 | OK |
| P13 | yin2024clipgaze doi + booktitle | doi={10.1609/aaai.v38i7.28496}, booktitle="Proceedings of the AAAI Conference on Artificial Intelligence" | OK |

## LITR-04: hogenhout-Ersatz

| P# | Prüfung | Befund | Status |
|---|---------|--------|--------|
| P15 | hogenhout in sources.bib | 0 Einträge | OK |
| P16 | @hogenhout in chapters/ | 0 Treffer | OK |
| P17 | krivokucahahn2023biometricprotection in sources.bib | 1 Eintrag | OK |
| P18 | @krivokucahahn2023biometricprotection in chapters/ | 3 Treffer: fundamentals-2.typ:166, conclusion.typ:25, practical-2.typ:94 | OK |

## Syntax

| P# | Prüfung | Befund | Status |
|---|---------|--------|--------|
| P19 | ^@ count == ^} count | 40 == 40 | OK |

## Abschlusstabelle

| LITR | Status |
|------|--------|
| LITR-01 (DSGVO) | OK |
| LITR-02 (arXiv-Upgrades) | OK |
| LITR-03 (VLM/Gaze) | OK |
| LITR-04 (hogenhout) | OK |

Phase 32 abgeschlossen — alle LITR-Kriterien erfüllt, keine Nacharbeit notwendig.
