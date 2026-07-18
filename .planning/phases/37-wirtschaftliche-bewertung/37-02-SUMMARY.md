---
phase: 37-wirtschaftliche-bewertung
plan: "02"
subsystem: dokumentation
tags: [kap-3-6, kostentabelle, wirt-01, wirt-02, typst]
dependency_graph:
  requires: [37-01]
  provides: [WIRT-01, WIRT-02]
  affects: [T2000_Part1/chapters/fundamentals-2.typ]
tech_stack:
  added: []
  patterns: [typst-figure-table, kind-table, non-breaking-space-tilde]
key_files:
  modified:
    - T2000_Part1/chapters/fundamentals-2.typ
decisions:
  - "6 Spalten statt 5 gewählt (Komponente | Calls/Tag | Calls/Monat | ONNX | AWS | Azure) — alle Vergleichsdimensionen in einer Tabelle sichtbar"
  - "Gemini-Zeilen mit identisch* statt Fußnote-Objekt — kompakter, vermeidet verschachtelte #footnote in caption"
  - "Preishinweis in caption integriert (laut öffentlichem Listenpreis) statt separater Fußnote — kürzer"
  - "Skalierungshinweis (10 Standorte) im Fazit-Satz behalten — stärkt Argumentation ohne Scope-Verletzung"
metrics:
  duration: "8min"
  completed: "2026-07-18"
  tasks: 1
  files: 1
---

# Phase 37 Plan 02: Kap. 3.6 Kostentabelle + Fazit-Satz Summary

**One-liner:** Annahmen-Satz, 6-spaltige AWS/Azure-Kostentabelle (tab:kostenvergleich) und Fazit-Satz mit $0,90/$1,35 Einsparungsangabe in Kap. 3.6 eingefügt — WIRT-01 und WIRT-02 erfüllt.

## Tasks Completed

| Task | Name | Commit | Files |
|------|------|--------|-------|
| 1 | Annahmen-Satz + Kostentabelle + Fazit-Satz einfügen | 6b2213e (submodule) | T2000_Part1/chapters/fundamentals-2.typ |

## What Was Built

Kap. 3.6 (fundamentals-2.typ) wurde nach Z. 206 um drei Blöcke erweitert:

**Block 1 — Annahmen-Satz (D-10):**
Einleitungssatz mit expliziten Annahmen für das 8h-Kiosk-Szenario: 30 Besucher, 1,5 Gaze-Check-Calls/Erkennungsevent, 1 Begrüßungs-Call/ACTIVE-Übergang, 3 Chat-Turns/Interaktion.

**Block 2 — Kostentabelle (`<tab:kostenvergleich>`):**
`#figure(table(...))` mit `kind: table` (nicht `kind: image`), 6 Spalten:
- Komponente | Calls/Tag | Calls/Monat | Open-Source/ONNX | AWS Rekognition | Azure Face API
- Zeilen: Gaze-Check (~45/~1.350, identisch*), Begrüßung (30/900, identisch*), Chat (90/2.700, identisch*), Gesichtserkennung (30/900, $0,00/$0,90/$1,35)
- Caption enthält Preishinweis: AWS $0,001/Bild, Azure $1,50/1.000 Transaktionen (laut öffentlichem Listenpreis)

**Block 3 — Fazit-Satz (D-07, D-09):**
"Damit vermeidet der Prototyp Cloud-API-Kosten von ca.~$0,90~(AWS Rekognition) bzw.~$1,35~(Azure Face API) pro Monat allein für die biometrische Identifikation --- bei zehn Kiosk-Standorten entspräche das $9 bzw.~$13,50 monatlich."

Bestehender Text Z. 200–206 vollständig erhalten (verifiziert per grep auf "hält sich der API-Verbrauch").

## Verification Results

| Check | Result |
|-------|--------|
| grep "AWS\|Azure\|Rekognition\|Face API\|kostenvergleich" | PASS — Z. 218, 226, 227, 229 |
| grep -c "tab:kostenvergleich" | PASS — genau 1 Treffer |
| grep "0,90\|1,35\|Calls/Tag\|Calls/Monat" | PASS — Z. 217, 223, 229 |
| grep "hält sich der API-Verbrauch…" (Bestandstext) | PASS — Z. 206 |
| typst compile template.typ | Pre-existing error (pagebreak-in-container template.typ:45) — dokumentiert in STATE.md vor Wave 2; nicht durch diese Änderungen verursacht |

## Deviations from Plan

### Auto-fixed Issues

None.

### Adjustments

**1. 6 Spalten statt 5 (PATTERNS.md Analog 3 nutzte 5)**
- Gefunden: Der Plan sah 5 Spalten vor (Komponente | Calls/Tag | Calls/Monat | ONNX | Cloud-Alternative), aber WIRT-02 verlangt zwei Cloud-Alternativen (AWS + Azure) in getrennten Spalten.
- Fix: 6 Spalten gewählt `(1.5fr, auto, auto, 1fr, 1fr, 1fr)` — alle drei Preisoptionen in einer Zeile direkt vergleichbar.
- Kein Fehler, kein Plan-Verstoß — Plan-Interface spezifiziert explizit beide Spalten.

**2. Preishinweis in caption statt separater Fußnote**
- Plan erwähnte `#footnote[...]` als Option für Gemini-Erklärung.
- Fix: Hinweis (*-Markierung + Preisangaben) in die caption integriert — vermeidet Fußnoten-Syntax innerhalb von Tabellenzellen (Typst-Kompatibilität).

## Known Stubs

None. Alle Werte sind konkret und aus RESEARCH.md §Kostenrechnung übernommen.

## Threat Flags

None. Reine Dokumentationsphase ohne Code, Credentials oder sicherheitsrelevante Komponenten.

## Self-Check: PASSED

- [x] T2000_Part1/chapters/fundamentals-2.typ — modifiziert und committed (6b2213e in submodule)
- [x] Commit 6b2213e existiert in T2000_Part1 submodule
- [x] grep "tab:kostenvergleich" liefert genau 1 Treffer
- [x] grep "0,90\|1,35" liefert Treffer in Fazit-Satz (Z. 229)
- [x] Bestandstext Z. 206 erhalten
- [x] Typst-Kompilierungsfehler ist pre-existing (template.typ:45, nicht fundamentals-2.typ)
