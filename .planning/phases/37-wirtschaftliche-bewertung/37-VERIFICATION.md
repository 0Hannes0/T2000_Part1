---
phase: 37-wirtschaftliche-bewertung
verified: 2026-07-18T17:00:00Z
status: passed
score: 7/7 must-haves verified
overrides_applied: 0
---

# Phase 37: Wirtschaftliche Bewertung — Verification Report

**Phase Goal:** Kap. 3.6 (Wirtschaftliche Bewertung) um konkrete Kostenschätzung und Cloud-Alternativvergleich ergänzen — WIRT-01 und WIRT-02 erfüllen.
**Verified:** 2026-07-18
**Status:** PASSED
**Re-verification:** No — initial verification

---

## Goal Achievement

### Observable Truths

| #  | Truth | Status | Evidence |
|----|-------|--------|----------|
| 1  | Annahmen-Satz mit 30 Besuchern und Call-Aufschlüsselung vorhanden | VERIFIED | Z. 208: "Für einen typischen 8-Stunden-Kiosk-Tag mit 30~Besuchern ergibt sich folgende Schätzung (Annahmen: 1,5~Gaze-Check-Calls pro Erkennungsevent, 1~Begrüßungs-Call pro ACTIVE-Übergang, 3~Chat-Turns pro Interaktion):" |
| 2  | Kostentabelle mit Spalten Calls/Tag und Calls/Monat vorhanden | VERIFIED | Z. 217: `strong[Calls/Tag], strong[Calls/Monat]` in table.header; Z. 212: `columns: (1.5fr, auto, auto, 1fr, 1fr, 1fr)` |
| 3  | Tabelle zeigt AWS Rekognition und Azure Face API als Spalten | VERIFIED | Z. 218: `strong[AWS Rekognition], strong[Azure Face API]` in table.header |
| 4  | Gesichtserkennung-Zeile zeigt $0,00 (ONNX) vs. ~$0,90 (AWS) vs. ~$1,35 (Azure) | VERIFIED | Z. 223: `[*\$0,00*], [~\$0,90], [~\$1,35]` in Tabellenzeile Gesichtserkennung (ArcFace/ONNX) |
| 5  | Fazit-Satz benennt $0,90 (AWS) und $1,35 (Azure) explizit als Einsparung | VERIFIED | Z. 229: "Damit vermeidet der Prototyp Cloud-API-Kosten von ca.~\$0,90~(AWS~Rekognition) bzw.~\$1,35~(Azure~Face~API) pro Monat allein für die biometrische Identifikation --- bei zehn Kiosk-Standorten entspräche das \$9 bzw.~\$13,50 monatlich." |
| 6  | Bestehender Text Z. 200–206 ist vollständig erhalten | VERIFIED | Z. 206 in fundamentals-2.typ enthält unverändert: "hält sich der API-Verbrauch auch bei dauerhaftem Kiosk-Betrieb in engen Grenzen" — grep-Treffer bestätigt |
| 7  | tab:kostenvergleich Label und kind: table korrekt gesetzt | VERIFIED | Z. 225: `kind: table`, Z. 227: `) <tab:kostenvergleich>` — genau 1 Treffer für Label |

**Score:** 7/7 truths verified

---

### Required Artifacts

| Artifact | Expected | Status | Details |
|----------|----------|--------|---------|
| `T2000_Part1/chapters/fundamentals-2.typ` | Erweiterter Kap.-3.6-Text mit Annahmen-Satz, Kostentabelle, Fazit-Satz ab Z. 208 | VERIFIED | Datei hat 229 Zeilen (vorher 206); neue Blöcke Z. 208–229 direkt verifiziert |
| `.planning/phases/37-wirtschaftliche-bewertung/37-01-AUDIT.md` | Bestandsaufnahme mit Zeilenangaben und fehlenden Elementen | VERIFIED | Datei existiert; enthält Abschnitt "Fehlende Elemente" mit 3 Einträgen; Einfügeposition Z. 206 angegeben |
| `.planning/phases/37-wirtschaftliche-bewertung/37-03-FINALCHECK.md` | Verifikationsbericht mit PASS/FAIL-Status für WIRT-01 und WIRT-02 | VERIFIED | Datei existiert; enthält 7-Check-Tabelle; WIRT-01: PASS, WIRT-02: PASS, Phase-Gate: PASS |

---

### Key Link Verification

| From | To | Via | Status | Details |
|------|----|-----|--------|---------|
| `fundamentals-2.typ` (Kostentabelle) | Kapitel 3.6 im Typst-Dokument | `#include "fundamentals-2.typ"` in main.typ | VERIFIED | main.typ Z. 3 inkludiert fundamentals-2.typ direkt — Tabelle und Fazit-Satz werden ins Dokument eingebunden |
| `37-01-AUDIT.md` | `fundamentals-2.typ` | Zeilenangabe "nach Z. 206" | VERIFIED | AUDIT.md dokumentiert Einfügeposition Z. 206; Wave 2 hat nach Z. 206 eingefügt (Z. 208 ist erster neuer Inhalt) |
| `37-03-FINALCHECK.md` | `fundamentals-2.typ` | grep-Checks und Kompilierungsnachweis mit "PASS" | VERIFIED | FINALCHECK enthält Befundausgaben aus tatsächlichem grep-Lauf (Zeilenangaben Z. 208, 217, 218, 223, 226, 229) |

