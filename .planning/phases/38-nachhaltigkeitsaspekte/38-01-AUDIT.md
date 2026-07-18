# 38-01-AUDIT.md — Bestandsaufnahme Phase 38: Nachhaltigkeitsaspekte

**Erstellt:** 2026-07-18
**Zweck:** Wave-2-Executor-Grundlage — kein weiteres Dateilesen erforderlich.

---

## Einfügeposition Kap. 3.7 (NACH-01)

**Datei:** `T2000_Part1/chapters/fundamentals-2.typ`

**Dateilänge:** 229 Zeilen (kein trailing newline nach Z. 229).

**Letzter Satz der Datei (Z. 229):**
```
Damit vermeidet der Prototyp Cloud-API-Kosten von ca.~\$0,90~(AWS~Rekognition) bzw.~\$1,35~(Azure~Face~API) pro Monat allein für die biometrische Identifikation --- bei zehn Kiosk-Standorten entspräche das \$9 bzw.~\$13,50 monatlich.
```

**Kontext: Zeile davor (Z. 227 — Tabellenreferenz):**
```
) <tab:kostenvergleich>
```

**Abschnittsnummerierung — Zählung aller `==`-Überschriften:**

| Reihenfolge | Zeilennr. | Überschrift | Kap.-Nr. |
|-------------|-----------|-------------|----------|
| 1 | Z. 6 | `== Gesamtarchitektur und Systemüberblick` | 3.1 |
| 2 | Z. 98 | `== Auswahl des Detektionsansatzes` | 3.2 |
| 3 | Z. 129 | `== Auswahl des Erkennungsmodells` | 3.3 |
| 4 | Z. 165 | `== Auswahl der Persistenzschicht` | 3.4 |
| 5 | Z. 192 | `== Datenschutz und biometrische Daten` | 3.5 |
| 6 | Z. 200 | `== Wirtschaftliche Bewertung` | 3.6 |
| **7** | **Z. 230 (append)** | **`== Nachhaltigkeitsaspekte` [FEHLT]** | **3.7** |

**Bestätigung:** `== Wirtschaftliche Bewertung` ist der sechste `==`-Abschnitt. Der nächste `==`-Abschnitt erhält automatisch die Nummer 3.7. Korrekt.

**Einfügemodus:** Append nach letzter Zeile (Z. 229). Kein `#pagebreak()` erforderlich — Typst umbricht automatisch. Zwei Leerzeilen als Trenner vor `== Nachhaltigkeitsaspekte` einfügen (Konvention des bestehenden Dokuments).

---

## Einfügeposition Kap. 7.1 (NACH-02)

**Datei:** `T2000_Part1/chapters/discussion.typ`

**Abschnitt `== Erkennungsgenauigkeit`:** beginnt Z. 7, endet vor `== Systemlatenz` (Z. 29).

**Exakter Wortlaut des letzten Satzes dieses Abschnitts (Z. 26–27, ein mehrzeiliger Satz):**
```typst
Dass ArcFace-basierte Modelle je nach Trainingsdatensatz demographisch unterschiedliche
Fehlerraten aufweisen können @buolamwini2018gendershades[S.~2--7], ist für einen internen Prototyp
hinnehmbar, wäre für einen öffentlichen Einsatz aber zu evaluieren.
```

**Hinweis:** Im gelesenen Dateiinhalt liegt dieser Satz auf einer einzigen Zeile (Z. 27). Der vorausgehende Text (Z. 20–26) bildet einen einzigen Absatz, der mit dem Buolamwini-Satz endet.

**Abschnittsüberschrift:** `== Erkennungsgenauigkeit` (Z. 7).

**Ist Z. 27 der letzte Satz des Abschnitts `== Erkennungsgenauigkeit`?** JA.
- Nach Z. 27 folgt eine Leerzeile.
- Danach beginnt `== Systemlatenz` (Z. 29).
- Der Abschnitt endet damit exakt mit dem Buolamwini-Satz.

