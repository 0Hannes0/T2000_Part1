# 40-AUDIT.md — Bestandsaufnahme Phase 40 (Dokumentation)

Erstellt: 2026-07-19
Zweck: Liefert exakte Parameterwerte und Einfügepositionen für Wave 2 (40-02-PLAN.md und 40-03-PLAN.md).

---

## Anhang-Bestand

**Datei geprüft:** `T2000_Part1/pages/appendix.typ`

Der Anhang wird in `template.typ` Zeile 175 via `#appendix(labels: labels)` eingebunden.
Die `appendix()`-Funktion in `pages/appendix.typ` rendert ausschließlich die AI-Tools-Tabelle
(i18n-Schlüssel `appendix-ai-heading` = "A1: Übersicht eingesetzter KI-Werkzeuge").

**Befund:** Kein Abschnitt "Systemparameter" oder "Anhang A" mit Parametertabelle vorhanden.
Der Anhang enthält ausschließlich:
- A1: Übersicht eingesetzter KI-Werkzeuge

Ein eigenständiger Unterabschnitt für Systemparameter fehlt vollständig.
**Wave 2 muss Anhang A2 (Systemparameter) neu anlegen.**

---

## Parameterübersicht (alle 6 Pflichtparameter)

| Parameter | Wert | Einheit | Quelldatei + Zeile | Kapitelreferenz im Text |
|---|---|---|---|---|
| `CANDIDATE_SECS` | 4,0 | s | `chapters/methodology.typ` Z. 71 (Tab. 4.3) | Kap. 4.3 |
| `LEAVE_SECS` | 10,0 | s | `chapters/methodology.typ` Z. 72 (Tab. 4.3) | Kap. 4.3 |
| `FRAME_INTERVAL` | 1,0 | s | `chapters/methodology.typ` Z. 75 (Tab. 4.3) | Kap. 4.3 |
| `GROUP_ARRIVAL_WINDOW_SECS` | 2,0 | s | `chapters/methodology.typ` Z. 125 (Tab. 4.4) | Kap. 4.4 |
| `SIMILARITY_THRESHOLD` | 0,52 | dimensionslos | `chapters/practical-1.typ` Z. 28 (Tab. 5.1) | Kap. 5.1 |
| `EMA-α` | 0,2 | dimensionslos | `chapters/practical-1.typ` Z. 117 (Formel) | Kap. 5.3 |

**Quelltextbelege (exakte Lesestellen):**

- `CANDIDATE_SECS` / `LEAVE_SECS` / `FRAME_INTERVAL`: methodology.typ Tab. 4.3 "Parametrisierung der PresenceStateMachine"
  - Z. 71: `[`CANDIDATE_SECS`], [4,0 s], [Person muss vier Sekunden ...`
  - Z. 72: `[`LEAVE_SECS`], [10,0 s], [Kein Gesicht für zehn Sekunden ...`
  - Z. 75: `[`FRAME_INTERVAL`], [1,0 s], [Periodisches Detektions-Intervall ...`

- `GROUP_ARRIVAL_WINDOW_SECS`: methodology.typ Tab. 4.4 "Parametrisierung des PersonTracker für Multi-Person-Tracking"
  - Z. 125: `[`GROUP_ARRIVAL_WINDOW_SECS`], [2,0 s], [Sammel-Fenster ...`

- `SIMILARITY_THRESHOLD`: practical-1.typ Tab. 5.1 "Kennwerte des InsightFace buffalo_l Erkennungsmodells"
  - Z. 28: `[`SIMILARITY_THRESHOLD`], [0,52 ],`
  - Kalibrierungsbegründung Z. 40: Ausgangswert 0,65 → iterativ auf 0,52 gesetzt

- `EMA-α`: practical-1.typ Z. 117 (LaTeX-Formel):
  `$ bold(e)_"neu" = "normalize"((1-alpha) dot.op bold(e)_"alt" + alpha dot.op bold(e)_"aktuell"), quad alpha = 0","2 $`
  - Z. 119: "Mit $alpha = 0","2$ trägt das aktuelle Sitzungs-Embedding 20 % bei ..."

---

## IDLE / CANDIDATE / ACTIVE — Erstauftreten und Definitionsstatus

### Dateiscan-Ergebnis

| Datei | Erstes Vorkommen | Kommentar |
|---|---|---|
| `chapters/introduction.typ` | — | Kein Vorkommen |
| `chapters/fundamentals-1.typ` | — | Kein Vorkommen |
| `chapters/fundamentals-2.typ` | **Zeile 38** | Erste und vollständige Definition |

### Exakter Wortlaut fundamentals-2.typ Z. 38

> "Die Zustandsverwaltung jeder erkannten Person wird durch eine `PresenceStateMachine` modelliert,
> die drei Zustände kennt: _IDLE_ (Person nicht aktiv erkannt), _CANDIDATE_ (Person erkannt,
> Interaktionsabsicht wird durch den Gaze-Check geprüft) und _ACTIVE_ (Gaze-Check positiv,
> Sitzung läuft). Kap. 4.3 beschreibt den Zustandsautomaten vollständig."

### Bewertung

**Kriterium:** Alle drei Begriffe müssen mit Kurzerklärung eingeführt sein, BEVOR sie in
Kap. 4 (methodology.typ) ohne Erklärung verwendet werden.

- fundamentals-2.typ liegt in Kap. 2 (Grundlagen), methodology.typ in Kap. 4 (Personenerkennung)
- Kap. 2 kommt vor Kap. 4 → Reihenfolge korrekt
- Alle drei Zustände (IDLE, CANDIDATE, ACTIVE) sind mit Kurzerklärung in Klammern versehen
- Der Verweis auf Kap. 4.3 für die vollständige Beschreibung ist korrekt gesetzt

**Status DOKU-02: ERFÜLLT**

---

## Befund und Wave-2-Handlungsanweisung

| Frage | Antwort |
|---|---|
| Muss Anhang A (Systemparameter) neu angelegt werden? | **Ja** — kein solcher Abschnitt vorhanden; Wave 2 legt A2 in `pages/appendix.typ` an |
| Ist die Parametertabelle vollständig erfasst? | **Ja** — alle 6 Parameter mit Wert, Einheit und Quelldatei+Zeile dokumentiert |
| Ist DOKU-02 (Terminologie-Einführung) bereits erfüllt? | **Ja** — fundamentals-2.typ Z. 38 definiert alle drei Zustände vor Kap. 4 |

### Konkrete Handlungsanweisungen für Wave 2

**40-02-PLAN.md (Anhang A2 anlegen):**
- Einfügeort: `pages/appendix.typ` nach dem bestehenden A1-Block
- Tabelleninhalt: die 6 Parameter aus obiger Tabelle
- i18n-Schlüssel für neue Überschrift in `i18n/DE.typ` ergänzen

**40-03-PLAN.md (DOKU-02 — Terminologie):**
- Kein Eingriff notwendig — DOKU-02 ist bereits erfüllt
- Wave 3 kann sich auf Verifikation beschränken und DOKU-02 formal abschliessen
