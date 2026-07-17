# Phase 32: Literaturrecherche — Audit

**Erstellt:** 2026-07-17
**Zweck:** Bestandsaufnahme aller `@misc`-Einträge in sources.bib und exakte Lokalisierung aller relevanten Inline-Zitate in den .typ-Dateien.

---

## @misc-Audit

**Gesamtzahl `@misc`-Einträge:** 12 (verifiziert via `grep -c "@misc{"`)

**Hinweis zu barquero2020longtermtracking:** Dieser Eintrag ist in sources.bib als `@inproceedings` klassifiziert (Zeile 303) — nicht als `@misc`. Er hat `booktitle={International Joint Conference on Biometrics (IJCB)}` und `year={2021}`. Der DOI-Wert ist `10.48550/arXiv.2010.08675` (arXiv-DOI, kein Proceedings-DOI), und `archivePrefix={arXiv}` ist gesetzt. RESEARCH.md erwartete dies als "bereits korrekt als @inproceedings" — Abweichung: der DOI verweist auf arXiv, nicht auf den echten IJCB-DOI (10.1109/IJCB48548.2020.9304892).

### Tabelle: Alle 12 @misc-Einträge

| Key | Zeile | Upgrade-Plan laut RESEARCH.md | Abweichung von RESEARCH.md |
|-----|-------|-------------------------------|----------------------------|
| `bazarevsky2019blazeface` | 53 | Kategorie B — bleibt @misc (arXiv-only, kein Proceedings-Eintrag in DBLP) | Keine Abweichung |
| `lugaresi2019mediapipe` | 64 | Kategorie B — bleibt @misc (arXiv-only, kein Proceedings-Eintrag in DBLP) | Keine Abweichung |
| `cheng2021gazesurvey` | 85 | Kategorie A — Upgrade auf @article: IEEE TPAMI, DOI 10.1109/TPAMI.2024.3393571 | Keine Abweichung |
| `zhang2015mpiigaze` | 96 | Kategorie A — Upgrade auf @inproceedings: CVPR 2015, DOI 10.1109/CVPR.2015.7299081 | Keine Abweichung |
| `radford2021clip` | 107 | Kategorie A — Upgrade auf @inproceedings: ICML 2021 (PMLR vol. 139); kein klassischer DOI | Keine Abweichung |
| `guu2020realm` | 238 | Kategorie A — Upgrade auf @inproceedings: ICML 2020 (PMLR vol. 119); kein klassischer DOI | Keine Abweichung |
| `hogenhout2025biometricprivacy` | 322 | Kategorie B — bleibt @misc (Preprint Okt. 2025, kein Peer-Review-Nachweis); Ersatz durch Krivokuca & Marcel IEEE TIFS 2023 | Keine Abweichung |
| `kellnhofer2019gaze360` | 334 | Kategorie A — Upgrade auf @inproceedings: ICCV 2019, DOI 10.1109/ICCV.2019.00701 | Keine Abweichung |
| `bewley2016sort` | 345 | Kategorie A — Upgrade auf @inproceedings: ICIP 2016, DOI 10.1109/ICIP.2016.7533003 | Keine Abweichung |
| `wojke2017deepsort` | 356 | Kategorie A — Upgrade auf @inproceedings: ICIP 2017, DOI 10.1109/ICIP.2017.8296962 | Keine Abweichung |
| `guo2021scrfd` | 369 | Kategorie B — bleibt @misc (arXiv-only, keine verifizierbaren Proceedings) | Keine Abweichung |
| `zhu2021webface260m` | 380 | Kategorie A — Upgrade auf @inproceedings: CVPR 2021, DOI 10.1109/CVPR46437.2021.01035 | Keine Abweichung |

**Kategorie A (upgrade-pflichtig):** 7 Einträge — `cheng2021gazesurvey`, `zhang2015mpiigaze`, `radford2021clip`, `guu2020realm`, `kellnhofer2019gaze360`, `bewley2016sort`, `wojke2017deepsort`, `zhu2021webface260m`