**Art der Änderung für NACH-02:** Den bestehenden Satz (Z. 27) durch eine erweiterte Formulierung ersetzen. Kein neuer Absatz — der neue Text schließt den Abschnitt weiterhin ab.

---

## BibTeX-Status (NACH-02 Kriterium 3)

**Schlüssel:** `buolamwini2018gendershades`

**Fundstelle:** `T2000_Part1/user/sources.bib` Z. 333–341

**Vollständiger Eintrag:**
```bibtex
@article{buolamwini2018gendershades,
  title={Gender Shades: Intersectional Accuracy Disparities in Commercial Gender Classification},
  author={Buolamwini, Joy and Gebru, Timnit},
  journal={Proceedings of Machine Learning Research},
  volume={81},
  pages={1--15},
  year={2018},
  publisher={PMLR}
}
```

**Bewertung:** Eintrag vorhanden und formal korrekt (Pflichtfelder title, author, journal, volume, pages, year, publisher alle gesetzt). **Keine Aktion für Wave 2 erforderlich.**

---

## Wiederverwendbare Fakten für Kap. 3.7

### Dimension Ökologisch

| Fakt | Fundstelle | Zeilennr. in fundamentals-2.typ |
|------|-----------|----------------------------------|
| CPU-only-Inferenz via ONNX Runtime, kein GPU-Server erforderlich | `A-03` Anforderungszeile: `[Infrastruktur CPU-only, kein GPU-Server], [Hard Constraint], [ONNX Runtime CPUExecutionProvider (vgl. Kap.~3.3)]` | Z. 86 |
| CPU-Inferenz eliminiert GPU-Instanzkosten (Formulierung bereits ökologisch verwertbar) | `Die Inferenz via ONNX Runtime liefert CPU-optimierte Verarbeitung ohne GPU-Server. Dies eliminiert sowohl die Infrastrukturkosten für dedizierte GPU-Instanzen als auch die Latenz durch Cloud-Calls für jeden Frame` | Z. 163 |
| `FRAME_INTERVAL` = 1,0 s (periodischer Scan statt Continuous-Stream) | **NICHT in fundamentals-2.typ** — steht in `methodology.typ` Z. 28 und Z. 75, sowie `practical-1.typ` Z. 44. Für Kap. 3.7 als systembekannte Tatsache formulierbar (`FRAME_INTERVAL`-Parameter ohne Dateireferenz). | — |

**Wichtig für Wave 2:** `FRAME_INTERVAL` ist in `fundamentals-2.typ` nicht erwähnt. Wave 2 kann den Parameter als systemspezifische Tatsache nennen (er ist aus Kap. 4/5 bekannt), muss aber keinen genauen Querverweis in Kap. 3.7 setzen — oder als `vgl. Kap.~4.1` formulieren.

### Dimension Ökonomisch

| Fakt | Fundstelle | Zeilennr. in fundamentals-2.typ |
|------|-----------|----------------------------------|
| Open-Source-Stack lizenzfrei: MediaPipe, InsightFace, ONNX Runtime, Qdrant, FastAPI | `Der gesamte lokale Verarbeitungsstack des Systems verwendet ausschließlich Open-Source-Komponenten: MediaPipe, InsightFace, ONNX Runtime, Qdrant und FastAPI sind lizenzfrei nutzbar @lugaresi2019mediapipe[S.~1--2]` | Z. 202 |
| Verweis auf `tab:kostenvergleich` — $0,00 für ONNX vs. $0,90 AWS / $1,35 Azure | Tabellenreferenz `<tab:kostenvergleich>` | Z. 227 |
| $0,00 für Gesichtserkennung (ArcFace/ONNX) | `[Gesichtserkennung (ArcFace/ONNX)], [30], [900], [*\$0,00*], [~\$0,90], [~\$1,35]` | Z. 223 |

**Pitfall-4-Schutz:** Kap. 3.7 ökonomische Dimension als **Querverweise** auf Kap. 3.6 formulieren, nicht als neue Herleitung. Formulierung: `vgl. Kap.~3.6` und `@tab:kostenvergleich`.

