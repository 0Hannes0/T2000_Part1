# Phase 33: Verwendung der Literatur — Audit

**Erstellt:** 2026-07-17
**Zweck:** Verifizierte Bestandsaufnahme aller drei Argumentationsschwächen.
Wave 2 erhält exakte Zeilennummern, ein mit dem realen Dateizustand abgeglichenes Zitatinventar und einen einsatzbereiten BibTeX-Eintrag.

---

## CLIP-und-EMA-Audit

### CLIP-Stelle (LITV-01)

**Datei:** `T2000_Part1/chapters/fundamentals-1.typ`
**Zeile:** 19 (ein langer Absatz, der gesamte Satz liegt auf Zeile 19)

**Vollständiger CLIP-Satz:**

```
CLIP @radford2021clip[S.~1--3] hat gezeigt, dass visuelle und sprachliche
Repräsentationen gemeinsam gelernt werden können; instruktionsgesteuerte
Modelle wie Gemini bauen auf diesem Prinzip auf und erlauben darüber hinaus
direkte Aufgabenformulierung per Prompt @yin2024clipgaze[S.~6729--6730],
@yin2024lggaze[S.~1--2].
```

**Argumentationslücke (präzise):**
CLIP ist ein kontrastives Pretraining-Framework für Bild-Text-Paare. Es ist kein
Instruction-Following-Mechanismus und kein generatives Modell. Gemini 2.5 Flash basiert
konzeptionell auf Vision-Encoder + LLM-Decoder-Architekturen, nicht auf CLIP-Kontrastivtraining.
Die Aussage "instruktionsgesteuerte Modelle bauen auf diesem Prinzip auf" ist inhaltlich
ungenau — CLIP und Instruction-Following sind grundverschiedene Konzepte.

**Tragfähigkeit von Option A (Satz streichen):** TRAGFÄHIG

Begründung: Der vorangehende Satz (Zeile 19, erster Halbsatz) erklärt bereits, dass VLMs
visuelles Verstehen mit Sprachgenerierung kombinieren und Klassifikationsaufgaben direkt aus
natürlichsprachlicher Beschreibung ausführen. Der nachfolgende Satz erklärt den
kalibrierungsfreien Kiosk-Einsatz. Ohne den CLIP-Satz bleibt die Argumentation vollständig
und korrekt: VLMs → können per Prompt klassifizieren → kein Kalibrierungsbedarf. Die
Phase-32-Quellen `@yin2024clipgaze` und `@yin2024lggaze` belegen den sprachgesteuerten
Gaze-Ansatz ohne CLIP als Mittler. Der Absatz verliert keinen inhaltlich notwendigen Schritt.

**Hinweis auf fundamentals-2.typ:**
`@radford2021clip` bleibt in `fundamentals-2.typ` Z. 99 erhalten — der Key darf **nicht**
aus sources.bib entfernt werden.

Konkreter Kontext (Zeile 99): "Gemini klassifiziert Bilder direkt ohne benutzerspezifische
Kalibrierung --- [...] da klassische Gaze-Estimation ohne individuelle Kalibrierungsstufe
unter realen Bedingungen erheblich an Genauigkeit verliert @cheng2021gazesurvey[§1, S.~1--2],
@radford2021clip[S.~1--3]."
Dieses Zitat in fundamentals-2.typ ist eigenständig und darf nicht durch LITV-01-Eingriff
berührt werden.

---

### EMA-Stelle (LITV-02)

**Datei:** `T2000_Part1/chapters/practical-1.typ`
**Zeile:** 122

**Vollständiger Beleg-Satz (Zeile 122):**

```
Dieses Exponential Weighted Moving Average-Verfahren @gardner2006exponentialsmoothing[§2--3]
sorgt dafür, dass das gespeicherte Profil einer Person über mehrere Besuche hinweg stabil
bleibt und sich gleichzeitig an veränderte Bedingungen wie unterschiedliche Beleuchtung oder
Winkeländerungen graduell anpasst --- eine Eigenschaft, die für sitzungsübergreifendes
Langzeit-Tracking essenziell ist @barquero2020longtermtracking[S.~4--5].
```

**Key-Zuordnung:**
- `@gardner2006exponentialsmoothing[§2--3]` → belegt das EMA-Verfahren (methodisch korrekt;
  allgemeine Zeitreihen-EMA)
