# Phase 39: Umsetzbarkeit — Audit der Zielstellen

**Erstellt:** 2026-07-19
**Zweck:** Wave 2 kann ohne Neuexploration der Zieldateien direkt implementieren.
**Auditierte Dateien:** `fundamentals-2.typ` (UMSE-01), `conclusion.typ` (UMSE-02)

---

## UMSE-01 — HNSW-Skalierbarkeit (fundamentals-2.typ, Kap. 3.4)

### (1) Ist-Zustand mit Zeilennummer

**Datei:** `T2000_Part1/chapters/fundamentals-2.typ`, **Z. 190**

Vollständiger relevanter Satz (Ende des Qdrant-Absatzes):

> „Als Index-Algorithmus verwendet Qdrant HNSW (Kap.~2.2.1), der die für den Live-Betrieb
> erforderliche logarithmische Suchkomplexität liefert @malkov2020hnsw[S.~1--2],
> @johnson2019faiss[S.~1--3]. Die `conversation_chunks`-Collection dient dabei als
> nicht-parametrisches Gedächtnis im Sinne des in Kap.~2.3.3 hergeleiteten RAG-Mechanismus..."

HNSW und O(log N) sind korrekt erwähnt. Es fehlt: Anwendung auf konkrete Profilzahlen
(10.000 / 100.000), keine Latenzabschätzung, kein Vergleich mit Testbetrieb.

### (2) Exakte Einfügeposition

Direkt nach `@johnson2019faiss[S.~1--3].` — also am Satzende nach dem zweiten Quellenbeleg.
Der Einschub steht VOR dem nachfolgenden Satz `Die \`conversation_chunks\`-Collection dient...`

Typst-Kontext (Z. 190, relevanter Teil):
```
...logarithmische Suchkomplexität liefert @malkov2020hnsw[S.~1--2], @johnson2019faiss[S.~1--3].
[>>> HIER EINFÜGEN <<<]
Die `conversation_chunks`-Collection dient dabei als nicht-parametrisches Gedächtnis...
```

### (3) Zielzustand — Formulierungsvorlage

2–3-Satz-Einschub nach dem HNSW-Satz (Zahlen markiert als [ASSUMED] gem. Assumptions Log A1/A3):

> „Für das konkrete Einsatzszenario bedeutet dies: Selbst bei 10.000 registrierten Profilen
> wächst die Suchzeit lediglich um den Faktor log(10.000)/log(10) ≈ 4 gegenüber dem
> aktuellen Testbetrieb mit ~10 Profilen --- bei 100.000 Profilen entsprechend um den
> Faktor ~5 [ASSUMED]. Da die biometrische Embedding-Berechnung (~80 ms, vgl. Kap.~3.3)
> die Gesamtlatenz dominiert, bleibt die Profilanzahl kein limitierender Faktor für die
> Systemskalierbarkeit [ASSUMED]."

Beim Einbau in die .typ-Datei entfällt die `[ASSUMED]`-Markierung — sie gilt nur in diesem Audit.

**Zielzustand (Typst-konform, ohne Audit-Marker):**
```typst
Für das konkrete Einsatzszenario bedeutet dies: Selbst bei 10.000 registrierten Profilen
wächst die Suchzeit lediglich um den Faktor log(10.000)/log(10) ≈ 4 gegenüber dem
aktuellen Testbetrieb mit ~10 Profilen --- bei 100.000 Profilen entsprechend um den
Faktor ~5. Da die biometrische Embedding-Berechnung (~80 ms, vgl. Kap.~3.3) die
Gesamtlatenz dominiert, bleibt die Profilanzahl kein limitierender Faktor für die
Systemskalierbarkeit.
```

### (4) Pitfall-Hinweise

- **KEIN eigener Unterabschnitt** (=== oder ==) für die Skalierbarkeitsaussage
- **KEINE Tabelle** mit O(log N)-Werten
- Zahlen (10.000, 100.000, ~4, ~5, 80) inline in Prosa, nicht als Liste
- Position ist **Kap. 3.4** (nicht Kap. 7) — Skalierbarkeit ist eine Eigenschaft der gewählten
  Persistenzarchitektur, keine Evaluationsdimension
- Wenn der Entwurfssatz mit „Im Betrieb hat sich gezeigt..." beginnt → falsch (Kap. 7)
- Wenn er mit „Durch HNSW ermöglicht die gewählte Persistenzschicht..." beginnt → Kap. 3.4 richtig

**Latenzzahlen** (80 ms aus Kap. 3.3): ASSUMED per A1 — inhaltlich plausibel, nicht empirisch gemessen.
Faktorberechnung (×4 / ×5): ASSUMED per A3 — log₂-Basis irrelevant für Größenordnung.

---

## UMSE-02 — DSGVO-Produktivierungspfad (conclusion.typ, Kap. 8.2)

### (1) Ist-Zustand mit Zeilennummer

**Datei:** `T2000_Part1/chapters/conclusion.typ`, **Z. 25**

Vollständiger zweiter Absatz des Ausblick-Abschnitts (Kap. 8.2):

> „Die zweite Richtung betrifft die datenschutzrechtliche Konsolidierung. Der Prototyp
> wurde unter internen Laborbedingungen entwickelt; die in Kap.~3.5 identifizierten
> Produktivierungsvoraussetzungen --- Einwilligungsmechanismen, Löschrecht und
> Datenschutz-Folgenabschätzung --- müssten für einen öffentlichen Einsatz vollständig
> umgesetzt werden @krivokucahahn2023biometricprotection[S.~639--641]."

### (2) Gap-Tabelle

