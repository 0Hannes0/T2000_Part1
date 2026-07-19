# 42-AUDIT.md — Bestandsaufnahme SELB-01-Lücken und Einfügepositionen

**Datum:** 2026-07-19
**Dateien geprüft:** `T2000_Part1/chapters/fundamentals-2.typ`, `T2000_Part1/chapters/practical-1.typ`
**SELB-01-Muster:** naive Lösung → beobachtetes Problem → eigene Erkenntnis → Entscheidung

---

## Kap. 3.3

**Datei:** `T2000_Part1/chapters/fundamentals-2.typ`
**Abschnitt:** `== Auswahl des Erkennungsmodells` (Z. 131)

**Ist-Stand:**
Der Abschnitt enthält eine Vergleichstabelle (Tab. 3.2) mit DeepFace als "Verworfen" und InsightFace buffalo_l als "Gewählt", einen Kriterien-Begründungsabsatz (ArcFace-Verlustfunktion, 99,83 % LFW, 80 ms), sowie einen Alternativen-Absatz (Z. 163) der endet mit "vgl. Tabelle~3.2". Z. 161 nennt die Messwerte ~92 % Genauigkeit und ~300 ms Latenz für DeepFace als Nebensatz ("Wrapper-Lösungen wie das DeepFace-Framework erreichen unter realen Bedingungen..."). Die Tabellen-Fußnote Z. 156 vermerkt "reale Genauigkeit im DeepFace-Framework; eigene Beobachtung".

**Lücke:**
Das SELB-01-Muster ist **OFFEN**. Es fehlen alle drei Narrative-Elemente als eigenständige Fließtext-Sätze:
1. DeepFace als naive Ausgangslösung (erster Evaluierungs-/Implementierungsschritt) ist nicht als einleitender Satz formuliert — nur als Tabellenzeile.
2. Die Messwerte 92 % / 300 ms erscheinen lediglich als Einschub-Nebensatz in Z. 161, nicht als eigenständig formulierte "eigene Beobachtung im Entwicklungsbetrieb".
3. Es gibt keinen Kausalitätssatz "Diese Messung/Beobachtung führte zur Entscheidung, zu InsightFace zu wechseln".

**Einfügeposition:** nach Z. 163 (letzter Satz des Alternativen-Absatzes, endet: "...liegen in Genauigkeit, Latenz oder beidem unter buffalo\_l (vgl. Tabelle~3.2).") — VOR Z. 165 ("Die Inferenz via ONNX Runtime...").

**Umfang:** 2–4 Sätze

---

## Kap. 5.1

**Datei:** `T2000_Part1/chapters/practical-1.typ`
**Abschnitt:** `== Biometrische Identifikation mit InsightFace` (Z. 8)
**Zielabsatz:** Z. 40 (Kalibrierungsabsatz)

**Ist-Stand:**
Der Kalibrierungsabsatz (Z. 40) hat die Drei-Stufen-Struktur weitgehend: Ausgangswert 0,65 (Literaturwert, mit Quellenangabe), beobachtete Scores 0,72–0,85 (normal) und 0,53–0,58 (Grenzfälle), Entscheidung für 0,52. Der Absatz endet mit "Die Testergebnisse sind in Kap.~7.3 ausgewiesen."

**Lücke:**
Das SELB-01-Muster ist **MARGINAL OFFEN** (Konjunktiv-Problem). Der Satz "Ein Schwellenwert von 0,65 hätte diese legitimen Wiederkennungen fälschlich als neue Personen klassifiziert" verwendet Konjunktiv II ("hätte"). SELB-01 verlangt die Eigenentscheidung als tatsächlich beobachtete Fehlerrate (Indikativ). Zudem fehlt ein expliziter Satz, der die eigene Kalibrierungsentscheidung als solche benennt. Die Kausalitätsformulierung ("Diese Beobachtung führte zur Wahl von 0,52") ist nicht vorhanden.

**Einfügeposition:** nach Z. 40 (nach dem letzten Satz des Kalibrierungsabsatzes: "Die Testergebnisse sind in Kap.~7.3 ausgewiesen.") — als Ergänzungssatz am Ende des Absatzes, vor Z. 41.

**Umfang:** 1–2 Sätze

---

## Kap. 5.3

**Datei:** `T2000_Part1/chapters/practical-1.typ`
**Abschnitt:** `== Qdrant-Persistenz und EMA-Blending` (Z. 88)
**Zielbereich:** Z. 116–119

**Ist-Stand:**
Der EMA-Abschnitt erklärt α=0,2 mit Formel (Z. 117), 20%/80%-Gewichtung (Z. 118–119), zwei gegenläufigen Anforderungen (Stabilität vs. Anpassungsfähigkeit), quantitativer Begründung ($(0{,}8)^5 \approx 33\%$, Z. 120), "(eigene Beobachtung)"-Marker und Literaturbelegen. Der grep-Befund bestätigt: α=0,5 kommt nirgends im Text vor.

**Lücke:**
Das SELB-01-Muster ist **OFFEN** (alle drei Elemente fehlen):
1. Die naive Ausgangshypothese α=0,5 (gleichgewichtiges Blending) ist nicht im Text benannt.
2. Das beobachtete Problem mit α=0,5 (Übergewichtung frischer Frames / Ausreißer-Instabilität) fehlt vollständig.
3. Es gibt keinen Kausalitätssatz "Diese Beobachtung führte zur Wahl von α=0,2".

grep-Verifikation: `grep -n "0,5\|gleichgewichtig\|Ausgangshypothese" practical-1.typ` findet keine Treffer für α=0,5 als Konzept — bestätigt das vollständige Fehlen.

**Einfügeposition:** nach Z. 117 (Formelzeile: `$ bold(e)_"neu" = ... alpha = 0","2 $`) — VOR Z. 119 ("Mit $alpha = 0","2$ trägt das aktuelle Sitzungs-Embedding...").

**Umfang:** 3–5 Sätze

---

## Gesamtbefund

Alle drei Stellen haben SELB-01-Lücken, die durch gezielte Text-Ergänzungen geschlossen werden können:

| Stelle | Datei | Einfügeposition | Status |
|--------|-------|----------------|--------|
| Kap. 3.3 — Modellwahl | `fundamentals-2.typ` | nach Z. 163 | OFFEN — alle drei Narrative-Elemente fehlen |
| Kap. 5.1 — Schwellenwert | `practical-1.typ` | nach Z. 40 | MARGINAL — Konjunktiv-Problem + fehlende Kausalität |
| Kap. 5.3 — EMA-α | `practical-1.typ` | nach Z. 117 | OFFEN — α=0,5 komplett absent |

**Kompaktliste der drei Einfügepositionen:**
- Z. 163 `fundamentals-2.typ` (Kap. 3.3, nach Alternativen-Absatz, vor ONNX-Absatz)
- Z. 40 `practical-1.typ` (Kap. 5.1, nach Kalibrierungsabsatz, vor InsightFace-Framework-Satz)
- Z. 117 `practical-1.typ` (Kap. 5.3, nach EMA-Formelzeile, vor "Mit α=0,2 trägt..."-Satz)

**Wichtiger Hinweis für Wave 2:** Die Zeilennummern in der RESEARCH.md stammen vom Zeitpunkt der Planung. Dieser Audit bestätigt die aktuellen Zeilennummern nach Phasen 36–41. Wave 2 soll ausschließlich die oben verifizierten Positionen verwenden.
