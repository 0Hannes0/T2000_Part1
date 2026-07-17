---
phase: 33-verwendung-der-literatur
plan: "02"
subsystem: Typst-Kapitel + BibTeX
tags: [litv-01, litv-02, litv-03, clip, ema, barquero, dewan, bib]
dependency_graph:
  requires: [33-01]
  provides: [LITV-01, LITV-02, LITV-03]
  affects:
    - T2000_Part1/chapters/fundamentals-1.typ
    - T2000_Part1/chapters/practical-1.typ
    - T2000_Part1/chapters/discussion.typ
    - T2000_Part1/chapters/conclusion.typ
    - T2000_Part1/user/sources.bib
tech_stack:
  added: []
  patterns:
    - "Gaze-Belege umhängen statt streichen bei verwaisten Phase-32-Quellen"
    - "eigene Beobachtung deklarieren für nicht belegte Messwerte"
key_files:
  created: []
  modified:
    - T2000_Part1/chapters/fundamentals-1.typ
    - T2000_Part1/chapters/practical-1.typ
    - T2000_Part1/chapters/discussion.typ
    - T2000_Part1/chapters/conclusion.typ
    - T2000_Part1/user/sources.bib
decisions:
  - "yin2024lggaze und yin2024clipgaze an VLM-Satz umgehängt (nicht gestrichen), da yin2024lggaze nur in fundamentals-1.typ:19 vorkam"
  - "B6 Variante (a): eigene Beobachtung deklarieren, Zahlenwerte 0,80/0,15 beibehalten"
  - "dewan2016adaptiveappearance nach gardner2006 eingefügt (thematische Nähe: EMA-Kapitel)"
metrics:
  duration: "209s"
  completed_date: "2026-07-17"
  tasks_completed: 3
  files_modified: 5
---

# Phase 33 Plan 02: Argumentationskorrekturen LITV-01/02/03 — Summary

**One-liner:** CLIP-Argumentationssprung gestrichen, EMA-Beleg auf Dewan-2016-Quelle umgestellt, drei fehlerhafte barquero-Zitate bereinigt — alle sechs Verifikationskriterien erfüllt.

## Was wurde gebaut

Drei Argumentationskorrekturen in vier Kapiteldateien und sources.bib:

1. **LITV-01 (fundamentals-1.typ):** CLIP-Satz vollständig entfernt. Die Gaze-Belege `@yin2024clipgaze` und `@yin2024lggaze` wurden an den vorangehenden VLM-Satz umgehängt, da `@yin2024lggaze` ausschließlich in diesem Satz vorkam und ohne Umhängung verwaist wäre. `@yin2024clipgaze` war zudem noch in methodology.typ:50 zitiert. Der Absatz liest sich jetzt flüssig: VLM-Satz (mit Gaze-Belegen) → Kiosk-Nutzwert-Satz.

2. **LITV-02 + B4 (practical-1.typ + sources.bib):** Neuer BibTeX-Eintrag `dewan2016adaptiveappearance` (Dewan et al. 2016, Pattern Recognition, Vol. 49, S. 129–151, DOI verifiziert) eingefügt. In practical-1.typ Z. 122: `@barquero2020longtermtracking[S.~4--5]` → `@dewan2016adaptiveappearance[S.~129--131]`. `@gardner2006exponentialsmoothing[§2--3]` bleibt unverändert.

3. **LITV-03 B6 (discussion.typ Z. 53):** `@barquero2020longtermtracking[S.~3--4]` durch `(eigene Beobachtung)` ersetzt. Variante (a) gewählt: Zahlenwerte ~0,80/~0,15 bleiben erhalten, da sie aus dem Entwicklungsbetrieb stammen. Der Satz ist damit korrekt deklariert.

4. **LITV-03 B7 (conclusion.typ Z. 27):** `@barquero2020longtermtracking[S.~4--5]` ersatzlos gestrichen. Der Ausblick-Satz endet mit Punkt ohne hängendes Leerzeichen.

## Ergebnis-Inventar nach Ausführung

| Prüfung | Erwartet | Tatsächlich |
|---------|----------|-------------|
| radford in fundamentals-1.typ | 0 | 0 |
| radford in fundamentals-2.typ | 1 | 1 |
| dewan in sources.bib | 1 | 1 |
| dewan in practical-1.typ | 1 | 1 |
| barquero-Inline-Zitate in chapters/ | 2 | 2 |
| barquero-Eintrag in sources.bib | 1 | 1 |

Verbleibende barquero-Zitate: methodology.typ:137 (B5, Tracking-by-Detection-Szenario) und practical-1.typ:81 (B3, head-pose-abhängige Face-Quality).

## Commits

| Task | Commit | Beschreibung |
|------|--------|-------------|
| Task 1: LITV-01 | `3ee2955` | CLIP-Satz streichen, Gaze-Belege umhängen |
| Task 2: LITV-02/B4 | `bf683c3` | Dewan-Eintrag anlegen, EMA-Beleg umstellen |
| Task 3: LITV-03 B6+B7 | `8a73864` | B6 als eigene Beobachtung, B7 streichen |

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 2 - Vollständigkeit] @yin2024lggaze würde verwaisen**
- **Found during:** Task 1 — grep-Prüfung vor dem Streichen
- **Issue:** `@yin2024lggaze` kam ausschließlich in fundamentals-1.typ:19 vor; nach dem Streichen des CLIP-Satzes wäre der Key verwaist gewesen
- **Fix:** Variante aus Plan-Task-1-Action gewählt — Gaze-Belege an den vorangehenden VLM-Satz umgehängt (nicht wegfallen lassen)
- **Files modified:** T2000_Part1/chapters/fundamentals-1.typ
- **Commit:** 3ee2955

Alle anderen Änderungen plankonform.

## Known Stubs

Keine. Alle Änderungen sind vollständige Korrekturen ohne Platzhalter.

## Threat Surface Scan

Keine neuen Netzwerkendpunkte, Auth-Pfade oder sicherheitsrelevante Oberflächen eingeführt. Reine Textarbeit an .typ-Dateien und sources.bib. T-33-03 (dewan-Eintrag korrekt aus verifiziertem DOI übernommen, barquero bleibt in sources.bib) und T-33-04 (nur die im Audit benannten Zeilen geändert, 2 korrekte barquero-Stellen unangetastet) vollständig mitigiert.

## Self-Check: PASSED

- fundamentals-1.typ: radford=0, yin-Zitate=1 (umgehängt) — FOUND
- fundamentals-2.typ: radford=1 — FOUND
- sources.bib: dewan=1, barquero=1 — FOUND
- practical-1.typ: dewan=1, barquero=1 (Z. 81) — FOUND
- discussion.typ: barquero=0 — FOUND
- conclusion.typ: barquero=0 — FOUND
- Commits 3ee2955, bf683c3, 8a73864 — FOUND
