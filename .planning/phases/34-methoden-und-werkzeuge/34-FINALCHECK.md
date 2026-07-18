# Phase 34: Methoden und Werkzeuge — Finalcheck

**Erstellt:** 2026-07-18
**Zweck:** Abschließende Verifikation beider METH-Kriterien gegen den realen Dateizustand.
**Methode:** Grep-basiert — alle Belege reproduzierbar.

---

## Finalcheck METH-01

**Requirement:** Kap. 3 (Konzeption) enthält eine explizite Anforderungsanalyse mit messbaren Anforderungen (Latenz ≤ X ms, Erkennungsrate ≥ Y %, CPU-only), gegen die Designentscheidungen nachvollziehbar geprüft werden können.

**Datei:** `T2000_Part1/chapters/fundamentals-2.typ`

### Checkliste

| # | Kriterium | Status | Grep-Beleg |
|---|-----------|--------|-----------|
| 1 | `=== Anforderungsanalyse`-Subsection existiert in der Datei | ERFÜLLT | `grep -n "=== Anforderungsanalyse" fundamentals-2.typ` → **Zeile 70** |
| 2 | Subsection steht VOR `== Auswahl des Detektionsansatzes` | ERFÜLLT | Zeile 70 (`=== Anforderungsanalyse`) < Zeile 98 (`== Auswahl des Detektionsansatzes`) |
| 3 | Label `<tab:anforderungen>` existiert (Tabelle referenzierbar) | ERFÜLLT | `grep -n "tab:anforderungen" fundamentals-2.typ` → **Zeile 91** |
| 4 | A-01 Latenz-Anforderung: Zielwert **≤ 100~ms** (nicht ≤ 80~ms) | ERFÜLLT | Zeile 84: `[A-01], [Embedding-Latenz auf Standard-CPU], [≤ 100~ms], [InsightFace buffalo\_l via ONNX (~80~ms, vgl. Kap.~3.3)]` |
| 5 | A-01 gemessener Wert ~80~ms steht in der Beleg-Spalte | ERFÜLLT | Zeile 84: `~80~ms` in der Erfüllt-durch-Spalte — korrekte Trennung von Zielwert und Beleg |
| 6 | A-02 Erkennungsrate ≥ 99~% vorhanden | ERFÜLLT | Zeile 85: `[A-02], [Erkennungsgenauigkeit (LFW-Benchmark)], [≥ 99~%], [ArcFace ResNet50: 99,83~% (vgl. Kap.~3.3)]` |
| 7 | A-03 CPU-only Hard Constraint vorhanden | ERFÜLLT | Zeile 86: `[A-03], [Infrastruktur CPU-only, kein GPU-Server], [Hard Constraint], [ONNX Runtime CPUExecutionProvider (vgl. Kap.~3.3)]` |
| 8 | A-04 FAR = 0 vorhanden | ERFÜLLT | Zeile 87: `[A-04], [False-Accept-Rate im Betrieb], [= 0], [Schwellenwert-Kalibrierung 0,52 (vgl. Kap.~5.1, Kap.~7.1)]` |
| 9 | Weiterhin genau **6** `==`-Headings in Kap. 3 (keine Umnummerierung) | ERFÜLLT | `grep -c "^== " fundamentals-2.typ` → **6** (Zeilen 6, 98, 129, 165, 192, 200: entsprechen Kap. 3.1–3.6) |
| 10 | Keine gebrochenen Querverweise in anderen Dateien (Kap.-3.x-Referenzen unverändert) | ERFÜLLT | Querverweise aus 5 Dateien überprüft — alle zeigen auf die ursprünglichen Nummern: `methodology.typ:50` → Kap.~3.2, `practical-1.typ:6` → Kap.~3.3/3.4, `practical-1.typ:44` → Kap.~3.3, `practical-1.typ:111` → Kap.~3.4, `practical-2.typ:73` → Kap.~3.4, `practical-2.typ:94` → Kap.~3.5, `conclusion.typ:25` → Kap.~3.5, `discussion.typ:7` → Kap.~3.3 — keine Verweise gebrochen |

### Detaillierte Grep-Befehle und Ausgaben

```
$ grep -n "=== Anforderungsanalyse" fundamentals-2.typ
70:=== Anforderungsanalyse

$ grep -n "^== Auswahl des Detektionsansatzes" fundamentals-2.typ
98:== Auswahl des Detektionsansatzes

$ grep -c "^== " fundamentals-2.typ
6

$ grep -n "tab:anforderungen" fundamentals-2.typ
91:) <tab:anforderungen>
```

**Ergebnis METH-01: ERFÜLLT** — alle 10 Kriterien bestätigt. Die `===`-Subsection in Kap. 3.1.1 enthält vier messbare Anforderungen A-01 bis A-04 und steht vor den Entscheidungsabschnitten 3.2–3.5. Keine Umnummerierung, keine gebrochenen Querverweise.

---

## Finalcheck METH-02

**Requirement:** Kap. 7.1 (Evaluation) erhält eine ROC/Threshold-Kurven-Diskussion: der Tradeoff zwischen FAR und FRR bei unterschiedlichen Schwellenwerten wird explizit beschrieben und der gewählte Betriebspunkt (0,52) mit diesem Rahmen begründet.

**Datei:** `T2000_Part1/chapters/discussion.typ`

### Checkliste

