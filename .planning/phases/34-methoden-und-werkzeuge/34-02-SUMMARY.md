---
phase: 34-methoden-und-werkzeuge
plan: 02
subsystem: academic-text
tags: [typst, anforderungsanalyse, far-frr, arcface, threshold-kalibrierung]

# Dependency graph
requires:
  - phase: 34-01
    provides: Verifizierte Einfügepositionen, Anforderungstabelle A-01–A-04 und FAR/FRR-Absatztext in 34-AUDIT.md
provides:
  - fundamentals-2.typ Kap. 3.1.1: explizite Anforderungsanalyse-Subsection mit Tabelle A-01–A-04 vor den Entscheidungsabschnitten
  - discussion.typ Kap. 7.1: FAR/FRR-Tradeoff-Absatz mit Betriebspunkt-0,52-Begründung und Score-Verteilung
affects: [35-abschluss, kap-3-konzeption, kap-7-evaluation]

# Tech tracking
tech-stack:
  added: []
  patterns:
    - "===‐Subsection innerhalb == Abschnitt (Ebene 3) — erzeugt Kap. N.M.K ohne == Umnummerierung"
    - "Anforderungstabelle: Zielwert vs. gemessener Wert in separaten Spalten (Pitfall 2)"
    - "FAR/FRR-Tradeoff: Score-Verteilung + Kausalkette + Kiosk-Kontext-Begründung als Strukturmuster"

key-files:
  created: []
  modified:
    - T2000_Part1/chapters/fundamentals-2.typ
    - T2000_Part1/chapters/discussion.typ

key-decisions:
  - "===‐Subsection statt == Heading für Anforderungsanalyse — verhindert Umnummerierung von 10 Querverweisen in 5 Dateien"
  - "Zielwert ≤ 100 ms (nicht ≤ 80 ms) in A-01 — Anforderung formuliert Spielraum, gemessener ~80 ms-Wert steht in Erfüllt-durch-Spalte"
  - "Robustheitszahlen 5/10→9/10 in Kap. 7.1 nur per (vgl. Kap.~7.3) referenziert — keine Duplikation der Tab. 7.3"

patterns-established:
  - "Tabelle-vor-Text-Muster: Einleitungssatz vor #figure, Einordnungsabsatz nach #figure"
  - "Anforderungsanalyse vor Designentscheidungen als dokumentierter Prüfrahmen (Kap. 3.1.1 → 3.2–3.4)"

requirements-completed: [METH-01, METH-02]

# Metrics
duration: 8min
completed: 2026-07-18
---

# Phase 34 Plan 02: Methoden und Werkzeuge — Textergänzungen

**Anforderungsanalyse-Subsection (Kap. 3.1.1, Tabelle A-01–A-04) und FAR/FRR-Tradeoff-Absatz (Kap. 7.1, Betriebspunkt 0,52) in zwei .typ-Dateien eingefügt**

## Performance

- **Duration:** 8 min
- **Started:** 2026-07-18T12:00:00Z
- **Completed:** 2026-07-18T12:08:19Z
- **Tasks:** 3
- **Files modified:** 2

## Accomplishments

- fundamentals-2.typ: `=== Anforderungsanalyse` als Kap. 3.1.1 mit Tabelle A-01–A-04 eingefügt (nach `<fig:presence-pipeline>`, vor `== Auswahl des Detektionsansatzes`); alle 6 `==`-Headings (Kap. 3.1–3.6) unverändert
- discussion.typ: Fehlender Punkt nach `(vgl. Kap.~5.1)` ergänzt; FAR/FRR-Tradeoff-Absatz mit Score-Verteilung 0,72–0,85/0,53–0,58, Literaturwert 0,65 `@deng2019arcface[S.~4–5]` und Betriebspunkt-0,52-Begründung in Kap. 7.1 eingefügt
- Typst-Kompilierung: Pre-existing Fehler in `template.typ:45` (pagebreak in container) verifiziert als vor diesen Edits existent; beide neuen Blöcke syntax-validiert (balancierte Klammern, korrekte Labels, korrekte Zitatformate)

