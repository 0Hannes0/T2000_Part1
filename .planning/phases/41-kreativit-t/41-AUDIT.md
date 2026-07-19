# Phase 41: Kreativität — Audit

**Erstellt:** 2026-07-19
**Grundlage:** Direkter Dateiread von conclusion.typ, fundamentals-2.typ, methodology.typ, practical-2.typ, sources.bib
**Zweck:** Wave 2 (41-02) kann ohne weitere Recherche exakt formulieren — alle Einfügepositionen, Schlüsselbegriff-Status und Substanzpunkte sind hier abschließend dokumentiert.

---

## KREA-01 — Einfügeposition in conclusion.typ

**Zieldatei:** `T2000_Part1/chapters/conclusion.typ`

**Einfügepunkt:** Nach Zeile 15 (Ende des Integrations-Beitrags-Absatzes), vor Zeile 17 (Beginn des Evaluationsvorbehalt-Absatzes). Zwischen den beiden Absätzen steht aktuell eine Leerzeile (Z. 16); der neue Absatz ersetzt diese Leerzeile (Typst: Leerzeile als Absatz-Trenner).

**Letzter Satz des Anker-Absatzes (Z. 15) — wörtliches Zitat:**
> „Die architektonische Entkopplung über Microservices und das FaceStore-Interface hält diese Lösung zugleich für andere Einsatzkontexte offen."

**Erster Satz des Folge-Absatzes (Z. 17) — wörtliches Zitat:**
> „Diese Antwort steht unter dem Vorbehalt ihrer Evaluationsbasis: Die Ergebnisse stützen sich auf Literatur-Benchmarks und Beobachtungen aus dem Entwicklungsbetrieb, nicht auf eine kontrollierte Probandenstudie."

**Grenzmarkierung Kap. 8.1 / 8.2:** Der neue Absatz gehört in den `== Fazit`-Block (Kap. 8.1). Die Grenze ist das Heading `== Ausblick` in Z. 19. Der neue Absatz muss VOR Z. 19 stehen. NICHT in `== Ausblick` (Kap. 8.2 ab Z. 19) einfügen.

**Verifikation Struktur:** conclusion.typ enthält exakt die erwartete Struktur:
- Z. 1: `= Fazit und Ausblick`
- Z. 3: `== Fazit`
- Z. 15: Ende Integrations-Absatz — **← Einfügen nach dieser Zeile**
- Z. 17: Evaluationsvorbehalt-Absatz
- Z. 19: `== Ausblick` — Grenze; KREA-01 muss vor dieser Zeile stehen

---

## KREA-01 — Schlüsselbegriff-Baseline

**Befehl ausgeführt:** `grep -n "kalibrierungsfrei\|spekulativ\|dreikanali" T2000_Part1/chapters/conclusion.typ`

**Ergebnis:** Kein Treffer (Exit-Code 1, leere Ausgabe).

**Dokumentierter Vorher-Zustand (Baseline):**
- `kalibrierungsfrei` — 0 Treffer in conclusion.typ
- `spekulativ` — 0 Treffer in conclusion.typ
- `dreikanali` (Präfix für dreikanalig/dreikanaligen/…) — 0 Treffer in conclusion.typ

**Bedeutung für Wave 3:** Wave 3 prüft, ob nach Wave 2 alle drei Begriffe in conclusion.typ vorhanden sind. Jeder der drei Treffer wäre ein neu eingeführter Begriff (kein Vorher-Zustand vorhanden).

---

## KREA-01 — Substanzpunkte (drei originelle Beiträge)

Alle drei Fakten wurden gegen die Quelldateien geprüft und als korrekt verifiziert.

| Beitrag | Pflicht-Schlüsselbegriff | Kernaussage (belegter Fakt) | Quellort im Dokument |
|---------|--------------------------|------------------------------|----------------------|
| Vision-LLM als kalibrierungsfreie Interaktionsvalidierung | „kalibrierungsfrei" | Gemini 2.5 Flash klassifiziert Blickkontakt zero-shot ohne benutzerspezifische Kalibrierung — für öffentliche Kioske mit wechselnden Nutzern strukturell notwendig | fundamentals-2.typ Z. 127, letzter Satz im Abschnitt Kap. 3.2 |
| Spekulatives Pre-Computing der Begrüßung | „spekulativ" | Begrüßung wird parallel zum Gaze-Check erzeugt (nicht danach); bei Gaze-Pass wird sie mit `GREETING_WAIT_SECS` = 1,5 s eingesammelt, bei Gaze-Fail verworfen | methodology.typ Z. 103–104 (Kap. 4.3) |
| Dreikanaliges Gedächtnisdesign (summary / facts\_sentences / facts) | „dreikanali" | Drei getrennte Persistenzkanäle: kompakter Sitzungskontext (`summary`), semantisch retrieval-fähige Einzelfakten (`facts_sentences`), stabile Kerndaten ohne Suchlatenz (`facts`) | practical-2.typ Z. 11 (Beschreibung), Z. 22–27 (Tabelle Tab. 6.1, Kap. 6.1) |

