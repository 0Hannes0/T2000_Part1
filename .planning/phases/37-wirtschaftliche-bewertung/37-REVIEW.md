---
phase: 37-wirtschaftliche-bewertung
reviewed: 2026-07-18T00:00:00Z
depth: standard
files_reviewed: 1
files_reviewed_list:
  - T2000_Part1/chapters/fundamentals-2.typ
findings:
  critical: 1
  warning: 3
  info: 2
  total: 6
status: issues_found
---

# Phase 37: Code Review Report

**Reviewed:** 2026-07-18
**Depth:** standard
**Files Reviewed:** 1
**Status:** issues_found

## Summary

`fundamentals-2.typ` enthält Kapitel 3 der Projektarbeit (Konzeption) — 229 Zeilen Typst-Quelltext mit Architekturdiagrammen, Entscheidungstabellen und dem in Phase 37 erweiterten Abschnitt 3.6 (Wirtschaftliche Bewertung). Die in Phase 37 eingefügten Inhalte (Zeilen 208–229) sind arithmetisch korrekt und konsistent mit den CONTEXT.md-Entscheidungen D-01 bis D-08: Alle Zahlenwerte stimmen ($0,90/Monat AWS, $1,35/Monat Azure, Skalierung ×10 jeweils korrekt). Vier Pre-Phase-37-Probleme wurden aufgedeckt — darunter eine Zitation, die die Aussage, zu der sie zitiert wird, inhaltlich nicht stützt.

---

## Critical Issues

### CR-01: Zitation @radford2021clip stützt die zitierte Aussage nicht

**File:** `T2000_Part1/chapters/fundamentals-2.typ:127`
**Issue:** Die Aussage "da klassische Gaze-Estimation ohne individuelle Kalibrierungsstufe unter realen Bedingungen erheblich an Genauigkeit verliert" wird mit zwei Quellen belegt: `@cheng2021gazesurvey` (ein Gaze-Survey — korrekte Quelle) und `@radford2021clip` (CLIP, Radford et al. 2021 — ein Paper zu kontrastivem Vision-Language-Pre-Training). CLIP befasst sich nicht mit der Kalibrierungsabhängigkeit von Gaze-Estimation-Modellen. Eine Zitation, die die zitierte Behauptung nicht deckt, ist ein akademischer Integritätsfehler, der vor Abgabe behoben werden muss.
**Fix:** `@radford2021clip[S.~1--3]` aus dieser Stelle entfernen. Falls die Verwendung von Zero-Shot-Vision-LLMs (Gemini) im Kontrast zu klassischer Gaze-Estimation belegt werden soll, gehört diese Zitation an das Ende des vorigen Satzes ("Gemini klassifiziert Bilder direkt ohne benutzerspezifische Kalibrierung"), nicht an die Gaze-Accuracy-Aussage:

```typst
// Vorher (Z. 127):
...@cheng2021gazesurvey[§1, S.~1--2], @radford2021clip[S.~1--3].

// Nachher — Zitation an die korrekte Aussage verschieben oder streichen:
Gemini klassifiziert Bilder direkt ohne benutzerspezifische Kalibrierung @radford2021clip[S.~1--3]
--- für einen öffentlichen Kiosk mit wechselnden Personen ist das entscheidend,
da klassische Gaze-Estimation ohne individuelle Kalibrierungsstufe unter realen
Bedingungen erheblich an Genauigkeit verliert @cheng2021gazesurvey[§1, S.~1--2].
```

---

## Warnings

### WR-01: Tabellenbezeichnung vs. "Nicht evaluiert"-Eintrag — interner Widerspruch

**File:** `T2000_Part1/chapters/fundamentals-2.typ:104, 117, 121`
**Issue:** Der einleitende Satz (Z. 104) lautet "Die folgende Tabelle vergleicht die **evaluierten** Detektionsansätze" und die Tabellenunterschrift (Z. 121) lautet "Vergleich **evaluierter** Gesichtsdetektionsansätze". Gleichzeitig ist der Vision-LLM-Eintrag (Z. 117) in der Spalte "Ergebnis" explizit mit `Nicht evaluiert` gekennzeichnet. Ein Leser oder Prüfer wird diesen Widerspruch bemerken: Entweder wurde der Ansatz evaluiert (dann passt die Bezeichnung) oder nicht (dann passt der Tabellenrahmen nicht).
**Fix:** Tabellenunterschrift und Einleitungssatz auf "betrachtet" oder "diskutiert" verallgemeinern — der Vision-LLM-Eintrag dient ja als begründete Ausschluss-Dokumentation, nicht als Evaluierungsergebnis:

```typst
// Z. 104 — Einleitungssatz:
Die folgende Tabelle vergleicht die betrachteten Detektionsansätze anhand dieser Kriterien:

// Z. 121 — Tabellenunterschrift:
caption: [Übersicht betrachteter Gesichtsdetektionsansätze mit Ausschlussbegründung],
```

### WR-02: Vision-LLM-Zeile in Tab. 3.1 — Zellinhalte passen nicht zu Spaltenköpfen

**File:** `T2000_Part1/chapters/fundamentals-2.typ:117`
**Issue:** Die Vision-LLM-Zeile enthält in zwei Spalten Inhalte, die nicht zu den Spaltenköpfen passen:

