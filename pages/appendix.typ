/// Renders the appendix with the AI tools table.
/// - labels (dict): UI label dictionary
/// -> none
#let appendix(labels: (:)) = {
  import "../user/ai-tools.typ": ai-tools

  heading(level: 1, numbering: none)[#labels.appendix]
  heading(level: 2, numbering: none)[#labels.appendix-ai-heading]
  figure(
    kind: table,
    supplement: labels.supplement-table,
    caption: [#labels.appendix-ai-caption],
    table(
      columns: (3.8cm, 1fr),
      stroke: 0.5pt,
      inset: (x: 6pt, y: 5pt),
      align: (left + top, left + top),
      table.header(
        strong[#labels.appendix-ai-col1],
        strong[#labels.appendix-ai-col2],
      ),
      ..for (name, items) in ai-tools {
        (
          name,
          {
            set list(indent: 0pt, body-indent: 0.5em, spacing: 0.3em)
            set par(leading: 0.55em)
            list(..items)
          },
        )
      }
    ),
  )

  heading(level: 2, numbering: none)[A2: Systemparameter]
  [
    #figure(
      kind: table,
      supplement: labels.supplement-table,
      caption: [Konfigurierbare Parameter des Presence Service mit Standardwert, Einheit und Primärkapitel],
      table(
        columns: (auto, auto, auto, 1fr),
        stroke: 0.5pt,
        inset: (x: 6pt, y: 5pt),
        align: (left + top, left + top, left + top, left + top),
        table.header(
          strong[Parameter], strong[Wert], strong[Einheit], strong[Kap.-Verweis],
        ),
        [`CANDIDATE_SECS`], [4,0], [s], [Kap.~4.3],
        [`LEAVE_SECS`], [10,0], [s], [Kap.~4.3],
        [`GAZE_TIMEOUT_SECS`], [9,0], [s], [Kap.~4.2],
        [`GREETING_WAIT_SECS`], [1,5], [s], [Kap.~4.3],
        [`FRAME_INTERVAL`], [1,0], [s], [Kap.~4.1],
        [`GROUP_ARRIVAL_WINDOW_SECS`], [2,0], [s], [Kap.~4.4],
        [IDLE-Eviction (`LEAVE_SECS`·6)], [≈60], [s], [Kap.~4.4],
        [`MIN_DETECTION_CONFIDENCE`], [0,5], [—], [Kap.~4.1],
        [`MIN_FACE_WIDTH_RATIO`], [0,06], [—], [Kap.~4.1],
        [`DETECTION_UPSCALE`], [2,5], [Faktor], [Kap.~4.1],
        [`POSITION_MATCH_RADIUS`], [120], [px], [Kap.~4.4/5.2],
        [`SIMILARITY_THRESHOLD`], [0,52], [—], [Kap.~5.1],
        [EMA-α], [0,2], [—], [Kap.~5.3],
      ),
    ) <tab:systemparameter>

    #figure(
      kind: table,
      supplement: labels.supplement-table,
      caption: [Wirkung der BlazeFace-Detektionsfilter und Gaze-Validator-Konfiguration],
      table(
        columns: (auto, 1fr),
        stroke: 0.5pt,
        inset: (x: 6pt, y: 5pt),
        align: (left + top, left + top),
        table.header(
          strong[Aspekt], strong[Beschreibung],
        ),
        [`MIN_DETECTION_CONFIDENCE`], [MediaPipe-interne Schwelle für die Bounding-Box-Validierung --- verwirft Detektionen unter diesem Konfidenzwert],
        [`MIN_FACE_WIDTH_RATIO`], [Mindestbreite eines erkannten Gesichts relativ zur Frame-Breite --- filtert Hintergrundpersonen heraus (< 6 % des Frame-Bereichs)],
        [`DETECTION_UPSCALE`], [Frame wird vor Übergabe an MediaPipe um Faktor 2,5 vergrößert; Bounding-Boxen werden anschließend zurückgerechnet],
        [Gaze-Modell], [Gemini 2.5 Flash über SAP AI Core (`thinking_budget=0`, `temperature=0`, `max_output_tokens=50`)],
        [Gaze-Eingabe], [JPEG-kodiertes Kamerabild (Qualitätsstufe 70) plus Textaufforderung],
        [Gaze-Ausgabe], [Binäre Klassifikation: „yes" → schaut in die Kamera, „no" → nicht, Timeout/Fehler → None (Retry)],
      ),
    ) <tab:detektion-gaze>

    #figure(
      kind: table,
      supplement: labels.supplement-table,
      caption: [Kennwerte des InsightFace buffalo\_l Erkennungsmodells und der FaceStore-Persistenzschicht],
      table(
        columns: (auto, 1fr),
        stroke: 0.5pt,
        inset: (x: 6pt, y: 5pt),
        align: (left + top, left + top),
        table.header(
          strong[Aspekt], strong[Eigenschaft],
        ),
        [Modellpaket], [InsightFace buffalo\_l],
        [Modell], [w600k\_r50 (ArcFace ResNet50)],
        [Embedding-Dimension], [512],
        [Crop-Größe], [112×112 px],
        [Inference-Backend], [ONNX Runtime (CPUExecutionProvider)],
        [Latenz], [~80 ms pro Embedding-Berechnung],
        [LFW-Genauigkeit], [99,83 %],
        [FaceStore-Typ], [Abstrakte Basisklasse (Strategy-Pattern), Backend-Auswahl über ENV `FACE_STORE_BACKEND`],
        [Backends], [SQLiteFaceStore (lokal) / QdrantFaceStore (Kubernetes)],
        [Vektordimensionen (Qdrant)], [512-dim ArcFace-Embeddings / 384-dim RAG-Chunks],
        [Ähnlichkeitsmaß], [Kosinus-Distanz (HNSW-Index)],
      ),
    ) <tab:modell-persistenz>
  ]
}