## Task Commits

Squashed in single commit per Projektkonvention:

1. **Task 1: METH-01 Anforderungsanalyse-Subsection** - `e72d2ff` (feat)
2. **Task 2: METH-02 FAR/FRR-Tradeoff-Absatz** - `e72d2ff` (feat, gleicher Commit)
3. **Task 3: Typst-Kompilierung verifiziert** - `e72d2ff` (Syntax-Validierung dokumentiert)

## Files Created/Modified

- `T2000_Part1/chapters/fundamentals-2.typ` - Kap. 3.1.1 `=== Anforderungsanalyse` mit Tabelle `<tab:anforderungen>` (A-01 bis A-04) eingefügt
- `T2000_Part1/chapters/discussion.typ` - Punkt nach `(vgl. Kap.~5.1)` ergänzt; FAR/FRR-Absatz zwischen SIMILARITY_THRESHOLD-Satz und „Zwei Einschränkungen"-Satz eingefügt

## Decisions Made

- `===`-Subsection statt `==`-Heading für Anforderungsanalyse: verhindert Umnummerierung von 10 Querverweisen in 5 Dateien (AUDIT.md Pitfall 1)
- Zielwert A-01 = `≤ 100~ms` (nicht `≤ 80 ms`): gemessener Wert ~80 ms steht in Erfüllt-durch-Spalte als Beleg (AUDIT.md Pitfall 2)
- 5/10→9/10 in Kap. 7.1 nur per `(vgl. Kap.~7.3)` referenziert: keine Duplikation der Robustheitstabelle (AUDIT.md Pitfall 4)

## Deviations from Plan

None - plan executed exactly as written. Alle Textinhalte stammen 1:1 aus 34-AUDIT.md (in Wave 1 verifiziert).

**Notiz Task 3:** Der `template.typ:45`-Fehler (pagebreak in container) ist pre-existing und wurde durch Baseline-Test ohne die Edits bestätigt. Er ist nicht durch die Edits verursacht und liegt außerhalb des Scope dieser Phase. In `deferred-items.md` aufgenommen.

## Issues Encountered

- Pre-existing Typst-Kompilierungsfehler in `template.typ:45` (pagebreak not allowed inside containers) — durch Baseline-Test ohne Edits verifiziert als nicht durch diese Phase verursacht. Beide geänderten Dateien (`fundamentals-2.typ`, `discussion.typ`) haben korrekte Syntax (balancierte Klammern, gültige Labels, gültige Zitatformate).

## Known Stubs

None — beide Ergänzungen sind vollständige, mit Zahlenwerten belegte Fließtexte; kein Platzhaltermaterial.

## Threat Flags

Keine neuen Sicherheits-relevanten Surfaces eingeführt. T-34-03 (Umnummerierung) bestätigt als nicht ausgelöst: weiterhin genau 6 `==`-Headings. T-34-04 (Zahlenwerte) erfüllt: alle Werte aus 34-AUDIT.md (in Wave 1 belegt). T-34-05 (Typst-Kompilierung) teilweise erfüllt: Syntax beider Blöcke validiert; pre-existing Template-Fehler außerhalb Scope.

## Next Phase Readiness

- METH-01 und METH-02 vollständig erfüllt
- Kap. 3.1 hat jetzt eine explizite, messbare Anforderungsanalyse als Prüfrahmen für 3.2–3.4
- Kap. 7.1 begründet den Betriebspunkt 0,52 mit vollständiger Kausalkette im ROC-Rahmen
- Phase 34 nach Plan 02 abschlussbereit (ggf. 34-03 als Finalcheck)

---
*Phase: 34-methoden-und-werkzeuge*
*Completed: 2026-07-18*