- Spalte **"Erkannte Winkel"**: Zellinhalt `Nicht für kontinuierliche Detektion geeignet` — das ist eine Aussage zur Eignung, keine Winkelangabe.
- Spalte **"Fehlauslösungen"**: Zellinhalt `Zu hohe Latenz für Frame-Scanning` — das ist eine Latenzaussage, keine Aussage zu Fehlauslösungen (False Positives).

Dadurch entsteht eine inkonsistente Tabellenstruktur, die beim Lesen die Vergleichbarkeit der Zeilen stört.
**Fix:** Zellinhalte auf die Spaltensemantik ausrichten. Da Vision-LLM bewusst nicht evaluiert wurde, sind "N/A"-Werte mit Klammerbemerkungen passender:

```typst
// Zeile Z. 117 — angepasst:
[Vision-LLM (Gemini)],
[Alle (multimodal)],
[~1–2 s],
[N/A (nicht für Frame-Scanning evaluiert)],
[*Nicht evaluiert*],
```

### WR-03: Lizenz-Claim für fünf Komponenten durch eine einzige Quelle belegt

**File:** `T2000_Part1/chapters/fundamentals-2.typ:202`
**Issue:** Die Aussage "MediaPipe, InsightFace, ONNX Runtime, Qdrant und FastAPI sind lizenzfrei nutzbar" wird mit nur einer Quelle belegt: `@lugaresi2019mediapipe[S.~1--2]`. Diese Zitation deckt ausschließlich MediaPipe ab. InsightFace (Apache 2.0), ONNX Runtime (MIT), Qdrant (Apache 2.0) und FastAPI (MIT) sind ohne Quellenangabe. In einer akademischen Arbeit ist ein unbelegter Lizenz-Claim für vier Komponenten ein Schwachpunkt, da ein Prüfer die Aussage für die anderen Komponenten nicht nachvollziehen kann.
**Fix:** Entweder separate Zitationen ergänzen (Projektseiten oder offizielle Lizenz-Dokumente als Quellen) oder die Aussage umstrukturieren, sodass nur MediaPipe zitiert wird und der Rest als "ebenfalls quelloffen" paraphrasiert wird:

```typst
// Option A — explizit belegen:
MediaPipe @lugaresi2019mediapipe[S.~1--2], InsightFace @insightface_license,
ONNX Runtime @onnxruntime_license, Qdrant @qdrant_license und FastAPI @fastapi_license
sind lizenzfrei nutzbar (Apache~2.0 bzw. MIT).

// Option B — Scope einschränken:
Der gesamte lokale Stack basiert auf quelloffenen Komponenten: MediaPipe ist unter
Apache~2.0 lizenziert @lugaresi2019mediapipe[S.~1--2]; InsightFace, ONNX Runtime,
Qdrant und FastAPI stehen ebenfalls unter Apache-2.0- bzw. MIT-Lizenzen zur Verfügung.
```

---

## Info

### IN-01: Ungenutzter `shapes`-Import aus dem `fletcher`-Paket

**File:** `T2000_Part1/chapters/fundamentals-2.typ:2`
**Issue:** `#import "@preview/fletcher:0.5.7": diagram, node, edge, shapes` — `shapes` wird importiert, aber an keiner Stelle der Datei verwendet. In keinem der beiden Diagramme (Z. 10–32 und Z. 41–68) taucht `shapes` auf.
**Fix:** Import bereinigen:

```typst
#import "@preview/fletcher:0.5.7": diagram, node, edge
```

### IN-02: Kostentabelle zeigt für Gemini-Zeilen keine Geldwerte in der "Open-Source/ONNX"-Spalte

**File:** `T2000_Part1/chapters/fundamentals-2.typ:220-222`
**Issue:** Die drei Gemini-Zeilen der Kostentabelle zeigen `identisch\*` in allen drei Kostenspalten — einschließlich der Spalte "Open-Source/ONNX", die das tatsächliche Systemszenario darstellt. Damit fehlen in der Tabelle jegliche absoluten Geldwerte für den Gemini-Verbrauch. Ein Leser, der die Gesamtbetriebskosten des Systems aus der Tabelle ablesen möchte, findet dort keine Zahlen. Die Phase-37-Entscheidung D-08 legt das bewusst so fest, aber aus dem Dokument selbst ist nicht erkennbar, ob die Gemini-Kosten vernachlässigbar oder substanziell sind.

**Hinweis:** Das ist eine reine Klarheits-Empfehlung, kein Fehler. D-08 ist sachlich korrekt — in beiden Szenarien sind Gemini-Kosten identisch. Wenn der Prüfer jedoch fragt "Was kostet das System im Monat?", bietet die Tabelle keine Antwort.

**Fix (optional):** Einen erläuternden Satz vor der Tabelle ergänzen, der den Gemini-Verbrauch quantifiziert — oder die Fußnote um eine Größenordnung ergänzen:

```typst
// In der Tabellenunterschrift Z. 226 — Fußnote erweitern:
\* Gemini-API-Kosten (Google~AI~Studio-Listenpreis: \$0,30/1\,Mio. Input-Token)
sind in beiden Szenarien identisch und werden nicht verglichen; bei den gegebenen
Call-Volumina und Token-Größen liegen sie im einstelligen Cent-Bereich pro Monat.
```

---

_Reviewed: 2026-07-18_
_Reviewer: Claude (gsd-code-reviewer)_
_Depth: standard_
