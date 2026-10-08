// Running header, footer and draft watermark for body pages.

#import "utils.typ": appendix-state, heading-number

#let chapter-label(chapter) = {
  let number = heading-number(chapter)
  let prefix = if appendix-state.at(chapter.location()) [Appendix ]
  [#prefix#number#h(0.6em)#chapter.body]
}

// Shows the short title and the current chapter, except on pages where a
// chapter opens: those pages carry the chapter title already.
#let body-header(theme, short-title) = context {
  let here-page = here().page()
  let chapters = query(heading.where(level: 1)).filter(h => (
    h.numbering != none
  ))
  if chapters.any(h => h.location().page() == here-page) { return }
  let previous = chapters.filter(h => h.location().page() < here-page)
  set text(size: 8pt, fill: theme.muted)
  grid(
    columns: (auto, 1fr),
    column-gutter: 12pt,
    align: (left + bottom, right + bottom),
    short-title, if previous.len() > 0 { chapter-label(previous.last()) },
  )
  v(-5pt)
  line(length: 100%, stroke: 0.5pt + theme.rule)
}

#let body-footer(theme, left-text) = context {
  set text(size: 8pt, fill: theme.muted)
  let total = counter(page).final().first()
  grid(
    columns: (1fr, auto),
    align: (left, right),
    left-text, [Page #counter(page).display() of #total],
  )
}

#let front-footer(theme, left-text) = context {
  set text(size: 8pt, fill: theme.muted)
  grid(
    columns: (1fr, auto),
    align: (left, right),
    left-text, counter(page).display("i"),
  )
}

#let watermark(theme, label) = place(
  center + horizon,
  rotate(-50deg, text(
    size: 120pt,
    weight: "bold",
    tracking: 0.08em,
    fill: theme.ink.transparentize(95%),
    label,
  )),
)
