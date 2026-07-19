---
phase: 42-selbstst-ndigkeit
plan: "02"
subsystem: text-revision
tags: [typst, selb-01, eigenentscheidung, kap3, kap5, deepface, insightface, ema-alpha]

requires:
  - phase: 42-selbstst-ndigkeit/42-01
    provides: "42-AUDIT.md mit verifizierten Einfügepositionen (Z. 163 / Z. 40 / Z. 117)"

provides:
  - "Kap. 3.3 (fundamentals-2.typ): Absatz mit DeepFace als Ausgangspunkt der Evaluation, 92 %/300 ms-Problem, Entscheidung zu InsightFace buffalo_l"
  - "Kap. 5.1 (practical-1.typ): Indikativ-Ergänzungssätze zur eigenen Kalibrierungsentscheidung (0,65 → 0,52)"
  - "Kap. 5.3 (practical-1.typ): Absatz mit alpha=0,5 als Ausgangshypothese, Stabilitätsproblem, Entscheidung für alpha=0,2"

affects:
  - 42-03-PLAN (Finalcheck und Abschluss Phase 42)

tech-stack:
  added: []
  patterns: []

key-files:
  created: []
  modified:
    - "T2000_Part1/chapters/fundamentals-2.typ"
    - "T2000_Part1/chapters/practical-1.typ"

key-decisions:
  - "Kap. 3.3: Neuer Absatz nach Z. 163 (nach Alternativen-Absatz, vor ONNX-Absatz) — DeepFace als Ausgangspunkt der Evaluation benannt"
  - "Kap. 5.1: Zwei Ergänzungssätze am Ende des bestehenden Kalibrierungsabsatzes — kein eigenständiger Absatz, da Drei-Stufen-Struktur bereits vorhanden war"
  - "Kap. 5.3: Neuer eigenständiger Absatz nach Formelzeile — alpha=0,5 als 'nahe liegende Ausgangshypothese' geframt, nicht als dokumentierter A/B-Test"

patterns-established:
  - "SELB-01-Muster konsequent angewendet: naive Lösung → beobachtetes Problem → eigene Erkenntnis → Entscheidung"

requirements-completed:
  - SELB-01

duration: 5min
completed: 2026-07-19
---

# Phase 42 Plan 02: Selbstständigkeit — Eigenentscheidungsnarrative Summary

**SELB-01-Muster an allen drei Zielstellen eingefügt: DeepFace→InsightFace (Kap. 3.3), Schwellenwert-Kalibrierung 0,65→0,52 (Kap. 5.1), EMA-alpha 0,5→0,2 (Kap. 5.3) — keine bestehenden Sätze gelöscht, Compile-Baseline unveränderlich (1 Fehler)**

## Performance

- **Duration:** 5 min
- **Started:** 2026-07-19T14:10:00Z
- **Completed:** 2026-07-19T14:15:00Z
- **Tasks:** 3
- **Files modified:** 2

## Accomplishments

- Kap. 3.3 (fundamentals-2.typ): Eigenständiger Absatz nach dem Alternativen-Absatz eingefügt — benennt DeepFace als Ausgangspunkt der Evaluation, beschreibt das 92 %/300 ms-Problem im Entwicklungsbetrieb (Indikativ) und formuliert die eigene Entscheidung zu InsightFace buffalo_l als direkte Konsequenz
- Kap. 5.1 (practical-1.typ): Zwei Indikativ-Sätze am Ende des Kalibrierungsabsatzes ergänzt — tatsächlich beobachtete Fehlklassifikation mit Ausgangswert 0,65 explizit benannt; eigene Kalibrierungsentscheidung als solche formuliert (ersetzt nicht den bestehenden Konjunktiv, sondern ergänzt ihn)
- Kap. 5.3 (practical-1.typ): Neuer Absatz nach der EMA-Formelzeile — alpha=0,5 als nahe liegende Ausgangshypothese eingeführt, Stabilitätsproblem (atypische Frames) im Indikativ beschrieben, Entscheidung für alpha=0,2 kausal verknüpft

## Task Commits

1. **Task 1: Kap. 3.3 Eigenentscheidungsabsatz** - Teil von `303eae1` (feat)
2. **Task 2: Kap. 5.1 Indikativ-Satz + Kap. 5.3 alpha=0,5-Absatz** - Teil von `303eae1` (feat)
3. **Task 3: Typst-Compile-Test** - `303eae1` (feat) — Compile bestätigt: 1 Fehler (Baseline, unverändert)

## Files Created/Modified

- `T2000_Part1/chapters/fundamentals-2.typ` — Kap. 3.3: neuer Absatz nach Z. 163 (Eigenentscheidungsnarrative DeepFace→InsightFace)
- `T2000_Part1/chapters/practical-1.typ` — Kap. 5.1: Indikativ-Ergänzung am Ende des Kalibrierungsabsatzes; Kap. 5.3: neuer Absatz nach EMA-Formelzeile (alpha=0,5→0,2)

## Decisions Made

- Kap. 3.3: Position nach dem Alternativen-Absatz (Z. 163) gewählt, nicht am Abschnittsbeginn — so bleiben die bestehenden Quellenangaben (@deng2019arcface etc.) unberührt und der neue Absatz folgt logisch auf den Vergleich.
- Kap. 5.1: Ergänzungssätze am Ende des bestehenden Absatzes (kein eigener Absatz) — die Drei-Stufen-Struktur war bereits weitgehend vorhanden; der Konjunktiv ("hätte") bleibt stehen und wird durch Indikativ-Beobachtung ergänzt, nicht ersetzt.
- Kap. 5.3: alpha=0,5 als "nahe liegende Ausgangshypothese" formuliert (nicht als dokumentierten A/B-Test), gemäß Pitfall 3 aus RESEARCH.md — akademisch korrekt, da kein Testbeleg existiert.

## Deviations from Plan

None — Plan wurde exakt als geschrieben ausgeführt. Alle drei Einfügepositionen aus 42-AUDIT.md konnten direkt verwendet werden.

## Issues Encountered

None. Compile-Baseline (1 Fehler: pagebreaks inside containers in template.typ Z. 45) ist unveränderlich — kein neuer Fehler durch die Textänderungen.

## Threat Mitigation

- T-42-03 (Tampering Messzahlen): Zahlen 92, 300, 99,83, 80 ms in fundamentals-2.typ via grep verifiziert — alle unveränderlich vorhanden.
- T-42-04 (Tampering Formelzeile): `bold(e)_"neu"` grep-count = 1, unverändert vorhanden.
- T-42-05 (Tampering Quellenverweise): Keine neuen Verweise eingefügt; bestehende (@deng2019arcface etc.) unberührt.

## Next Phase Readiness

- Alle drei SELB-01-Stellen sind mit vollständiger Eigenentscheidungsnarrative versehen
- Keine Blocker
- Wave 3 (Finalcheck / 42-03) kann direkt die drei Stellen verifizieren und Phase 42 abschließen

---
*Phase: 42-selbstst-ndigkeit*
*Completed: 2026-07-19*
