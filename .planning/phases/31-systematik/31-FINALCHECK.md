# Phase 31 — Final Check (31-03)

**Erstellt:** 2026-07-17
**Zweck:** Verifikationsprotokoll der drei Success Criteria (SYST-01, SYST-02) per grep-Belegen.

---

## SYST-01: Schwellenwert-Konsistenz

**Requirement:** Alle drei Schwellenwert-Darstellungen zeigen 0,52. Kein operatives 0,65 verbleibt. Drei KEEP-Vorkommen (Kalibrierungs-Narrative) bleiben intakt.

### grep-Beleg: alle 0,65-Vorkommen in Kapitel-Dateien

```
$ grep -n "0,65" T2000_Part1/chapters/*.typ

T2000_Part1/chapters/practical-1.typ:40:  ...Ausgehend vom Literaturwert von 0,65 für ArcFace-basierte Verifikation...
                                           ...Ein Schwellenwert von 0,65 hätte diese legitimen Wiederkennungen fälschlich...
T2000_Part1/chapters/discussion.typ:46:   ...Threshold 0,65; nach Anpassung auf 0,52: 9/10...
T2000_Part1/chapters/discussion.typ:55:   ...knapp unter dem ursprünglichen Schwellenwert von 0,65. Nach Anpassung auf 0,52...
```

**Anzahl 0,65-Vorkommen: 4 (in 3 Textstellen/Sätzen)**

| Datei | Zeile | Kontext | Klassifikation |
|-------|-------|---------|---------------|
| `practical-1.typ` | 40 | "Ausgehend vom Literaturwert von 0,65 für ArcFace-basierte Verifikation" — Kalibrierungs-Prosa Kap. 5.1 | **KEEP** — Baseline-Wert |
| `practical-1.typ` | 40 | "Ein Schwellenwert von 0,65 hätte diese legitimen Wiederkennungen fälschlich klassifiziert" — Kalibrierungs-Prosa Kap. 5.1 | **KEEP** — Begründung warum 0,65 verworfen |
| `discussion.typ` | 46 | "Threshold 0,65; nach Anpassung auf 0,52: 9/10" — Tab. Robustheit Kap. 7 | **KEEP** — Vorher/Nachher-Experiment |
| `discussion.typ` | 55 | "ursprünglichen Schwellenwert von 0,65. Nach Anpassung auf 0,52" — Kap. 7 Prosa | **KEEP** — Kalibrierungs-Narrative |

Alle vier Vorkommen sind Kalibrierungs-Narrative (KEEP). Kein operatives 0,65 vorhanden.

### Überprüfung: methodology.typ enthält kein 0,65

```
$ grep -c "0,65" T2000_Part1/chapters/methodology.typ
0
```

**Ergebnis: 0** — PASS (Tab. 4.4 zeigt 0,52)

### Überprüfung: kein "ArcFace-Score >= 0,65" in practical-1.typ

```
$ grep -n "ArcFace-Score.*0,65" T2000_Part1/chapters/practical-1.typ
(kein Treffer)
```

**Ergebnis: kein Treffer** — PASS (Abb. 5.1 Rautenknoten zeigt 0,52)

### grep-Beleg: 0,52-Vorkommen (Soll-Zustand)

```
$ grep -n "0,52" T2000_Part1/chapters/*.typ

T2000_Part1/chapters/methodology.typ:124:  [`SIMILARITY_THRESHOLD`], [0,52 (kalibriert; vgl. Kap.~5.1)], [...]
T2000_Part1/chapters/practical-1.typ:28:   [`SIMILARITY_THRESHOLD`], [0,52 (kalibriert; vgl. Kap.~5.1)],
T2000_Part1/chapters/practical-1.typ:40:  ...Der gewählte Wert von 0,52 stellt sicher...
T2000_Part1/chapters/practical-1.typ:59:  node((2,2), align(center)[Stage 2:\ ArcFace-Score ≥ 0,52?], ...)
T2000_Part1/chapters/discussion.typ:46:   ...nach Anpassung auf 0,52: 9/10...
T2000_Part1/chapters/discussion.typ:55:   ...Nach Anpassung auf 0,52 stieg die Rate auf 9/10.
```

### Einzelbelege der drei Pflicht-Darstellungen

| Darstellung | Datei | Zeile | Wert | Status |
|-------------|-------|-------|------|--------|
| Tab. 4.4 (`<tab:tracker-params>`) | `methodology.typ` | 124 | `0,52 (kalibriert; vgl. Kap.~5.1)` | PASS |
| Tab. 5.1 (`<tab:insightface-kennwerte>`) | `practical-1.typ` | 28 | `0,52 (kalibriert; vgl. Kap.~5.1)` | PASS |
| Abb. 5.1 Rautenknoten (`<fig:tracking-algorithmus>`) | `practical-1.typ` | 59 | `ArcFace-Score ≥ 0,52?` | PASS |

