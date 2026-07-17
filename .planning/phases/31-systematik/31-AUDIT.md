# Phase 31 — Systematik Audit

**Erstellt:** 2026-07-17
**Zweck:** Verlässliche Grundlage für Wave 2 (31-02-PLAN, 31-03-PLAN) — exakte Stellen, Klassifikationen, Einfügepositionen.

---

## 1. Schwellenwert-Vorkommen (SYST-01)

`grep -n "0,65" T2000_Part1/chapters/*.typ` — Ausführung 2026-07-17

| Datei | Zeile | Kontext | Klassifikation | Begründung |
|-------|-------|---------|---------------|------------|
| `methodology.typ` | 124 | Tab. `<tab:tracker-params>` (Kap. 4.4): `` [`SIMILARITY_THRESHOLD`], [0,65], [Schwelle der ArcFace-Stufe der Zuordnung (Wirkung in Kap.~5.2)], `` | **FIX** | Präsentiert 0,65 als operativen Schwellenwert in der Parametertabelle — widerspricht Tab. 5.1, die 0,52 zeigt |
| `practical-1.typ` | 59 | Fletcher-Diagramm Abb. `<fig:tracking-algorithmus>` (Kap. 5.2), Rautenknoten: `node((2,2), align(center)[Stage 2:\ ArcFace-Score ≥ 0,65?], shape: shapes.diamond, ...)` | **FIX** | Zeigt 0,65 als Entscheidungsschwelle in Abb. 5.1 — widerspricht Tab. 5.1 und methodology.typ nach der Korrektur |
| `practical-1.typ` | 40 | Kalibrierungs-Prosa Kap. 5.1: "Ausgehend vom Literaturwert von 0,65 für ArcFace-basierte Verifikation [...] Ein Schwellenwert von 0,65 hätte diese legitimen Wiederkennungen fälschlich als neue Personen klassifiziert." | **KEEP** | Historischer Baseline-Wert in der Kalibrierungs-Erzählung — erklärt explizit, warum 0,65 verworfen wurde. Änderung würde den Satz semantisch falsch machen. |
| `discussion.typ` | 46 | Tab. `<tab:robustheit>` (Kap. 7): "[Beleuchtungsvarianz], [Bei verändertem Kamerastandort: 5/10 korrekte Ersterkennung mit Threshold 0,65; nach Anpassung auf 0,52: 9/10]" | **KEEP** | Vorher/Nachher-Kalibrierungsexperiment — 0,65 ist der historische Ausgangswert vor der Kalibrierung. Kontextuelle Verwendung. |
| `discussion.typ` | 55 | Kap. 7 Prosa: "...knapp unter dem ursprünglichen Schwellenwert von 0,65. Nach Anpassung auf 0,52 stieg die Rate auf 9/10." | **KEEP** | Kalibrierungsexperiment-Narrative — 0,65 ist der Vorher-Wert, der die Änderung begründet. Kontextuelle Verwendung. |

**Zusätzlich `grep -n "0,52"` (Korrekte Vorkommen):**

| Datei | Zeile | Kontext | Status |
|-------|-------|---------|--------|
| `practical-1.typ` | 28 | Tab. `<tab:insightface-kennwerte>` (Kap. 5.1): `` [`SIMILARITY_THRESHOLD`], [0,52 (kalibriert; vgl. Kap.~5.1)], `` | KORREKT — kein Handlungsbedarf |
| `discussion.typ` | 46 | "nach Anpassung auf 0,52: 9/10" | KORREKT — Teil der Kalibrierungs-Narrative |
| `discussion.typ` | 55 | "Nach Anpassung auf 0,52 stieg die Rate auf 9/10." | KORREKT — Teil der Kalibrierungs-Narrative |
| `practical-1.typ` | 40 | "Der gewählte Wert von 0,52 stellt sicher..." | KORREKT — Begründung des gewählten Werts |

### Zusammenfassung: Genau 2 Edits für SYST-01

| Datei | Zeile | Änderung |
|-------|-------|---------|
| `methodology.typ` | 124 | `[0,65]` → `[0,52 (kalibriert; vgl. Kap.~5.1)]` |
| `practical-1.typ` | 59 | `ArcFace-Score ≥ 0,65?` → `ArcFace-Score ≥ 0,52?` |

### Geplante Zusatzänderung: Tab.-4.4-Annotation

Bei der Änderung in `methodology.typ:124` erhält die Zelle zusätzlich die Annotation `(kalibriert; vgl. Kap.~5.1)` — analog zu Tab. 5.1 (`practical-1.typ:28`). Begründung: Macht den Vorwärtsverweis explizit, erklärt warum der Wert vom ArcFace-Paper-Standard abweicht, und schafft Konsistenz zwischen Tab. 4.4 und Tab. 5.1.

Konkret: `[0,65]` → `[0,52 (kalibriert; vgl. Kap.~5.1)]`

---

## 2. Terminologie-Vorkommen vor Definition (SYST-02)

`grep -n "IDLE\|CANDIDATE\|ACTIVE" T2000_Part1/chapters/fundamentals-2.typ T2000_Part1/chapters/methodology.typ` — Ausführung 2026-07-17

### Formale Definitionssektion

Die formale Definition beginnt mit der Kap.-4.3-Überschrift in `methodology.typ`:

```
methodology.typ:60: == State Machine: IDLE → CANDIDATE → ACTIVE
```