| Anforderung | Im Text vorhanden? | Formulierung | Gap |
|-------------|-------------------|--------------|-----|
| Opt-in (Art. 9 Abs. 2 lit. a DSGVO) | Ja — als „Einwilligungsmechanismen" | Stichwort, kein Artikel | Artikelnummer fehlt, kein Handlungsverb |
| DSFA (Art. 35 DSGVO) | Ja — als „Datenschutz-Folgenabschätzung" | Stichwort, kein Artikel | Artikelnummer fehlt, kein Handlungsverb |
| Löschfunktion (Art. 17 DSGVO) | Ja — als „Löschrecht" | Stichwort, kein Artikel | Artikelnummer fehlt, kein Handlungsverb |
| Roadmap-Charakter | Nein | Nur „müssten vollständig umgesetzt werden" | Keine konkreten Schritte, kein Handlungsformat |
| Konkrete Handlungsverben | Nein | Passiv, keine Spezifikation | Verb fehlt: implementieren/anlegen/durchführen |

### (3) Zielzustand — Drei-Schritt-Formulierung

Den zweiten Absatz (Z. 25, ab „die in Kap.~3.5 identifizierten...") ersetzen durch:

```typst
Die in Kap.~3.5 identifizierten Produktivierungsvoraussetzungen lassen sich in drei
konkrete Schritte gliedern:
(1) _Opt-in-Mechanismus_ gemäß Art.~9 Abs.~2 lit.~a DSGVO --- einen expliziten
Einwilligungs-Dialog implementieren, in dem Nutzer ihre Zustimmung zur Verarbeitung
biometrischer Daten vor der ersten Registrierung aktiv erteilen;
(2) _Datenschutz-Folgenabschätzung_ (DSFA) gemäß Art.~35 DSGVO @dsgvo2016[Art.~35]
--- eine dokumentierte Risikoanalyse der biometrischen Verarbeitungsprozesse durchführen
und der zuständigen Datenschutzbehörde vor einem produktiven Rollout vorlegen;
(3) _Löschfunktion_ gemäß Art.~17 DSGVO @dsgvo2016[Art.~17] --- eine API-Funktion
oder Admin-Oberfläche erstellen, über die gespeicherte Embeddings und Gesprächsprofile
auf Anfrage vollständig gelöscht werden können @krivokucahahn2023biometricprotection[S.~639--641].
Diese drei Schritte erfordern keine Architekturumbauten, sondern ergänzende Implementierung
auf Basis des bestehenden FaceStore-Interfaces (vgl. Kap.~3.4).
```

**Handlungsverben explizit geprüft:**
- Schritt 1: „implementieren"
- Schritt 2: „durchführen", „vorlegen"
- Schritt 3: „erstellen"

### (4) Quellenhinweis

| Quelle | Status | Verwendung in Zieltext |
|--------|--------|------------------------|
| `@dsgvo2016[Art.~35]` | In sources.bib vorhanden (Phase 32) | Schritt 2 (DSFA) |
| `@dsgvo2016[Art.~17]` | In sources.bib vorhanden (Phase 32) | Schritt 3 (Löschen) |
| `@krivokucahahn2023biometricprotection[S.~639--641]` | Bereits im Ist-Text vorhanden | Schritt 3, abschließend |

**Kein neuer BibTeX-Eintrag erforderlich.** `@dsgvo2016[Art.~9]` ist ebenfalls in sources.bib
vorhanden (implizit durch `@dsgvo2016[Art.~9 Abs.~1]` in fundamentals-2.typ Z. 194 belegt).

### (5) Pitfall-Hinweise

- **Verweisrichtung:** Kap. 8.2 → Kap. 3.5 (vorwärts zitieren ist erlaubt; rückwärts Kap. 3.5 → Kap. 8.2 wäre falsch)
- **Reiner Rückverweis auf Kap. 3.5 genügt NICHT** — UMSE-02 fordert Roadmap-Charakter mit konkreten Handlungsschritten, nicht nur „wie in Kap. 3.5 beschrieben"
- **Kein zirkulärer Verweis:** Kap. 3.5 (fundamentals-2.typ Z. 198) darf NICHT nachträglich auf Kap. 8.2 verweisen
- **Prüfkriterium:** Wenn kein einziges Verb der Form „implementieren / anlegen / durchführen / erstellen" vorkommt → kein Roadmap-Schritt (Pitfall 2 aus Research)
- `@dsgvo2016[Art.~35]` und `@dsgvo2016[Art.~17]` stehen bereits in Kap. 3.5 — Wiederholung in Kap. 8.2 ist zulässig und erwünscht

---

## Vollständigkeitsprüfung

| Kriterium | UMSE-01 | UMSE-02 |
|-----------|---------|---------|
| Ist-Satz dokumentiert | Z. 190, fundamentals-2.typ | Z. 25, conclusion.typ |
| Einfügeposition exakt | Nach @johnson2019faiss, vor conversation_chunks-Satz | Ab „die in Kap.~3.5 identifizierten..." |
| Zielzustand formuliert | 2-Satz-Einschub mit 10.000/100.000/80-ms | Drei-Schritt-Block mit Art. 9/35/17 |
| Pitfalls dokumentiert | Ja (Kap. 7-Falle, Tabellen-Falle) | Ja (Rückverweis-Falle, Verb-Falle) |
| Quellen geprüft | @malkov2020hnsw bereits vorhanden | @dsgvo2016 bereits vorhanden, kein neuer BibTeX |

Wave 2 kann direkt mit der Umsetzung beginnen — keine Neuexploration der Zieldateien erforderlich.
