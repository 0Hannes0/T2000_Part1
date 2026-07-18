# 37-01-AUDIT: Kap. 3.6 Bestandsaufnahme

**Erstellt:** 2026-07-18
**Datei:** T2000_Part1/chapters/fundamentals-2.typ
**Abschnitt:** `== Wirtschaftliche Bewertung`

---

## Bestandsaufnahme

Zeile des letzten bestehenden Satzes: Z. 206
Letzter Satz endet mit: "...wirtschaftliche Personalisierungslösung, die für den SAP-Unternehmenskontext ohne Lizenzrisiken und mit minimalem Cloud-Verbrauch einsetzbar ist."

Dateiende: Z. 206 (Datei hat 206 Zeilen insgesamt; kein Inhalt nach Z. 206)

---

## Fehlende Elemente (einzufügen nach Z. 206)

- [ ] Annahmen-Satz (D-10): Kein Satz mit Besucherzahl/Call-Aufschlüsselung vorhanden
- [ ] Kostentabelle (D-06, D-07): Kein `#figure(table(...))` mit AWS/Azure-Vergleich vorhanden
- [ ] Fazit-Satz (D-09): Kein Satz mit konkreter Dollarbetragsangabe vorhanden

**Prüfung (a):** Letzte Zeile des Abschnitts ist Z. 206 — bestätigt.
**Prüfung (b):** Kein Satz mit "30 Besucher" oder "Calls/Tag" nach Z. 206 — bestätigt (Dateiende).
**Prüfung (c):** Kein `#figure(table(...))` mit Label `kostenvergleich` oder Spalten "AWS"/"Azure" — bestätigt.
**Prüfung (d):** Kein Fazit-Satz mit "$0,90" oder "$1,35" — bestätigt.

---

## Einfügeposition für Wave 2

Nach Z. 206 (nach dem Punkt am Ende von "...einsetzbar ist.") in fundamentals-2.typ.

Der neue Inhalt (Annahmen-Satz + Kostentabelle + Fazit-Satz) wird als direkter Anschluss an den bestehenden SAP-AI-Core-Absatz eingefügt.

---

## Bestehender Text (erhalten — per CONTEXT.md)

Z. 200–206: Abschnitt `== Wirtschaftliche Bewertung` enthält drei bestehende Absätze:

- Z. 202: Open-Source-Stack-Argument (MediaPipe, InsightFace, ONNX Runtime, Qdrant, FastAPI — lizenzfrei; Microservice-Architektur)
- Z. 204: CPU-Inferenz-Argument (ONNX Runtime spart GPU-Instanzkosten)
- Z. 206: SAP-AI-Core-Absatz (drei Aufgaben: Gaze-Check, Begrüßungsgenerierung, LLM-Chat; minimaler API-Verbrauch; biometrische Identifikation vollständig lokal)

Alle drei Absätze bleiben erhalten und werden durch die Wave-2-Inhalte ergänzt, nicht ersetzt.

---

## Volltext Z. 200–206 (Referenz)

```
Z. 200: == Wirtschaftliche Bewertung
Z. 201: (leer)
Z. 202: Der gesamte lokale Verarbeitungsstack... (Open-Source-Absatz)
Z. 203: (Fortsetzung Z. 202)
Z. 204: CPU-Inferenz via ONNX Runtime spart zusätzlich GPU-Instanzkosten...
Z. 205: (leer)
Z. 206: SAP AI Core wird ausschließlich für drei Aufgaben genutzt... einsetzbar ist.
```

*Hinweis: Z. 202–203 sind ein fortlaufender Satz (kein expliziter Zeilenumbruch im Quelltext — die Absatztrennung ergibt sich aus der Typst-Semantik); Z. 204 ist ein eigenständiger Absatz; Z. 206 ist ein langer Absatz ohne nachfolgenden Inhalt.*

---

*Erstellt von Plan 37-01 — Wave 1 Bestandsaufnahme*
