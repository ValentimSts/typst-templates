// Running header and footer for body pages.

#import "theme.typ": pill
#import "utils.typ": appendix-state, heading-number

#let chapter-label(chapter) = {
  let number = heading-number(chapter)
  let prefix = if appendix-state.at(chapter.location()) [Appendix ]
  [#prefix#number#h(0.6em)#chapter.body]
}

// Shows the short title and the current chapter, except on pages where a
// chapter or the appendix divider opens: those carry their title already.
#let body-header(theme, short-title, draft) = context {
  let chapters = heading.where(level: 1)
  let next = query(chapters.after(here()))
  if next.len() > 0 and next.first().location().page() == here().page() {
    return
  }
  let previous = query(chapters.before(here())).filter(h => (
    h.numbering != none
  ))
  set text(size: 8pt, fill: theme.secondary)
  grid(
    columns: (auto, 1fr),
    column-gutter: 12pt,
    align: (left + horizon, right + horizon),
    {
      short-title
      if draft {
        h(6pt)
        pill(theme, filled: true)[Draft]
      }
    },
    if previous.len() > 0 { chapter-label(previous.last()) },
  )
}

#let body-footer(theme, left-text) = context {
  set text(size: 8pt, fill: theme.secondary)
  let total = counter(page).final().first()
  grid(
    columns: (1fr, auto),
    align: (left, right),
    left-text, [#counter(page).display() of #total],
  )
}

#let front-footer(theme, left-text) = context {
  set text(size: 8pt, fill: theme.secondary)
  grid(
    columns: (1fr, auto),
    align: (left, right),
    left-text, counter(page).display("i"),
  )
}
