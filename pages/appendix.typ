/// Renders the appendix with the AI tools table.
/// - labels (dict): UI label dictionary
/// -> none
#let appendix(labels: (:)) = {
  import "../user/ai-tools.typ": ai-tools

  [
    #heading(level: 1, numbering: none)[#labels.appendix]
    #heading(level: 2, numbering: none)[#labels.appendix-ai-heading]
    #figure(
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
    ) <ai-tools>

    #heading(level: 2, numbering: none)[A2: Systemparameter]
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
        [`SIMILARITY_THRESHOLD`], [0,52], [—], [Kap.~5.1],
        [`FRAME_INTERVAL`], [1,0], [s], [Kap.~4.1],
        [`GROUP_ARRIVAL_WINDOW_SECS`], [2,0], [s], [Kap.~4.4],
        [EMA-α], [0,2], [—], [Kap.~5.3],
      ),
    ) <tab:systemparameter>
  ]
}