Alle Vorkommen **vor** Zeile 60 in `methodology.typ` und alle Vorkommen in `fundamentals-2.typ` sind undefinierte Verwendungen.

### Vorkommen-Tabelle

| Datei | Zeile | Position im Dokument | Kontext | Vor Definition? |
|-------|-------|---------------------|---------|----------------|
| `fundamentals-2.typ` | 46 | Kap. 3.1 Pipeline-Diagramm (Abb. 3.2), Node-Label | `PresenceStateMachine\ #text(size:7.5pt)[IDLE → CANDIDATE → ACTIVE]` | **JA** — erstes Erscheinen im Dokument, keine Definition vorhanden |
| `fundamentals-2.typ` | 60 | Kap. 3.1 Pipeline-Diagramm (Abb. 3.2), Edge-Label | `edge(<gz>, <ws>, "->", bend:-30deg, label: text(size:7pt)[true → ACTIVE])` | **JA** |
| `fundamentals-2.typ` | 176 | Kap. 3.6 Prosa (Wirtschaftliche Bewertung) | "einmalig pro ACTIVE-Ereignis" und "vollständigem ACTIVE-Übergang" | **JA** |
| `methodology.typ` | 26 | Kap. 4.1 Prosa | "4-Sekunden-CANDIDATE-Timer auslösen" | **JA** — vor Kap.-4.3-Überschrift |
| `methodology.typ` | 54 | Kap. 4.2 Prosa (Gaze-Validierung) | `CANDIDATE_SECS` (mit Backticks) | **JA** — Parametername, technisch CANDIDATE-Verweis |
| `methodology.typ` | 56 | Kap. 4.2 Prosa | "Übergang zu ACTIVE freigegeben, wie in Kap.~4.3 detailliert beschrieben" | **JA** |
| `methodology.typ` | 57 | Kap. 4.2 Prosa | "im CANDIDATE-Zustand" | **JA** |
| `methodology.typ` | 60 | **Kap.-4.3-Überschrift** | `== State Machine: IDLE → CANDIDATE → ACTIVE` | NEIN — BEGINN der Definitionssektion |
| `methodology.typ` | 71–73 | Kap. 4.3 Parametertabelle | CANDIDATE_SECS, LEAVE_SECS, GAZE_TIMEOUT_SECS | NEIN — innerhalb der Definition |
| `methodology.typ` | 87–89 | Kap. 4.3 Fletcher-Diagramm | `[IDLE]`, `[CANDIDATE]`, `[ACTIVE]` Nodes | NEIN — Teil der formalen Darstellung |
| `methodology.typ` | 101+ | Kap. 4.3 Prosa | Vollständige Erklärungen aller Übergänge | NEIN — Definitionsabschnitt |

**Undefinierte Vorkommen (JA): mindestens 7** (fundamentals-2.typ: 3, methodology.typ vor Kap.4.3: 4+)

### Exakte Einfügeposition

**Datei:** `fundamentals-2.typ`
**Nach Zeile:** 37 (Leerzeile nach dem Prosa-Absatz "Der Presence Service bildet die Kernkomponente...")
**Vor Zeile:** 38 (`#figure(` — Start des Pipeline-Diagramms Abb. 3.2)

```
Zeile 36: Der Presence Service bildet die Kernkomponente [...] LLM-Chat.
Zeile 37: (Leerzeile)
>>> EINFÜGEN HIER <<<
Zeile 38: #figure(
Zeile 39:   diagram(
...
Zeile 46:     node((0,3), align(center)[PresenceStateMachine\ #text(size:7.5pt)[IDLE → CANDIDATE → ACTIVE]], ...)
```

### Vorgeschlagener Definitions-Wortlaut

```typst
Die Zustandsverwaltung jeder erkannten Person wird durch eine `PresenceStateMachine` modelliert,
die drei Zustände kennt: _IDLE_ (Person nicht aktiv erkannt), _CANDIDATE_ (Person erkannt,
Interaktionsabsicht wird durch Gaze-Check geprüft) und _ACTIVE_ (Gaze-Check positiv, Sitzung läuft).
Kap.~4.3 beschreibt den Zustandsautomaten vollständig.
```

(Quelle: 31-RESEARCH.md, aus direkter Inspektion von fundamentals-2.typ und methodology.typ)

### Doppelnutzen DOKU-02 (Phase 40)

Diese eine Einfügung in `fundamentals-2.typ` erfüllt sowohl **SYST-02** (Phase 31) als auch **DOKU-02** (Phase 40, "IDLE/CANDIDATE/ACTIVE vor erster Verwendung einführen"). Phase 40 muss diese Stelle nur verifizieren, nicht erneut implementieren.

---

## Zusammenfassung für Wave 2

| Aufgabe | Datei | Zeile | Aktion |
|---------|-------|-------|--------|
| SYST-01 Fix 1 | `methodology.typ` | 124 | `[0,65]` → `[0,52 (kalibriert; vgl. Kap.~5.1)]` |
| SYST-01 Fix 2 | `practical-1.typ` | 59 | `ArcFace-Score ≥ 0,65?` → `ArcFace-Score ≥ 0,52?` |
| SYST-02 Insert | `fundamentals-2.typ` | nach Zeile 37 | Definitions-Absatz (4 Zeilen) einfügen |

Wave 1 ändert **keine** Quelldateien. Alle 0,65-Vorkommen in den Kapitel-Dateien bleiben unverändert bis Wave 2.
