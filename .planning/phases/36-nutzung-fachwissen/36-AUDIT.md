# Phase 36: Nutzung Fachwissen — Audit

**Erstellt:** 2026-07-18
**Zweck:** Präzise Anker-Strings und Zeilennummern für Wave-2-Einschübe (36-02-PLAN.md)

---

## WISS-01: ArcFace/CosFace — Geometrischer Unterschied

**Datei:** `T2000_Part1/chapters/fundamentals-1.typ`

**Anchor-Zeile:** 45

**Anchor-String (exakt, letzter Satz des ArcFace-Absatzes in Kap. 2.2.2):**
```
beide Ansätze erzielen denselben Effekt, unterscheiden sich jedoch in der geometrischen Art, wie die Marge wirkt.
```

**Vollständige Anker-Passage (Zeile 45, zur eindeutigen Identifikation):**
```
Eine alternative Formulierung verwendet eine kosinusbasierte statt einer angularen Marge @wang2018cosface[S.~1--2]; beide Ansätze erzielen denselben Effekt, unterscheiden sich jedoch in der geometrischen Art, wie die Marge wirkt.
```

**Einfügeposition für Wave 2:** NACH diesem Satz, noch innerhalb der `=== Metrisches Lernen: Angular Margin Loss`-Sektion, direkt vor der `== Sitzungsübergreifendes Gedächtnis`-Überschrift (Zeile 47).

**Bestätigung: Keine bestehende geometrische Erklärung vorhanden:**
- `grep "geodätisch"` → kein Treffer (exit 1) — das Wort erscheint nicht in der Datei
- Der Anchor-Satz (Zeile 45) ist der letzte Satz des Abschnitts vor der nächsten `==`-Überschrift (Zeile 47)
- Keine Texte zu `cos(theta + m)`, `cos(theta) - m`, `geodätisch`, `Einheitshypersphäre` oder `nonlinear` im Abschnitt

**BibTeX-Einträge:** Beide vorhanden:
- `deng2019arcface` — Zeile 201 in sources.bib
- `wang2018cosface` — Zeile 211 in sources.bib

---

## WISS-02: RAG-Modell MTEB-Benchmark-Begründung

**Datei (Typst):** `T2000_Part1/chapters/practical-2.typ`

**Anchor-Zeile:** 71

**Anchor-String (exakt, Ende des Modell-Satzes in Kap. 6.2):**
```
und ist für semantische Ähnlichkeitssuche in kompakten Einbettungsräumen optimiert.
```

**Vollständige Anker-Passage (Zeile 71, zur eindeutigen Identifikation):**
```
Das Modell basiert auf der Sentence-BERT-Architektur @reimers2019sbert[S.~3984--3985] und ist für semantische Ähnlichkeitssuche in kompakten Einbettungsräumen optimiert.
```

**Einfügeposition für Wave 2:** NACH diesem Satz (direkt nach dem Punkt), in Zeile 71 (der Satz läuft über eine Zeile und endet mit "optimiert.").

**Bestätigung: muennighoff2023mteb fehlt vollständig:**
- `grep "muennighoff2023mteb" sources.bib practical-2.typ` → kein Treffer (exit 1)
- Der MTEB-Score (56,53) und das Wort "MTEB" erscheinen nicht im Fließtext von practical-2.typ
- Der BibTeX-Eintrag muss in Wave 2 neu angelegt werden

**Einfügeposition für neuen BibTeX-Eintrag in sources.bib:**
- `reimers2019sbert`-Eintrag: Zeilen 291–300 in sources.bib
- Schließende `}` des `reimers2019sbert`-Eintrags: **Zeile 300**
- Der neue `muennighoff2023mteb`-Eintrag wird NACH Zeile 300 eingefügt (direkt nach der schließenden `}`)

---

## WISS-03: EMA-Literaturkontext — Kap. 5.3

**Datei:** `T2000_Part1/chapters/practical-1.typ`

**Anchor-Zeile (EMA-Satz):** 122

**Anchor-String (exakter Beginn des EMA-Satzes, nach dem der neue Text VOR ihm eingefügt wird):**
```
Dieses Exponential Weighted Moving Average-Verfahren @gardner2006exponentialsmoothing[§2--3]
```

**Anchor-String (vorhergehender Satz, nach dem Wave 2 einfügt):**
```
Der Normierungsschritt stellt die L2-Norm wieder her (vgl. Kap.~5.1).
```
(Zeile 121)

**Einfügeposition für Wave 2:** ZWISCHEN Zeile 121 und Zeile 122 — d. h. der neue Literaturkontext-Absatz wird nach "Der Normierungsschritt stellt die L2-Norm wieder her (vgl. Kap.~5.1)." und VOR "Dieses Exponential Weighted Moving Average-Verfahren…" eingefügt.

**Bestätigung: Keine bestehende Dilemma-/veraltet-Prosa vorhanden:**
- `grep "veraltet\|Dilemma" practical-1.typ` → kein Treffer (exit 1)
- Das Wort "Ausreißer" ist nur im EMA-Kalibrierungstext (Zeile 120) präsent, NICHT als Literaturkontext
- Kein Text über "statisches Template veraltet", "biometrisches Dilemma" oder "Adaptive Erscheinungsmodelle" vorhanden

**BibTeX-Einträge:** Beide bereits vorhanden:
- `dewan2016adaptiveappearance` — Zeile 444 in sources.bib
- `gardner2006exponentialsmoothing` — Zeile 432 in sources.bib

---

## Zusammenfassung für Wave 2

| WISS | Datei | Einfüge-Zeile | Typ | BibTeX-Aktion |
|------|-------|---------------|-----|---------------|
| WISS-01 | fundamentals-1.typ | nach Zeile 45 | Append nach Anchor-Satz | Keine (beide vorhanden) |
| WISS-02 | practical-2.typ | nach Zeile 71 | Append nach Anchor-Satz | NEU: muennighoff2023mteb nach sources.bib Zeile 300 |
| WISS-03 | practical-1.typ | zwischen Z. 121 und Z. 122 | Vor Anchor-Satz einfügen | Keine (beide vorhanden) |

**Alle drei Gaps bestätigt.** Kein bestehender Text deckt die Lücken ab. Wave 2 kann sofort mit den Einschüben beginnen.
