// The two documents: `prayer-guide` for prayer sessions and celebrations,
// and `formation` for study sessions. Both open with the group's masthead
// and share the page, type and heading setup.

#import "@local/base:0.1.0": dot, enum-numbering, merge-theme
#import "theme.typ": default-theme, label-text, theme-state
#import "dates.typ": format-date

// The group, the dates and the year's motto, centered as on the group's own
// sheets, closed by a hairline.
#let masthead(theme, group, date, motto) = {
  if (group, date, motto).all(x => x == none) { return }
  set align(center)
  set par(justify: false)
  if group != none {
    block(below: 0.6em, label-text(
      theme,
      group,
      size: 11pt,
      fill: theme.accent,
      weight: "regular",
      tracking: 0.06em,
      caps: true,
    ))
  }
  if date != none {
    block(below: 0.8em, text(
      size: 11pt,
      fill: theme.secondary,
      format-date(date),
    ))
  }
  if motto != none {
    block(below: 0pt, text(size: 13pt, style: "italic", motto))
  }
  block(above: 1.4em, below: 0pt, line(
    length: 100%,
    stroke: 0.5pt + theme.separator,
  ))
}

// The session title, large and centered, with an optional line above it
// (the series of a formation) and below it.
#let title-block(theme, title, size: 22pt, above: none, below: none) = {
  set align(center)
  set par(justify: false, leading: 0.4em)
  block(above: 2.2em, below: 2.4em, width: 100%, {
    if above != none {
      block(below: 0.9em, label-text(
        theme,
        above,
        size: 10.5pt,
        fill: theme.secondary,
        weight: "regular",
      ))
    }
    if title != none {
      text(size: size, weight: "bold", title)
    }
    if below != none {
      block(above: 0.9em, text(size: 12pt, fill: theme.secondary, below))
    }
  })
}

// "2 de 3" and the title, from the second page on; nothing on a single
// sheet.
#let footer(theme, label) = context {
  let total = counter(page).final().first()
  if total < 2 { return }
  let footer-label(body) = label-text(
    theme,
    body,
    size: 9pt,
    fill: theme.secondary,
    weight: "regular",
  )
  grid(
    columns: (1fr, auto),
    column-gutter: 2em,
    footer-label(label), footer-label[#counter(page).display() de #total],
  )
}

#let setup(
  theme: (:),
  group: none,
  date: none,
  motto: none,
  title: none,
  paper: "a4",
  size: 11pt,
  heading-size: 10.5pt,
  opening: none,
  body,
) = {
  let theme = merge-theme(default-theme, theme)

  set document(title: title)
  set page(
    paper: paper,
    margin: (x: 22mm, top: 20mm, bottom: 24mm),
    footer: footer(theme, title),
  )
  set text(
    font: theme.fonts.body,
    weight: theme.body-weight,
    size: size,
    fill: theme.ink,
    lang: "pt",
    region: "PT",
  )
  set par(leading: 0.62em, spacing: 1em)
  set list(
    marker: dot(theme.secondary),
    indent: 0.2em,
    body-indent: 0.65em,
    spacing: 0.75em,
  )
  set enum(
    numbering: enum-numbering(theme.secondary),
    indent: 0.2em,
    body-indent: 0.65em,
    spacing: 0.75em,
  )
  set footnote.entry(
    separator: line(length: 25%, stroke: 0.5pt + theme.separator),
  )
  show footnote.entry: set text(size: 9pt, fill: theme.secondary)
  show footnote.entry: set par(first-line-indent: 0em, justify: false)

  // Headings name the moments of a guide and the texts of a formation.
  show heading.where(level: 1): it => block(
    above: 2em,
    below: 0.7em,
    sticky: true,
    label-text(theme, it.body, size: heading-size, fill: theme.accent),
  )
  show heading.where(level: 2): it => block(
    above: 1.5em,
    below: 0.6em,
    sticky: true,
    label-text(theme, it.body, size: heading-size - 1pt),
  )

  theme-state.update(theme)
  masthead(theme, group, date, motto)
  if opening != none { opening(theme) }
  body
}

// A guide for a prayer session, an adoration or a Eucharist: chants,
// readings, texts, rubrics and Pistas, set large enough to read in a dim
// chapel.
#let prayer-guide(
  group: none,
  date: none,
  motto: none,
  title: none,
  subtitle: none,
  paper: "a4",
  theme: (:),
  body,
) = {
  show: setup.with(
    theme: theme,
    group: group,
    date: date,
    motto: motto,
    title: title,
    paper: paper,
    size: 12pt,
    heading-size: 12pt,
    opening: theme => title-block(theme, title, below: subtitle),
  )
  set par(justify: true)
  body
}

// A handout for a formation session: a series and its part, the session's
// title, then texts with their sources, set as a book page with room to
// underline.
#let formation(
  group: none,
  date: none,
  motto: none,
  series: none,
  part: none,
  title: none,
  paper: "a4",
  theme: (:),
  body,
) = {
  let series-line(theme) = (
    series,
    if part != none {
      text(weight: "semibold", fill: theme.accent)[Parte #part]
    },
  )
    .filter(x => x != none)
    .join(linebreak())
  show: setup.with(
    theme: theme,
    group: group,
    date: date,
    motto: motto,
    title: title,
    paper: paper,
    size: 11.5pt,
    heading-size: 12pt,
    opening: theme => title-block(
      theme,
      title,
      size: 19pt,
      above: series-line(theme),
    ),
  )
  set par(
    justify: true,
    leading: 0.72em,
    spacing: 0.72em,
    first-line-indent: (amount: 1.5em, all: true),
    justification-limits: (
      tracking: (min: -0.01em, max: 0.01em),
      spacing: (min: 80%, max: 120%),
    ),
  )
  show quote.where(block: true): it => block(
    width: 100%,
    inset: (x: 1.5em),
    above: 1em,
    below: 1em,
    {
      set par(first-line-indent: 0em)
      set text(size: 0.95em)
      it.body
    },
  )
  body
}
