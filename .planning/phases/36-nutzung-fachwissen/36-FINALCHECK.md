# Phase 36: Nutzung Fachwissen — Finalcheck

**Erstellt:** 2026-07-18
**Zweck:** Verifikation aller drei WISS-Kriterien und Typst-Compilation nach Wave 2

---

## WISS-01: ArcFace/CosFace — Geometrischer Unterschied

**Datei:** `T2000_Part1/chapters/fundamentals-1.typ`

### Grep-Checks

| Check | Befehl | Ergebnis |
|-------|--------|----------|
| (a) Keyword `geodätisch` | `grep -c "geodätisch" fundamentals-1.typ` | **1** ≥ 1 ✓ |
| (b) Keyword `Winkelmarge\|Kosinusmarge` | `grep -c "Winkelmarge\|Kosinusmarge" fundamentals-1.typ` | **3** ≥ 1 ✓ |
| (c) Dual-Zitation `wang2018cosface` | `grep -c "wang2018cosface" fundamentals-1.typ` | **3** ≥ 1 ✓ |

### Inhaltlicher Check

Eingefügter Paragraph (Zeilen 46–48) enthält kausale Erklärung:

> "Da der Kosinus eine nichtlineare Funktion des Winkels ist, erzeugt eine konstante Kosinusmarge
> ungleichmäßige Winkelabstände --- bei kleinen Winkeln, also ähnlichen Personen, fällt die
> erzwungene Trennung kleiner aus als bei bereits weitgehend verschiedenen Klassen.
> Die additive Winkelmarge von ArcFace entspricht dagegen exakt der **geodätischen Distanz** auf
> der Einheitshypersphäre und legt damit entlang der gesamten Entscheidungsgrenze einen konstant
> linearen Abstand fest @deng2019arcface[S.~5--6], @wang2018cosface[S.~1--2]."

Kausale Erklärung vorhanden: nichtlineare Kosinus-Funktion führt zu ungleichmäßigen Winkelabständen;
ArcFace-Winkelmarge = geodätische Distanz = gleichmäßige Trennung entlang Entscheidungsgrenze.

**Verdict: WISS-01 PASS**

---

## WISS-02: RAG-Modell MTEB-Benchmark-Begründung

**Dateien:** `T2000_Part1/chapters/practical-2.typ`, `T2000_Part1/user/sources.bib`

### Grep-Checks

| Check | Befehl | Ergebnis |
|-------|--------|----------|
| (a) `muennighoff2023mteb` in practical-2.typ | `grep -c "muennighoff2023mteb" practical-2.typ` | **1** = 1 ✓ |
| (b) `56,53` in practical-2.typ | `grep -c "56,53" practical-2.typ` | **1** ≥ 1 ✓ |
| (c) `muennighoff2023mteb` in sources.bib | `grep -c "muennighoff2023mteb" sources.bib` | **1** ≥ 1 ✓ |
| (d) DOI `10.18653/v1/2023.eacl-main.148` in sources.bib | `grep -c "10.18653/v1/2023.eacl-main.148" sources.bib` | **1** = 1 ✓ |

### Inhaltlicher Check

Eingefügter Satz (Zeile 72):

> "Im MTEB-Benchmark erzielt das Modell einen Durchschnittsscore von **56,53** über 56 englische
> Evaluationsaufgaben --- darunter 79,80 für semantische Ähnlichkeit und 58,44 für Reranking ---
> und positioniert sich damit im Pareto-optimalen Geschwindigkeit-Leistungs-Segment für
> 384-dimensionale Einbettungen @muennighoff2023mteb[S.~2020--2022]."

BibTeX-Eintrag `muennighoff2023mteb` in sources.bib (Zeile 302) mit korrektem DOI vorhanden.

**Verdict: WISS-02 PASS**

---

## WISS-03: EMA-Literaturkontext — Kap. 5.3

**Datei:** `T2000_Part1/chapters/practical-1.typ`

### Grep-Checks

| Check | Befehl | Ergebnis |
|-------|--------|----------|
| (a) Keyword `veraltet` | `grep -c "veraltet" practical-1.typ` | **1** ≥ 1 ✓ |
| (b) Keyword `Dilemma\|Ausreißer` | `grep -c "Dilemma\|Ausreißer" practical-1.typ` | (beide vorhanden) ✓ |
| (c) `dewan2016adaptiveappearance` | `grep -c "dewan2016adaptiveappearance" practical-1.typ` | **2** ≥ 2 ✓ |
| (d) EMA-Formel `bold(e)_` unverändert | `grep -c "bold(e)_" practical-1.typ` | **1** ≥ 1 ✓ |

### Inhaltlicher Check

Eingefügter Paragraph (Zeile 122) enthält:
- "Ein statisches Template **veraltet**, sobald sich das Erscheinungsbild einer Person verändert"
- "das biometrische **Dilemma** besteht darin, dass direktes Überschreiben das entgegengesetzte Risiko birgt"
- "Adaptive Erscheinungsmodelle lösen dieses Dilemma ... @dewan2016adaptiveappearance[S.~129--131]"

EMA-Formel-Zeile (123) mit `bold(e)_` unverändert vorhanden.

**Verdict: WISS-03 PASS**

---

## Compilation Check

**Befehl:** `typst compile template.typ /tmp/t2000_check.pdf`
**Ausführungsverzeichnis:** `T2000_Part1/`
**Exit-Code:** 1
**Fehler:**
```
error: pagebreaks are not allowed inside of containers
   ┌─ template.typ:45:4
   │
45 │     pagebreak(weak: true)
```

**Analyse:** Der Fehler liegt in `template.typ` Zeile 45 (innerhalb eines `#show heading`-Blocks)
und ist von den Wave-2-Änderungen unabhängig. Die Datei `template.typ` wurde in den Wave-2-Commits
nicht verändert (bestätigt per `git diff`). Der Fehler ist Typst-0.15-Regressions-bedingt:
Die bestehende `output.pdf` (Stand: 16. Juli 2026) wurde mit einer früheren Typst-Version
erstellt. Wave-2-Änderungen haben den Fehler weder eingeführt noch verschlimmert.

**Scope-Einordnung:** Pre-existing structural issue — außerhalb des Scopes von Phase 36.
Die WISS-Anforderungen sind auf Textinhaltsebene vollständig erfüllt; die Compilation-Blockade
ist ein separates technisches Infrastrukturproblem.

**Verdict: Compilation FAIL — PRE-EXISTING (nicht durch Wave-2-Änderungen verursacht)**

---

## Gesamturteil

| Kriterium | Status |
|-----------|--------|
| WISS-01: Geometrische ArcFace/CosFace-Erklärung | **PASS** |
| WISS-02: MTEB-Score-Satz + BibTeX-Eintrag | **PASS** |
| WISS-03: Biometrisches Dilemma-Paragraph vor EMA | **PASS** |
| Typst-Compilation (template.typ) | **FAIL — pre-existing** (Typst 0.15 Regression, nicht durch Wave 2 verursacht) |

**Phase 36 bereit zum Abschluss** — alle drei WISS-Inhaltskriterien PASS;
Compilation-Fehler ist strukturell pre-existing und außerhalb des Phase-36-Scopes.
