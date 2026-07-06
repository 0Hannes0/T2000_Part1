# Typst Vorlage – DHBW Ravensburg

Vorlage für wissenschaftliche Arbeiten an der DHBW Ravensburg, erstellt mit [Typst](https://typst.app/).

## Installation

### Option 1 – CLI

```bash
# Windows (winget)
winget install --id Typst.Typst

# macOS (Homebrew)
brew install typst

# Linux / alle Plattformen (Cargo)
cargo install typst-cli
```

Oder direkt als Binary von [github.com/typst/typst/releases](https://github.com/typst/typst/releases) herunterladen und in den `PATH` legen.

### Option 2 – VS Code Extension

[Tinymist Typst](https://marketplace.visualstudio.com/items?itemName=myriad-dreamin.tinymist) installieren — kompiliert automatisch beim Speichern und zeigt eine Live-Vorschau.

---

## Kompilieren

```bash
typst compile template.typ paper.pdf        # einmalig kompilieren → paper.pdf
typst watch  template.typ paper.pdf         # bei jeder Speicherung neu kompilieren
```

> **Voraussetzung:** Die gewählte Schriftart muss auf dem System installiert sein. Standard ist **Arial** — alternativ z.B. `"Calibri"` oder `"Times New Roman"` eintragen.

---

## Konfiguration

**Alle Anpassungen erfolgen ausschließlich im Ordner `user/`.** Alle anderen Dateien bleiben in der Regel unverändert.

### Sprache

```typst
#let lang = "DE"   // "DE" oder "EN"
```

### Dokumenttyp

```typst
#let doc-type = "bachelor"   // siehe Tabelle unten
```

| Wert | Dokumenttyp |
|---|---|
| `"bachelor"` | Bachelorarbeit |
| `"term-paper"` | Studienarbeit |
| `"project"` | Projektarbeit |
| `"project-doc"` | Projektdokumentation |
| `"seminar"` | Seminararbeit |

- Bei `"seminar"`: Feld `lecture` befüllen.
- Bei `"project"` / `"project-doc"`: Feld `project-number` auf `"1"` oder `"2"` setzen.

### Metadaten

```typst
#let config = (
  title:             "Titel der Arbeit",
  subtitle:          "Untertitel",
  author:            "Vorname Nachname",
  mat-number:        "1234567",
  course:            "TIK23",
  study-program:     "Wirtschaftsinformatik",
  company:           "Muster GmbH, 12345 Musterstadt",
  company-supervisor:"Max Mustermann",
  supervisor:        "Prof. Dr. Musterfrau",
  submission-date:   "31.03.2025",

  // Nur für Seminararbeit:
  lecture:           "Vorlesungsname",

  // Nur für Projektarbeit:
  project-number:    "1",   // "1" oder "2"
)
```

### Optionale Schalter

```typst
// Sperrvermerk – nur bei vertraulichen Themen aktivieren, sonst false lassen
#let show-confidentiality-notice = false

// Unternehmensbetreuer auf dem Titelblatt ein-/ausblenden
#let show-company-supervisor = true
```

Einzelne Beschriftungen lassen sich direkt in `i18n/DE.typ` bzw. `i18n/EN.typ` anpassen, ohne Layout-Dateien anzufassen.

Die Vorlagenversion ist in `main.typ` als `template-version` hinterlegt und kann bei Bedarf im Dokument angezeigt werden.

Die Schriftart ist in `main.typ` als `font` hinterlegt (Standard: `"Arial"`). Zum Wechseln diesen Wert anpassen — die Schrift muss auf dem System installiert sein.

---

## Inhalt bearbeiten

### Kapitel – `chapters/`

```
chapters/introduction.typ     Einleitung
chapters/main.typ             Hauptteil (bindet Unterkapitel ein)
chapters/typst-examples.typ   Typst-Elemente als Beispiele – vor Abgabe entfernen
chapters/fundamentals-1.typ   Fachliche Grundlagen 1
chapters/fundamentals-2.typ   Fachliche Grundlagen 2
chapters/methodology.typ      Methodik
chapters/practical-1.typ      Praxiskapitel 1
chapters/practical-2.typ      Praxiskapitel 2
chapters/discussion.typ       Diskussion
chapters/conclusion.typ       Fazit
```

> **Hinweis:** Das Include `typst-examples.typ` in `chapters/main.typ` vor der Abgabe auskommentieren oder entfernen.

Neue Kapitel als eigene Dateien anlegen und in `chapters/main.typ` per `#include` einbinden.

### Abkürzungsverzeichnis – `user/abbreviations.typ`

```typst
#let abbreviations = (
  ("API", "Application Programming Interface"),
  ("KI",  "Künstliche Intelligenz"),
)
```

Die Einträge erscheinen automatisch sortiert im Abkürzungsverzeichnis.

### Literatur – `user/sources.bib`

Quellen im BibTeX-Format eintragen. Die Vorlage enthält Beispieleinträge für `@article`, `@book`, `@techreport`, `@inbook` und `@misc`.

Zitieren im Text:

```typst
@Schluessel                                       // (Autor Jahr)
#cite(<Schluessel>, supplement: [S. 12])         // (Autor Jahr, S. 12)
@Quelle1 @Quelle2                                 // mehrere Quellen
```

### KI-Werkzeuge – `user/ai-tools.typ`

Eingesetzte KI-Tools eintragen. Sie erscheinen automatisch im Anhang (KI-Tabelle).

```typst
#let ai-tools = (
  ("ChatGPT", (
    [Recherche zu Grundbegriffen (Kapitel 2)],
    [Korrekturhilfe (gesamt)],
  )),
)
```

---

## Automatisch generierte Seiten

Die folgenden Seiten werden vollständig automatisch erzeugt – kein manueller Eingriff nötig:

| Seite | Quelle |
|---|---|
| Titelblatt | `user/config.typ` |
| Sperrvermerk | `user/config.typ` → `show-confidentiality-notice` |
| Inhaltsverzeichnis | Überschriften im Dokument |
| Abkürzungsverzeichnis | `user/abbreviations.typ` |
| Abbildungs- / Tabellen- / Listingverzeichnis | `#figure()`-Einträge |
| Literaturverzeichnis | `user/sources.bib` |
| Anhang (KI-Tabelle) | `user/ai-tools.typ` |
| Selbständigkeitserklärung | `user/config.typ` |
| KI-Erklärung | `user/ai-tools.typ` |

### Seitennummerierung

- **Römisch** (I, II, III, …): Titelblatt und alle Verzeichnisse
- **Arabisch** (1, 2, 3, …): Einleitung bis Fazit
- Die Kopfzeile im Textteil zeigt automatisch den aktuellen Kapitelnamen.

---

## Vor der Abgabe

- Alle Platzhalter in `user/config.typ` durch echte Daten ersetzen.
- `user/abbreviations.typ`, `user/sources.bib` und `user/ai-tools.typ` vollständig befüllen.
- Sperrvermerk auf `true` setzen, falls vertrauliches Thema.
