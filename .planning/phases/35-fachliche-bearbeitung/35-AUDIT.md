# 35-AUDIT — FACH-Lückenanalyse in discussion.typ

Erstellt: 2026-07-18  
Datei geprüft: T2000_Part1/chapters/discussion.typ (73 Zeilen)

---

## FACH-01 — Versuchsbeschreibung

**Befund:** LÜCKE — kein dedizierter Versuchsbeschreibungs-Absatz vor `== Erkennungsgenauigkeit`.

- Zeile 5: `== Erkennungsgenauigkeit` (Header)
- Zeile 3: Intro-Absatz endet mit "...die daraus folgenden methodischen Grenzen werden bei den jeweiligen Dimensionen explizit ausgewiesen." — kein N, kein Beleuchtungskontext, keine Zeitrahmenangabe als eigenständiger Versuchsrahmen-Absatz
- "10 bekannte Personen" erscheint erstmals in Zeile 17 im Kontext des Threshold-Feldtests, nicht als Versuchsbeschreibung
- Keine Erwähnung von Bürobeleuchtung, Sitzungsanzahl oder Messprotokolldauer als Rahmenbeschreibung

**Insertionspunkt:** Nach Zeile 3 (Ende Intro-Absatz), Leerzeile Zeile 4, vor Zeile 5 (`== Erkennungsgenauigkeit`)  
Neuer Block: Paragraf mit N=10, Innenraum-Bürobeleuchtung, Entwicklungsphase als Zeitrahmen, methodischer Einordnung

---

## FACH-02 — Gaze-Check qualitative Evaluation

**Befund:** LÜCKE — kein Text zu False Positives / False Negatives des Gaze-Checks.

- Zeile 41: Gaze-Check erscheint nur als Tabellenzeile: `[Verarbeitung (parallel)], [Gaze-Check (~2 s), Embedding (~80 ms) ...]`
- Zeile 48 (Ende Systemlatenz-Prosa): "...Eine Person, die aktiv mit dem Gerät interagieren möchte, steht typischerweise länger als 10 s davor."
- Zeile 50: `== Robustheit` (Header)
- Kein FP/FN-Text, keine qualitative Bewertung des Gaze-Checks irgendwo im Dokument

**Insertionspunkt:** Nach Zeile 48 (Ende Systemlatenz-Prosa), Leerzeile, vor Zeile 50 (`== Robustheit`)  
Neuer Block: Paragraf mit qualitativem FP/FN-Befund des Gaze-Checks

---

## FACH-03 — Gruppen-Sessions-Beleg

**Befund:** LÜCKE — Multi-Person-Zeile enthält Beschreibung statt Messgröße; Prosa hat keinen Gruppen-Sessions-Satz.

**Aktueller Inhalt der Multi-Person-Beobachtungsspalte (Zeile 63):**  
`[Gleichzeitige Ankünfte]`  
→ Keine numerische oder schätzende Messgröße; rein deskriptiv

**Prosa nach Robustheit-Tabelle (Zeilen 69–72):** Behandelt Kopfdrehung (Zeile 69) und Beleuchtungsvarianz (Zeilen 71–72). Kein Satz zu Gruppen-Sessions oder Multi-Person-Sessionsanteil.

**Insertionspunkt 1:** Zeile 63 — Zellinhalt `[Gleichzeitige Ankünfte]` ersetzen durch quantitativen Befund  
**Insertionspunkt 2:** Nach Zeile 72 (Ende Beleuchtungsvarianz-Prosa, letzter Absatz) — abschließender Satz zu Gruppen-Sessions ergänzen

---

## Zusammenfassung für Wave 2

| FACH | Typ | Insertionspunkt | Erwarteter Inhalt |
|------|-----|-----------------|-------------------|
| FACH-01 | Neuer Absatz | Nach Zeile 3, vor Zeile 5 | Versuchsrahmen N=10, Bürobeleuchtung, Entwicklungsphase, methodische Einschränkung |
| FACH-02 | Neuer Absatz | Nach Zeile 48, vor Zeile 50 | Qualitative FP/FN-Evaluation des Gaze-Checks |
| FACH-03a | Zellersetzen | Zeile 63, zweite Zelle | Quantitativer Sessionsanteil (~20 %) |
| FACH-03b | Neuer Abschlussabsatz | Nach Zeile 72 | Gruppen-Sessions mit beobachteter Zahl |