| # | Kriterium | Status | Grep-Beleg |
|---|-----------|--------|-----------|
| 1 | FAR und FRR (False-Accept-Rate / False-Reject-Rate) werden in Kap. 7.1 explizit genannt | ERFÜLLT | `grep -n "FRR\|FAR" discussion.typ` → Zeile 13: `(niedrige FAR)`, Zeile 14: `(höhere FRR)` |
| 2 | Der Tradeoff (höherer Threshold → niedrigere FAR, aber höhere FRR) ist beschrieben | ERFÜLLT | Zeilen 13–14: „Ein höherer Schwellenwert erhöht die Trennschärfe gegenüber Fremden (niedrige FAR), erhöht aber gleichzeitig das Risiko, legitime Wiederkennungen im Grenzbereich abzulehnen (höhere FRR)." |
| 3 | Score-Verteilung **0,72--0,85** (konstante Bedingungen) explizit genannt | ERFÜLLT | `grep -n "0,72" discussion.typ` → Zeile 11: `Kosinus-Scores von 0,72--0,85` |
| 4 | Score-Verteilung **0,53--0,58** (veränderte Bedingungen) explizit genannt | ERFÜLLT | `grep -n "0,53" discussion.typ` → Zeile 12: `sinken diese auf 0,53--0,58`, Zeile 17: `Grenzfälle (0,53--0,58)` |
| 5 | Betriebspunkt **0,52** im ROC-Rahmen begründet (nicht nur erwähnt) | ERFÜLLT | Zeilen 19–23: „Der kalibrierte Betriebspunkt 0,52 deckt auch diese Grenzfälle ab (9/10 korrekte Ersterkennung) und hält gleichzeitig die FAR bei null" — vollständige Kausalkette: 0,65 zu hoch → 5/10, 0,52 deckt Grenzfälle ab → 9/10, FAR=0 |
| 6 | Verweis auf Kap.~7.3 (statt Duplikat der Robustheitszahlen) | ERFÜLLT | Zeile 19: `(vgl. Kap.~7.3)` — kein Duplikat der Tab. 7.3, nur Querverweis |
| 7 | `@deng2019arcface[S.~4--5]` als Literaturwert 0,65 zitiert | ERFÜLLT | Zeile 15: `Der Literaturwert von 0,65 @deng2019arcface[S.~4--5]` |
| 8 | **Kein neuer BibTeX-Eintrag** für deng2019arcface — bestehender Eintrag genutzt | ERFÜLLT | `grep -c "deng2019arcface" sources.bib` → **1** (ein einziger Eintrag in sources.bib, Zeile 201: `@inproceedings{deng2019arcface,`) |
| 9 | Satz vor dem neuen Absatz endet mit `(vgl. Kap.~5.1).` (Punkt vorhanden) | ERFÜLLT | Zeile 7 endet mit: `(vgl. Kap.~5.1).` — Punkt nach der schließenden Klammer bestätigt |

### Detaillierte Grep-Befehle und Ausgaben

```
$ grep -c "FRR" discussion.typ
3   (Zeilen 13, 14 im neuen Absatz; Zeile 7 enthält "False-Reject-Rate")

$ grep -n "0,72\|0,53" discussion.typ
11:...Kosinus-Scores von 0,72--0,85;...
12:...sinken diese auf 0,53--0,58.
17:...die Grenzfälle (0,53--0,58)...

$ grep -n "deng2019arcface" discussion.typ
7:  @deng2019arcface[S.~3], @schroff2015facenet[S.~1]   (bestehend)
15: Der Literaturwert von 0,65 @deng2019arcface[S.~4--5]

$ grep -c "deng2019arcface" sources.bib
1
```

**Ergebnis METH-02: ERFÜLLT** — alle 9 Kriterien bestätigt. FAR/FRR-Tradeoff vollständig beschrieben, Score-Verteilung 0,72--0,85/0,53--0,58 explizit genannt, Betriebspunkt 0,52 mit vollständiger Kausalkette im ROC-Rahmen begründet, @deng2019arcface zitiert, kein neuer BibTeX-Eintrag, Punkt nach `(vgl. Kap.~5.1)` vorhanden.

---

## Phasenurteil

**Gesamturteil: ABSCHLUSSBEREIT**

| Requirement | Kriterium | Status |
|-------------|-----------|--------|
| METH-01 | Explizite Anforderungsanalyse mit ≥3 messbaren Anforderungen in Kap. 3, vor den Entscheidungsabschnitten, keine Umnummerierung, keine gebrochenen Querverweise | ERFÜLLT |
| METH-02 | FAR/FRR-Tradeoff in Kap. 7.1 explizit beschrieben, Score-Verteilung 0,72--0,85/0,53--0,58 genannt, Betriebspunkt 0,52 im ROC-Rahmen begründet, @deng2019arcface zitiert, kein neuer BibTeX-Eintrag | ERFÜLLT |

**Empfehlung:** METH-01 und METH-02 können in der Requirements-Traceability auf **Complete** gesetzt werden (bereits als Complete in REQUIREMENTS.md eingetragen — Traceability-Status bestätigt).

**Seiteneffekte:** Keine ungewollten Nebeneffekte festgestellt.
- Umnummerierung: NICHT eingetreten — weiterhin 6 `==`-Headings in Kap. 3
- Querverweise in anderen Dateien: NICHT gebrochen — alle 8 geprüften Querverweise zeigen auf unveränderter Nummerierung
- BibTeX: KEIN neuer Eintrag — `deng2019arcface`-Zahl in sources.bib bleibt 1
- Typst-Syntax: Beide neuen Blöcke verwenden korrekte Label-Syntax (`<tab:anforderungen>`) und balancierte Klammern (in Phase 34-02 dokumentiert)