**Kategorie B (bleibt @misc):** 4 Einträge — `bazarevsky2019blazeface`, `lugaresi2019mediapipe`, `guo2021scrfd`, `hogenhout2025biometricprivacy`

### barquero-Status

`barquero2020longtermtracking` ist **kein @misc**-Eintrag; er steht als `@inproceedings` in sources.bib.

- **Zeile:** 303
- **DOI-Wert (aktuell in sources.bib):** `10.48550/arXiv.2010.08675` (arXiv-DOI)
- **year-Wert:** `2021`
- **booktitle:** `International Joint Conference on Biometrics (IJCB)`
- **Abweichung:** Der DOI verweist auf arXiv statt auf den echten Proceedings-DOI `10.1109/IJCB48548.2020.9304892`. Der echte IJCB-Eintrag hat `year=2020` (Konferenz Oktober 2020), sources.bib hat `year=2021`. RESEARCH.md nahm an, der Eintrag sei vollständig korrekt — tatsächlich hat er den arXiv-DOI und ein falsches Jahr.

---

## Inline-Zitat-Audit

### DSGVO-Klammertexte

Alle `[DSGVO ...]`-Klammertexte in den Kapiteldateien — diese sind **keine Typst-`@`-Referenzen** und werden in sources.bib nicht aufgelöst.

| Datei | Zeile | Exakter String |
|-------|-------|----------------|
| `T2000_Part1/chapters/fundamentals-2.typ` | 166 | `[DSGVO 2016, Art.~9 Abs.~1]` |
| `T2000_Part1/chapters/fundamentals-2.typ` | 170 | `[DSGVO 2016, Art.~17]` |
| `T2000_Part1/chapters/fundamentals-2.typ` | 170 | `[DSGVO 2016, Art.~35]` |

**Befund:** Exakt 3 Vorkommen in einer einzigen Datei (fundamentals-2.typ). Deckt sich mit RESEARCH.md (Zeilen 166 und 170). Alle drei sind auf Zeile 166 bzw. Zeile 170 konzentriert.

**Vollständiger Satzkontext Zeile 166:**
> Gesichtsembeddings sind biometrische Daten im Sinne des Art.~9 Abs.~1 der DSGVO, da sie aus natürlichen Personen abgeleitet werden und zur eindeutigen Identifikation geeignet sind **[DSGVO 2016, Art.~9 Abs.~1]**.

**Vollständiger Satzkontext Zeile 170 (beide Klammertexte):**
> Für ein reales Kundensystem wären zusätzliche Maßnahmen erforderlich: ein explizites Opt-in-Verfahren gemäß Art.~9 Abs.~2 lit.~a DSGVO, das Recht auf Löschung gespeicherter Embeddings nach Art.~17 DSGVO **[DSGVO 2016, Art.~17]** sowie eine Datenschutz-Folgenabschätzung gemäß Art.~35 DSGVO **[DSGVO 2016, Art.~35]** für Hochrisiko-Verarbeitungen biometrischer Daten.

### hogenhout-Zitate

RESEARCH.md erwartete 2 Vorkommen — tatsächlich sind es **3 Vorkommen** in 3 verschiedenen Dateien.

| Datei | Zeile | Exakter Zitier-Ausdruck |
|-------|-------|------------------------|
| `T2000_Part1/chapters/fundamentals-2.typ` | 166 | `@hogenhout2025biometricprivacy[S.~2--4]` |
| `T2000_Part1/chapters/conclusion.typ` | 25 | `@hogenhout2025biometricprivacy[S.~2--4]` |
| `T2000_Part1/chapters/practical-2.typ` | 94 | `@hogenhout2025biometricprivacy[S.~2--4]` |

**Abweichung von RESEARCH.md:** RESEARCH.md dokumentierte 2 hogenhout-Stellen (fundamentals-2.typ:166 und conclusion.typ:25). Tatsächlich gibt es ein drittes Vorkommen in `practical-2.typ` Zeile 94. Wave 2 muss alle drei Stellen bei einem hogenhout-Ersatz/Ergänzung berücksichtigen.