**Verifizierte Fakten gegen Quelldateien:**

1. **Vision-LLM / kalibrierungsfrei:** fundamentals-2.typ Z. 127 bestätigt: „Gemini klassifiziert Bilder direkt ohne benutzerspezifische Kalibrierung --- für einen öffentlichen Kiosk mit wechselnden Personen ist das entscheidend, da klassische Gaze-Estimation ohne individuelle Kalibrierungsstufe unter realen Bedingungen erheblich an Genauigkeit verliert." — Fakt korrekt.

2. **Spekulatives Pre-Computing / spekulativ:** methodology.typ Z. 103 bestätigt: „Diese Begrüßung wird damit spekulativ erzeugt, während der Gaze-Check noch läuft." Z. 104: „Gibt sie True zurück, wird der Zustand auf ACTIVE gesetzt; der bereits generierte Begrüßungstext wird mit einem Timeout von `GREETING_WAIT_SECS` = 1,5 s eingesammelt." — Fakt korrekt, GREETING_WAIT_SECS = 1,5 s bestätigt.

3. **Dreikanaliges Gedächtnis / dreikanali:** practical-2.typ Z. 11 bestätigt: „Das System persistiert Sitzungsinformationen in drei strukturell getrennten Kanälen, die sich in Granularität und Abrufpfad unterscheiden." Tabelle Tab. 6.1 (Z. 22–27) listet summary, facts\_sentences, facts. — Fakt korrekt.

---

## KREA-02 — Einfügeposition in fundamentals-2.typ

**Zieldatei:** `T2000_Part1/chapters/fundamentals-2.typ`

**Einfügepunkt:** Nach Zeile 127 (letzter Satz des bestehenden Kalibrierungs-Abschnitts in Kap. 3.2), innerhalb des laufenden Textes von `== Auswahl des Detektionsansatzes` (Kap. 3.2).

**Anker-Satz (Z. 127) — wörtliches Zitat:**
> „Als zweite Filterschicht wird Blickkontakt per Vision-LLM (Gemini 2.5 Flash) validiert, um auch frontal detektierte, aber nicht aktiv interagierende Personen herauszufiltern. Gemini klassifiziert Bilder direkt ohne benutzerspezifische Kalibrierung --- für einen öffentlichen Kiosk mit wechselnden Personen ist das entscheidend, da klassische Gaze-Estimation ohne individuelle Kalibrierungsstufe unter realen Bedingungen erheblich an Genauigkeit verliert @cheng2021gazesurvey[§1, S.~1--2], @radford2021clip[S.~1--3]."

**Nächstes Heading (Z. 129) — wörtliches Zitat:**
> `== Auswahl des Erkennungsmodells`

**Kritische Einschränkung:** KEIN neues `===`-Subsection-Heading anlegen. Der neue Absatz gehört DIREKT in den Fließtext von Kap. 3.2, zwischen Z. 127 und Z. 129. Querverweise aus anderen Kapiteln referenzieren „Kap.~3.2" als ganzen Abschnitt — ein neues Heading würde die Struktur zerstören.

**Bereits vorhandene und verwendbare Zitierschlüssel:**
- `@cheng2021gazesurvey` — Kalibrierungsaufwand klassischer Gaze-Estimation (bereits Z. 127 genutzt)
- `@kellnhofer2019gaze360` — Gaze360-Klasse, geometrische Gaze-Estimation (in sources.bib vorhanden: Z. 388)
- `@yin2024clipgaze` — VLM-basierte Gaze-Alternative (in sources.bib vorhanden: Z. 99)

**Hinweis:** @kellnhofer2019gaze360 und @yin2024clipgaze sind in sources.bib vorhanden, werden aber in fundamentals-2.typ aktuell NICHT zitiert (grep ergab keinen Treffer). Sie können für den neuen Absatz verwendet werden — Typst wird sie automatisch ins Literaturverzeichnis aufnehmen.

---

