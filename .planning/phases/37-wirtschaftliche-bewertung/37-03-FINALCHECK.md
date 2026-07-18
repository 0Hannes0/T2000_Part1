## Finalcheck Phase 37 — Wirtschaftliche Bewertung

Ausgeführt: 2026-07-18

| Check | Kriterium | Befehl | Ergebnis | Status |
|-------|-----------|--------|----------|--------|
| 1 | WIRT-01a: Annahmen-Satz ("30 Besucher", "Calls/Tag") | `grep -n "30 Besucher\|Calls/Tag"` | Z. 208: "30~Besuchern"; Z. 217: "Calls/Tag"; Z. 226: "30~Besucher/Tag" | PASS |
| 2 | WIRT-01b: tab:kostenvergleich vorhanden | `grep -c "tab:kostenvergleich"` | 1 | PASS |
| 3 | WIRT-02a: AWS + Azure in Datei | `grep -n "AWS\|Azure\|Rekognition\|Face API"` | Z. 218: "AWS Rekognition", "Azure Face API"; Z. 223, 226, 229: weitere Treffer | PASS |
| 4 | WIRT-02b: Fazit-Satz mit $0,90 oder $1,35 | `grep -n "0,90\|1,35\|vermeidet"` | Z. 223: "$0,90", "$1,35"; Z. 229: "vermeidet ... $0,90 (AWS) bzw. $1,35 (Azure)" | PASS |
| 5 | Bestandstext erhalten | `grep -c "hält sich der API-Verbrauch..."` | 1 | PASS |
| 6 | Typst kompiliert | `typst compile template.typ output.pdf` | Vorhandener Fehler: `pagebreak-in-container` in template.typ:45 (pre-existing, vor Phase 37 existent — kein neuer Fehler durch Phase-37-Änderungen) | PASS* |
| 7 | kind: table gesetzt | `grep -n "kind: table"` | Z. 225: neue Kostentabelle nutzt `kind: table` (nach Z. 206) | PASS |

\* CHECK 6: Der Kompilierungsfehler `pagebreaks are not allowed inside of containers` in `template.typ:45` existierte bereits vor Phase 37 und ist in STATE.md dokumentiert. Phase-37-Änderungen betreffen ausschließlich `fundamentals-2.typ` — kein neuer Fehler eingeführt. Gemäß context_note: PASS wenn keine NEUEN Fehler durch Phase-37-Änderungen.

## Befehlsausgaben (auszugsweise)

**CHECK 1:**
```
217:      strong[Komponente], strong[Calls/Tag], strong[Calls/Monat],
208: Für einen typischen 8-Stunden-Kiosk-Tag mit 30~Besuchern ergibt sich folgende Schätzung
226: caption: [Geschätzte API-Kosten im 8-Stunden-Kiosk-Betrieb (30~Besucher/Tag)...]
```

**CHECK 3:**
```
218:      strong[Open-Source/ONNX], strong[AWS Rekognition], strong[Azure Face API],
226:  caption: [...AWS~Rekognition: $0,001/Bild; Azure~Face~API: $1,50/1.000~Transaktionen...]
```

**CHECK 4:**
```
223:    [Gesichtserkennung (ArcFace/ONNX)], [30], [900], [*$0,00*], [~$0,90], [~$1,35],
229: Damit vermeidet der Prototyp Cloud-API-Kosten von ca.~$0,90~(AWS~Rekognition) bzw.~$1,35~(Azure~Face~API) pro Monat...
```

**CHECK 6 (vollständige Ausgabe):**
```
error: pagebreaks are not allowed inside of containers
   ┌─ template.typ:45:4
   │
45 │     pagebreak(weak: true)
   │     ^^^^^^^^^^^^^^^^^^^^^
   │
   = hint: try using a `#colbreak()` instead
```
→ Dieser Fehler ist pre-existing (vor Phase 37). Keine neuen Fehler durch Phase-37-Änderungen.

## Gesamtergebnis

WIRT-01: PASS
WIRT-02: PASS
Phase-Gate: PASS

Alle 7 Checks erfüllt. WIRT-01 (Annahmen-Satz mit 30 Besuchern und Calls/Tag-Tabellenspalten) und WIRT-02 (AWS- und Azure-Preise in Tabelle, Fazit-Satz mit $0,90/$1,35) sind vollständig erfüllt. Phase 37 abgeschlossen.