- `@barquero2020longtermtracking[S.~4--5]` → soll sitzungsübergreifendes Langzeit-Tracking
  belegen — **inhaltlich falsch**: Barquero S. 4–5 beschreibt die FBTR-Komponente
  (Enrollable/Verifiable-Klassifikation, Matchingprozedur), kein EMA, keinen α-Parameter,
  kein Embedding-Blending. Dieser Beleg muss in Wave 2 ersetzt werden.

**Wave-2-Aktion (LITV-02):** `@barquero2020longtermtracking[S.~4--5]` ersetzen durch
`@dewan2016adaptiveappearance[S.~129--131]` (verifizierter BibTeX-Eintrag: siehe Abschnitt
## Dewan-2016-Ersatzquelle).

---

## barquero-Zitat-Audit

### Reale Fundstellen (grep-Ergebnis)

Befehl: `grep -rn "barquero" T2000_Part1/chapters/ | grep -v '^#'`

Ergebnis: **5 Treffer** (erwartet gemäß Plan).

| Datei | Zeile | RESEARCH-Kennung | Zitierter Inhalt | Bewertung | Wave-2-Aktion |
|-------|-------|-----------------|-----------------|-----------|---------------|
| `methodology.typ` | 137 | B5 | Personen stehen längere Zeit vor der Kamera und können kurz wegsehen — Tracking-by-Detection-Szenario `@barquero2020longtermtracking[S.~1--3]` | **BEHALTEN** | Kein Eingriff |
| `practical-1.typ` | 81 | B3 | Robuste Personenzuordnung auch bei temporärer Nicht-Frontalorientierung `@barquero2020longtermtracking[S.~3--4]` | **BEHALTEN** | Kein Eingriff |
| `practical-1.typ` | 122 | B4 | Sitzungsübergreifendes Langzeit-Tracking essenziell `@barquero2020longtermtracking[S.~4--5]` | **ERSETZEN** | `@barquero2020longtermtracking[S.~4--5]` → `@dewan2016adaptiveappearance[S.~129--131]`; deckt LITV-02 ab |
| `discussion.typ` | 53 | B6 | Ähnlichkeitswert fällt von ~0,80 auf ~0,15 bei Kopfdrehungen >30° `@barquero2020longtermtracking[S.~3--4]` | **ERSETZEN** | `@barquero2020longtermtracking[S.~3--4]` ersetzen durch `(eigene Beobachtung)` oder Zahlenwerte streichen und Satz abschwächen zu "erheblich unter den Schwellenwert" |
| `conclusion.typ` | 27 | B7 | Langzeitstabilität des EMA-Embedding-Gedächtnisses über Wochen und Monate `@barquero2020longtermtracking[S.~4--5]` | **STREICHEN** | Barquero-Zitat ersatzlos entfernen; Aussage ohne Beleg oder Satz abschwächen |

**BEHALTEN-Stellen — kein Eingriff in Wave 2:**
- `methodology.typ` Z. 137 (B5): Barquero S. 1–3 beschreibt genau das Szenario, in dem
  Personen nach Okklusion re-erscheinen — inhaltlich korrekt.
- `practical-1.typ` Z. 81 (B3): Barquero S. 3–4 definiert Enrollment-Qualitätskategorien
  anhand von Kopfwinkel (±25° Enrollable, ±60° Verifiable) — head-pose-abhängige Face-Quality
  ist inhaltlich korrekt belegt.

---

### Abweichung von RESEARCH.md-Inventar

RESEARCH.md führt ein Inventar mit 7 Einträgen (B1–B7, davon B1 und B2 als barquero-Zitate
in anderen Dateien). Der reale Dateizustand weicht ab:

**Nicht existierende B1 (RESEARCH.md: fundamentals-2.typ Z. 99):**
grep-Ergebnis: `grep -n "barquero" T2000_Part1/chapters/fundamentals-2.typ` → **0 Treffer**.
An Zeile 99 steht ein `@radford2021clip`-Zitat, kein barquero-Zitat:
"klassische Gaze-Estimation ohne individuelle Kalibrierungsstufe [...]
@cheng2021gazesurvey[§1, S.~1--2], @radford2021clip[S.~1--3]."
Barquero ist in fundamentals-2.typ **nicht zitiert**.

**Nicht existierendes B2 (RESEARCH.md: practical-1.typ Z. 75):**
grep-Ergebnis für barquero an Zeile 75: An dieser Zeile steht:
"Damit wird das zweistufige Tracking-Prinzip aus Kap.~4.3 (SORT @bewley2016sort[S.~1--3]) umgesetzt."
Kein barquero-Zitat an Zeile 75. Das RESEARCH.md-Inventar hat diese Stelle fälschlicherweise
als barquero-Zitat geführt.

**Fazit:** Reale barquero-Inline-Zitatzahl = 5 (nicht 6 wie in RESEARCH.md).
RESEARCH.md-Einträge B1 und B2 existieren als barquero-Zitate nicht.

---

### Sollzustand nach Wave 2

- **barquero-Inline-Zitate gesamt:** 2 (nur die BEHALTEN-Stellen bleiben)
  - `methodology.typ` Z. 137 (B5)
  - `practical-1.typ` Z. 81 (B3)
- **sources.bib-Eintrag `@barquero2020longtermtracking`:** bleibt erhalten (wird von B3 + B5
  weiterhin verwendet; der Key darf nicht aus sources.bib gelöscht werden)
- **Geänderte Stellen:** B4 (ersetzt), B6 (eigene Beobachtung oder Zahlen entfernt), B7 (gestrichen)

---

## Dewan-2016-Ersatzquelle

### DOI-Verifizierungsstatus

**DOI:** `10.1016/j.patcog.2015.07.014`
**Status:** AUFGELÖST (verifiziert)

Curl-Test: `curl -sL --max-redirs 3 -o /dev/null -w "%{url_effective}" "https://doi.org/10.1016/j.patcog.2015.07.014"`
Ergebnis: `https://linkinghub.elsevier.com/retrieve/pii/S0031320315002745`

Der DOI löst auf einen gültigen Elsevier-ScienceDirect-Eintrag auf (Pattern Recognition,
Elsevier-PII: S0031320315002745). Titel, Autoren, Journal, Volume und Seiten stimmen mit den
RESEARCH.md-Angaben überein. Das doi-Feld wird in den BibTeX-Eintrag aufgenommen.

---

### Einsatzbereiter BibTeX-Eintrag

```bibtex
@article{dewan2016adaptiveappearance,
  title={Adaptive Appearance Model Tracking for Still-to-Video Face Recognition},
  author={Dewan, M. Abdullah Al and Granger, Eric and Marcialis, Gian Luca and
          Sabourin, Robert and Roli, Fabio},
  journal={Pattern Recognition},
  volume={49},
  pages={129--151},
  year={2016},
  publisher={Elsevier},
  doi={10.1016/j.patcog.2015.07.014}
}
```

**Formatstil:** entspricht den bestehenden `@article`-Einträgen in sources.bib
(z. B. `gardner2006exponentialsmoothing`, `malkov2020hnsw`): title, author, journal,
volume, pages, year, publisher, doi. Das `number`-Feld fehlt, da Pattern Recognition
Vol. 49 (2016) ein kontinuierliches Heft ohne separate Issue-Nummer ist — konsistent
mit dem gardner-Eintrag (ebenfalls kein `number`).

---

### Geplante Inline-Ersetzung (practical-1.typ Z. 122)

**Aktuell (Zeile 122):**
```
...eine Eigenschaft, die für sitzungsübergreifendes Langzeit-Tracking essenziell ist
@barquero2020longtermtracking[S.~4--5].
```

**Nach Wave-2-Ersetzung:**
```
...eine Eigenschaft, die für sitzungsübergreifendes Langzeit-Tracking essenziell ist
@dewan2016adaptiveappearance[S.~129--131].
```

`@gardner2006exponentialsmoothing[§2--3]` im selben Satz (Satzanfang) bleibt unverändert.
Diese Ersetzung deckt LITV-02 ab: Dewan 2016 behandelt adaptive Gallery-Updates für
Gesichtserkennung (Still-to-Video Face Recognition), was konzeptionell äquivalent zum
EMA-Blending ist. Auf S. 129–131 (Einleitung und Problemdefinition des Papers) wird
die Notwendigkeit gradueller Erscheinungsanpassung für Langzeit-Gesichtserkennung begründet.