## KREA-02 — Kontrastierungs-Substanz (Dreischritt)

Angelehnt an das YOLO-Verwerfungsmuster (fundamentals-2.typ Z. 123, Dreischritt: naive Alternative → Nachteil → Mehrwert):

**Baustein 1 — Naive Alternative:**
Klassische Gaze-Estimation mit geometrischem 3D-Kopfposen-Modell und individueller Kalibrierung pro Nutzer (Verfahren der MPIIGaze-Klasse @zhang2015mpiigaze und Gaze360-Klasse @kellnhofer2019gaze360).

**Baustein 2 — Konkreter Nachteil im Kiosk-Kontext:**
Kalibrierung setzt bekannte, kooperative Nutzer voraus, die eine Kalibrierungssitzung absolvieren. Öffentliche Kioske haben wechselnde, unbekannte Personen, für die keine individuelle Kalibrierungssitzung möglich ist — der Ansatz ist im Kiosk-Kontext strukturell nicht einsetzbar.

**Baustein 3 — Mehrwert des gewählten Ansatzes:**
Vision-LLM (Gemini 2.5 Flash) liefert zero-shot Frontalitätserkennung: kein Kalibrierungsaufwand, keine nutzerspezifische Vorarbeit, trotzdem zuverlässige Interaktionsvalidierung @yin2024clipgaze.

---

## Compile-Baseline

**Befehl ausgeführt:** `cd T2000_Part1 && typst compile template.typ /tmp/t2000_baseline.pdf 2>&1 | grep -c "^error:"`

**Ergebnis:** `1` (ein Fehler)

**Genaue Fehlermeldung:**
```
error: pagebreaks are not allowed inside of containers
```

**Lokalisation (aus STATE.md):** `template.typ:45`, bekannter pagebreak-in-container-Fehler, dokumentiert in STATE.md als vorbestehender Fehler.

**Bedeutung für Wave 3:** Baseline = 1 Fehler. Wave 3 prüft, dass nach Wave 2 weiterhin genau 1 Fehler (derselbe) vorliegt und kein neuer Fehler eingeführt wurde. Wenn die Fehlerzahl nach Wave 2 > 1 ist, hat Wave 2 einen neuen Fehler eingeführt.

---

## Befund und Wave-2-Handlungsanweisung

### (a) KREA-01-Absatz noch nicht vorhanden?
**Ja** — kein der drei Schlüsselbegriffe (kalibrierungsfrei, spekulativ, dreikanali) ist in conclusion.typ vorhanden. Der Originalitäts-Absatz fehlt vollständig.

### (b) KREA-02-Passage noch nicht vorhanden?
**Ja** — Kap. 3.2 enthält in Z. 127 lediglich einen eingebetteten Parenthese-Kontrast. Eine eigenständige Kontrastierungs-Passage mit Dreischritt (naive Alternative / Nachteil / Mehrwert) fehlt.

### (c) Exakte Einfügezeilen

| Anforderung | Datei | Einfügen nach Zeile | Einfügen vor Zeile |
|-------------|-------|---------------------|---------------------|
| KREA-01 | `T2000_Part1/chapters/conclusion.typ` | Z. 15 | Z. 17 (Evaluationsvorbehalt) |
| KREA-02 | `T2000_Part1/chapters/fundamentals-2.typ` | Z. 127 | Z. 129 (`== Auswahl des Erkennungsmodells`) |

### (d) Compile-Baseline-Fehleranzahl als Referenzwert für Wave 3

**Baseline: 1 Fehler** — `error: pagebreaks are not allowed inside of containers` (template.typ, vorbestehend, nicht durch Phase 41 verursacht). Wave 3 prüft gegen diesen Wert.

---

## Hinweise für Wave 2 (41-02)

1. **KREA-01:** Einfügen nach Z. 15 in conclusion.typ. Pflichtbegriffe: `kalibrierungsfrei`, `spekulativ`, `dreikanali*`. Keine Quellen erforderlich — Selbstbeschreibung eigener Designentscheidungen.
2. **KREA-02:** Einfügen nach Z. 127 in fundamentals-2.typ. Mindestens drei Sätze. Kein neues Heading. Verfügbare Zitierkeys: `@cheng2021gazesurvey`, `@kellnhofer2019gaze360`, `@yin2024clipgaze`.
3. **Compile-Check:** Nach Wave 2 muss `typst compile` weiterhin genau 1 Fehler ergeben (der pagebreak-Fehler). Kein neuer Fehler darf eingeführt werden.