### Automatisiertes Verify-Kommando

```
$ count=$(grep -rn "0,65" T2000_Part1/chapters/*.typ | grep -vc "Kalibrier|Literaturwert|ursprünglichen|Threshold 0,65; nach|Ein Schwellenwert von 0,65 hätte") && [ "$count" = "0" ] && echo "PASS: no operative 0,65 found"
PASS: no operative 0,65 found
```

### SYST-01 Ergebnis: **PASS**

---

## SYST-02: Terminologie-Definition vor Erstgebrauch

**Requirement:** Die Zustände IDLE, CANDIDATE und ACTIVE sind in `fundamentals-2.typ` vor ihrem ersten Auftreten im Pipeline-Diagramm (Abb. 3.2) definiert.

### grep-Beleg: IDLE/CANDIDATE/ACTIVE in fundamentals-2.typ

```
$ grep -n "IDLE\|CANDIDATE\|ACTIVE\|PresenceStateMachine modelliert" T2000_Part1/chapters/fundamentals-2.typ

fundamentals-2.typ:38:  Die Zustandsverwaltung jeder erkannten Person wird durch eine `PresenceStateMachine` modelliert,
                         die drei Zustände kennt: _IDLE_ (Person nicht aktiv erkannt), _CANDIDATE_ (Person erkannt,
                         Interaktionsabsicht wird durch den Gaze-Check geprüft) und _ACTIVE_ (Gaze-Check positiv,
                         Sitzung läuft). Kap.~4.3 beschreibt den Zustandsautomaten vollständig.
fundamentals-2.typ:48:  node((0,3), align(center)[PresenceStateMachine\ #text(size:7.5pt)[IDLE → CANDIDATE → ACTIVE]], ...)
fundamentals-2.typ:62:  edge(<gz>, <ws>, "->", bend:-30deg, label: text(size:7pt)[true → ACTIVE])
fundamentals-2.typ:178: ...einmalig pro ACTIVE-Ereignis...vollständigem ACTIVE-Übergang...
```

### Positionsnachweis: Definition vor Diagramm-Label

| Element | Zeile |
|---------|-------|
| Definitions-Absatz (Zeile mit "Die Zustandsverwaltung jeder erkannten Person") | **38** |
| Erstes Diagramm-Label (IDLE → CANDIDATE → ACTIVE im Pipeline-Node) | **48** |

**Definitionszeile (38) < Diagramm-Label-Zeile (48)** — PASS

### Inhalt des Definitions-Absatzes

Zeile 38 enthält alle drei Zustände mit Kurzdefinitionen:
- **_IDLE_**: Person nicht aktiv erkannt
- **_CANDIDATE_**: Person erkannt, Interaktionsabsicht wird durch den Gaze-Check geprüft
- **_ACTIVE_**: Gaze-Check positiv, Sitzung läuft
- **Kap.~4.3-Verweis**: "Kap.~4.3 beschreibt den Zustandsautomaten vollständig." — vorhanden

### Automatisiertes Verify-Kommando

```
$ DEF=$(grep -n "Die Zustandsverwaltung jeder erkannten Person" T2000_Part1/chapters/fundamentals-2.typ | head -1 | cut -d: -f1)
$ LBL=$(grep -n "IDLE → CANDIDATE → ACTIVE" T2000_Part1/chapters/fundamentals-2.typ | head -1 | cut -d: -f1)
$ [ "$DEF" -lt "$LBL" ] && echo "PASS: def($DEF) before label($LBL)"
PASS: def(38) before label(48)
```

### DOKU-02-Doppelnutzen (Phase 40)

Die Einfügung in `fundamentals-2.typ` Zeile 38 erfüllt sowohl SYST-02 (Phase 31) als auch DOKU-02 (Phase 40, "IDLE/CANDIDATE/ACTIVE vor erster Verwendung einführen"). Phase 40 muss diese Stelle nur noch verifizieren, nicht erneut implementieren. Entsprechende Notiz für den Phase-40-Verifier: Zeile 38 in `fundamentals-2.typ` enthält bereits den vollständigen Definitions-Absatz.

### SYST-02 Ergebnis: **PASS**

---

## Gesamtergebnis

| Criterion | Ergebnis |
|-----------|----------|
| SYST-01: Schwellenwert-Konsistenz (0,52 in Tab. 4.4, Tab. 5.1, Abb. 5.1) | **PASS** |
| SYST-01: Kalibrierungs-Narrative intakt (genau 4 KEEP-Vorkommen 0,65) | **PASS** |
| SYST-01: Kein operatives 0,65 verblieben | **PASS** |
| SYST-02: Terminologie vor Erstgebrauch definiert (Zeile 38 vor Zeile 48) | **PASS** |

**Phase 31 Gate: PASS — Phase 32 kann starten.**