**Satzkontext fundamentals-2.typ:166:**
> Die Verarbeitung solcher Daten besonderer Kategorie unterliegt einem strengen Rechtsrahmen, der die Identifizierbarkeit betroffener Personen als zentrales Schutzgut anerkennt `@voigt2017gdpr[S.~114--120]`, `@hogenhout2025biometricprivacy[S.~2--4]`.

**Satzkontext conclusion.typ:25:**
> Die zweite Richtung betrifft die datenschutzrechtliche Konsolidierung. [...] die in Kap.~3.5 identifizierten Produktivierungsvoraussetzungen --- Einwilligungsmechanismen, Löschrecht und Datenschutz-Folgenabschätzung --- müssten für einen öffentlichen Einsatz vollständig umgesetzt werden `@hogenhout2025biometricprivacy[S.~2--4]`.

**Satzkontext practical-2.typ:94:**
> Die History-Isolation verhindert Cross-Contamination zwischen Nutzerprofilen: [...] die datenschutzrechtliche Zuordnung biometrischer Fakten zu Einzelpersonen bleibt auf eindeutig identifizierbare Einzel-Sessions beschränkt `@hogenhout2025biometricprivacy[S.~2--4]` (vgl. Kap.~3.5 für die datenschutzrechtliche Rahmenbewertung).

### VLM/Gaze-Einzitierstellen

#### radford2021clip (CLIP) — Einzitierstelle

| Datei | Zeile | Kontext |
|-------|-------|---------|
| `T2000_Part1/chapters/fundamentals-1.typ` | 19 | Abschnitt 2.1.2 "Interaktionsvalidierung durch Vision-LLM" |

**Vollständiger Satz:**
> CLIP `@radford2021clip[S.~1--3]` hat gezeigt, dass visuelle und sprachliche Repräsentationen gemeinsam gelernt werden können; instruktionsgesteuerte Modelle wie Gemini bauen auf diesem Prinzip auf und erlauben darüber hinaus direkte Aufgabenformulierung per Prompt.

#### kellnhofer2019gaze360 (Gaze360) — Einzitierstelle

| Datei | Zeile | Kontext |
|-------|-------|---------|
| `T2000_Part1/chapters/methodology.typ` | 50 | Abschnitt 4.2 "Gaze-Validierung via Vision-LLM" |

**Vollständiger Satz:**
> Die Begründung für den Einsatz des Vision-LLM statt klassischer Gaze-Estimation ist in Kap.~3.2 und Kap.~2.1.2 ausgeführt `@zhang2015mpiigaze[S.~1--2]`, `@kellnhofer2019gaze360[S.~1]`.

**Befund VLM/Gaze:** `radford2021clip` und `kellnhofer2019gaze360` sind bereits im Text eingezitiert. Beide sind Kategorie-A-Einträge (upgrade-pflichtig). Für LITR-03 (≥2 peer-reviewed VLM/Gaze-Quellen) müssen die neuen Einträge CLIP-Gaze (AAAI 2024) und LG-Gaze (ECCV 2024) zusätzlich eingefügt werden — entweder neben oder als Ergänzung zu den bestehenden Zitaten an diesen Stellen.

---

## Zusammenfassung der Abweichungen gegenüber RESEARCH.md

| Nr. | Befund | Auswirkung auf Wave 2 |
|-----|--------|-----------------------|
| 1 | `barquero2020longtermtracking` ist bereits `@inproceedings`, hat aber arXiv-DOI (`10.48550/arXiv.2010.08675`) statt IJCB-DOI (`10.1109/IJCB48548.2020.9304892`) und `year=2021` statt `year=2020` | DOI und year korrigieren (falls im Wave-2-Scope) |
| 2 | hogenhout: 3 Vorkommen statt 2 — practical-2.typ:94 war nicht in RESEARCH.md dokumentiert | Wave 2 muss practical-2.typ:94 beim Ersatz einbeziehen |
| 3 | Alle anderen @misc-Zählungen und Zeilennummern stimmen mit RESEARCH.md überein | Keine weiteren Anpassungen nötig |