---

### Data-Flow Trace (Level 4)

Nicht anwendbar — Phase produziert Typst-Dokumenttext, kein dynamisches Rendering. Alle eingetragenen Werte sind aus RESEARCH.md §Kostenrechnung übernommene Literalwerte (Kostenzahlen, Call-Raten). Datenfluss ist statisch-dokumentarisch, kein API/DB-Render-Muster.

---

### Behavioral Spot-Checks

| Behavior | Command | Result | Status |
|----------|---------|--------|--------|
| "30 Besucher" im Annahmen-Satz | `grep -n "30.*Besucher"` fundamentals-2.typ | Z. 208, Z. 226 | PASS |
| `tab:kostenvergleich` genau 1x | `grep -c "tab:kostenvergleich"` fundamentals-2.typ | 1 | PASS |
| AWS + Azure als Spaltenköpfe | `grep -n "AWS Rekognition\|Azure Face API"` fundamentals-2.typ | Z. 218, 226, 229 | PASS |
| $0,90 und $1,35 in Fazit-Satz | `grep -n "0,90\|1,35"` fundamentals-2.typ | Z. 223, 229 | PASS |
| Bestandstext Z. 206 erhalten | `grep -c "hält sich der API-Verbrauch"` fundamentals-2.typ | 1 | PASS |
| `kind: table` gesetzt | `grep -n "kind: table"` fundamentals-2.typ | Z. 89, 119, 153, 182, 225 (Z. 225 = neue Tabelle) | PASS |
| Datei hat neuen Inhalt | `wc -l` fundamentals-2.typ | 229 Zeilen (vorher 206) | PASS |

**Typst-Kompilierung:** Ein pre-existing Fehler `pagebreaks are not allowed inside of containers` in `template.typ:45` (nicht fundamentals-2.typ) existiert. Dieser Fehler ist in STATE.md dokumentiert ("Phase ?: Typst pagebreak-in-container Fehler existierte vor Wave 2") und wurde durch Phase 37 weder eingeführt noch verändert. Phase-37-Änderungen betreffen ausschließlich fundamentals-2.typ. Dieser Befund ist kein Blocker für Phase 37.

---

### Probe Execution

Keine Probe-Skripte deklariert. Keine Probe-Dateien unter `scripts/*/tests/probe-*.sh` gefunden. SKIPPED.

---

### Requirements Coverage

| Requirement | Source Plan | Description | Status | Evidence |
|-------------|-------------|-------------|--------|----------|
| WIRT-01 | 37-01, 37-02, 37-03 | Kap. 3.6 um konkrete Kostenschätzungen erweitert: Gemini-API-Calls pro 8-Stunden-Kiosk-Tag (Gaze-Checks + Begrüßungen + Chats) und Monatskosten | SATISFIED | Z. 208 (Annahmen-Satz mit 1,5/1/3 Call-Typen); Z. 217 (Calls/Tag + Calls/Monat Spalten); Z. 220–223 (Zeilenwerte mit ~45/30/90/30 Calls/Tag und ~1350/900/2700/900 Calls/Monat) |
| WIRT-02 | 37-01, 37-02, 37-03 | Vergleich mit Cloud-API-Alternative (AWS Rekognition, Azure Face API) — Kosteneinsparung durch Open-Source/ONNX konkret dargestellt | SATISFIED | Z. 218 (AWS Rekognition + Azure Face API als Spalten); Z. 223 ($0,00 vs. ~$0,90 vs. ~$1,35 für Gesichtserkennung); Z. 226 (Listenpreise in Caption); Z. 229 (Fazit-Satz mit expliziter Einsparungsangabe) |

**Hinweis zu ROADMAP Target Files:** ROADMAP.md nennt `T2000_Part1/chapters/kap3.typ` als Target File. Diese Datei existiert nicht im Projekt. Der tatsächliche Kap.-3-Text liegt in `fundamentals-2.typ` (per CONTEXT.md und main.typ Z. 3 `#include "fundamentals-2.typ"`). Alle Pläne und der CONTEXT.md zeigen konsistent fundamentals-2.typ als Zieldatei. Die ROADMAP-Angabe ist ein veralteter Name (kap3.typ = Alias für fundamentals-2.typ). Kein Blocker.

---

### Anti-Patterns Found

| File | Line | Pattern | Severity | Impact |
|------|------|---------|----------|--------|
| `T2000_Part1/chapters/fundamentals-2.typ` | — | Keine TBD/FIXME/XXX/TODO/HACK/PLACEHOLDER gefunden | — | Kein Befund |

Kein Debt-Marker, kein Stub-Code, keine leeren Rückgabewerte. Alle eingetragenen Werte (Kostenzahlen, Call-Raten, Listenpreise) sind aus RESEARCH.md §Kostenrechnung übernommene, konkret belegte Werte.

---

### Human Verification Required

Keine manuellen Verifikationsschritte notwendig. Alle Kriterien sind durch direkte Dateiinspektion und grep-Checks vollständig verifizierbar.

---

## Gaps Summary

Keine Lücken. Alle 7 must-have Truths sind VERIFIED. WIRT-01 und WIRT-02 sind vollständig erfüllt. Phase-Ziel erreicht.

---

_Verified: 2026-07-18T17:00:00Z_
_Verifier: Claude (gsd-verifier)_