### Dimension Sozial

| Fakt | Fundstelle | Zeilennr. |
|------|-----------|-----------|
| `@krivokucahahn2023biometricprotection[S.~639--641]` — Identifizierbarkeit als Schutzgut | fundamentals-2.typ Z. 194 | Z. 194 |
| `@dsgvo2016[Art.~9 Abs.~1]` — biometrische Daten besonderer Kategorie | fundamentals-2.typ Z. 194 | Z. 194 |
| `@buolamwini2018gendershades[S.~2--7]` — demographische Fehlerratendiskrepanz | discussion.typ Z. 27 (nicht in fundamentals-2.typ, aber in BibTeX vorhanden) | — in fund.-2 |
| Interner SAP-Prototyp, opt-in, biometrische Daten verlassen Cluster nicht | `Das entwickelte System ist ein interner SAP-Prototyp ... Eine explizite Einwilligung aller am Prototyp beteiligten Testpersonen liegt vor.` | Z. 196 |
| Öffentliches Deployment erfordert DSGVO Art. 17 + Art. 35 | `ein explizites Opt-in-Verfahren gemäß Art.~9 Abs.~2 lit.~a DSGVO ... Recht auf Löschung ... Art.~17 DSGVO ... Art.~35 DSGVO` | Z. 198 |

---

## Typst-Konventionen (Checkliste für Wave 2)

Abgeschrieben aus dem bestehenden Dokument (fundamentals-2.typ / discussion.typ):

| Konvention | Beispiel aus dem Dokument |
|-----------|--------------------------|
| Em-Dash | ` --- ` (Leerzeichen + drei Bindestriche + Leerzeichen), z. B. Z. 163: `ohne GPU-Server-Anforderung --- eine direkte Konsequenz` |
| Dezimalkomma | `0,52`, `99,83 %`, `1,5~Gaze-Check-Calls` (Komma, kein Punkt) |
| Tilde für non-breaking space | `ca.~\$0,90`, `Z.~163`, `N~=~10` |
| Zitationsformat mit Seitenbereich | `@buolamwini2018gendershades[S.~2--7]` |
| Querverweise | `vgl. Kap.~3.6`, `vgl. Kap.~3.5` (Tilde zwischen `Kap.` und Nummer) |
| Querverweise auf Tabellen | `vgl. Tabelle~3.2`, `@tab:kostenvergleich` |
| Abschnitt Ebene 2 | `== Nachhaltigkeitsaspekte` (identisch zu allen 3.1–3.6) |
| Fußnote/Erklärung in Tabellen | `\*` mit Erläuterung in caption |
| Zwei Leerzeilen vor neuer `==`-Überschrift | Konvention im gesamten Dokument (Z. 98, 129, 165, 192, 200) |

---

## Abweichung vom Plan-Erwartungswert

Der Plan erwartete, dass `FRAME_INTERVAL` in `fundamentals-2.typ` vorkommt. Das ist **nicht der Fall** — der Parameter ist ausschließlich in `methodology.typ` (Kap. 4) und `practical-1.typ` dokumentiert. Wave 2 hat zwei Optionen:

**Option A (empfohlen):** `FRAME_INTERVAL` in Kap. 3.7 mit Querverweis `(vgl. Kap.~4.1)` nennen — inhaltlich korrekt, keine neue Behauptung.

**Option B:** `FRAME_INTERVAL` weglassen und nur CPU-only/ONNX als ökologischen Vorteil nennen — konservativer, kein Querverweis nötig.

---

## Zusammenfassung: Aktionsplan für Wave 2 (38-02)

| Aktion | Datei | Position | Art |
|--------|-------|----------|-----|
| Kap. 3.7 `== Nachhaltigkeitsaspekte` einfügen | `fundamentals-2.typ` | Nach Z. 229 (Ende) | Append |
| Buolamwini-Satz (Z. 27) erweitern | `discussion.typ` | Z. 26–27 ersetzen | Inline-Ersetzung |
| BibTeX | `sources.bib` | — | Keine Aktion |
