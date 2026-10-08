// The `report` show rule: typography, page furniture, cover, front matter
// and body styling. `appendix` switches the remaining chapters to letters.

#import "theme.typ": default-theme, merge-theme, theme-state
#import "utils.typ": (
  appendix-state, as-array, heading-numbering, person-name, plain-text,
)
#import "marks.typ": is-mark-figure
#import "cover.typ": cover-page
#import "front.typ": document-control, registers as render-registers
#import "page.typ": body-footer, body-header, front-footer, watermark

#let chapter-heading(theme, it) = {
  pagebreak(weak: true)
  v(4mm)
  block(width: 100%, below: 1.9em, {
    rect(width: 22mm, height: 4pt, fill: theme.accent)
    v(12pt)
    set text(size: 23pt, weight: "bold")
    set par(leading: 0.4em)
    if it.numbering == none { it.body } else {
      if appendix-state.get() {
        block(below: 6pt, text(
          size: 9pt,
          tracking: 0.12em,
          fill: theme.muted,
        )[APPENDIX])
      }
      grid(
        columns: (auto, 1fr),
        column-gutter: 0.55em,
        text(fill: theme.primary, counter(heading).display(it.numbering)),
        it.body,
      )
    }
  })
}

#let section-heading(theme, it, size: 10pt, above: 1.6em, below: 0.8em) = {
  block(above: above, below: below, sticky: true, {
    set text(size: size, weight: "bold")
    set par(leading: 0.45em)
    if it.numbering == none { it.body } else {
      grid(
        columns: (auto, 1fr),
        column-gutter: 0.6em,
        text(fill: theme.primary, counter(heading).display(it.numbering)),
        it.body,
      )
    }
  })
}

#let appendix(body) = {
  counter(heading).update(0)
  appendix-state.update(true)
  set heading(numbering: heading-numbering(appendix: true))
  body
}

#let report(
  // Identity.
  title: none,
  subtitle: none,
  short-title: none,
  doc-type: none,
  doc-id: none,
  version: none,
  status: none,
  date: none,
  classification: none,
  organisation: none,
  logo: none,
  keywords: (),
  // Document control.
  authors: (),
  owner: none,
  reviewers: (),
  approvers: (),
  distribution: (),
  handling: none,
  notice: none,
  history: (),
  // Structure.
  marks: (:),
  registers: true,
  list-of-tables: true,
  list-of-figures: false,
  outline-depth: 2,
  heading-start: 1,
  draft: auto,
  // Look.
  theme: (:),
  paper: "a4",
  lang: "en",
  region: none,
  body,
) = {
  let theme = merge-theme(default-theme, theme)
  let short-title = if short-title == none { title } else { short-title }
  let is-draft = if draft == auto {
    (
      status != none
        and not lower(plain-text(status)).contains(
          regex("final|approved|issued|released"),
        )
    )
  } else { draft }
  let footer-left = (
    doc-id,
    if version != none [Version #version],
    status,
  )
    .filter(part => part != none)
    .join[ #sym.dot.c ]

  set document(
    title: if subtitle == none { title } else [#title: #subtitle],
    author: as-array(authors).map(a => plain-text(person-name(a))),
    date: if type(date) == datetime { date } else { auto },
    keywords: keywords,
  )

  // Typography.
  set page(paper: paper)
  set text(
    font: theme.fonts.body,
    size: 10pt,
    fill: theme.ink,
    lang: lang,
    region: region,
  )
  set par(leading: 0.7em, spacing: 1.15em)
  set list(
    marker: (
      text(fill: theme.muted, sym.bullet),
      text(fill: theme.muted, sym.dash.en),
    ),
    indent: 0.25em,
    body-indent: 0.6em,
    spacing: 0.75em,
  )
  set enum(indent: 0.25em, body-indent: 0.6em, spacing: 0.75em)
  set footnote.entry(separator: line(
    length: 30%,
    stroke: 0.5pt + theme.rule,
  ))

  // Headings.
  show heading: set text(font: theme.fonts.heading, fill: theme.ink)
  show heading.where(level: 1): it => chapter-heading(theme, it)
  show heading.where(level: 2): it => section-heading(
    theme,
    it,
    size: 13.5pt,
    above: 2em,
    below: 0.9em,
  )
  show heading.where(level: 3): it => section-heading(theme, it, size: 11pt)
  show heading.where(level: 4): it => section-heading(
    theme,
    it,
    size: 10pt,
    above: 1.4em,
    below: 0.7em,
  )

  // Links and references.
  show link: it => if type(it.dest) == str {
    set text(fill: theme.link)
    underline(stroke: 0.5pt + theme.link.transparentize(50%), offset: 2pt, it)
  } else { it }
  show ref: set text(fill: theme.link)

  // Code.
  show raw: set text(font: theme.fonts.mono)
  show raw.where(block: false): it => highlight(
    fill: theme.surface,
    top-edge: "ascender",
    bottom-edge: "descender",
    extent: 1.2pt,
    radius: 1.5pt,
    text(fill: theme.code, it),
  )
  show raw.where(block: true): it => block(
    width: 100%,
    fill: theme.surface,
    stroke: (left: 2pt + theme.rule),
    radius: (right: 2pt),
    inset: (x: 10pt, y: 9pt),
    breakable: true,
    {
      set text(size: 8.2pt)
      set par(leading: 0.55em)
      it
    },
  )

  // Tables and figures.
  set table(
    inset: (x: 6pt, y: 5pt),
    align: left + top,
    fill: (_, y) => if y == 0 { theme.header-fill },
    stroke: (_, y) => if y == 0 { (bottom: 1pt + theme.accent) } else {
      (bottom: 0.5pt + theme.rule)
    },
  )
  show table: set text(size: 8.8pt, hyphenate: true)
  show table: set par(leading: 0.55em, spacing: 0.75em)
  show table.cell.where(y: 0): set text(weight: "bold", fill: theme.on-header)
  set figure(gap: 0.8em)
  show figure: set block(breakable: true)
  show figure.where(kind: table): set figure.caption(position: top)
  show figure.caption: it => align(left, text(size: 8.5pt, {
    text(weight: "bold", fill: theme.primary)[
      #it.supplement #context it.counter.display(it.numbering)
    ]
    h(0.6em)
    text(fill: theme.muted, it.body)
  }))
  show figure: it => if is-mark-figure(it) { it.body } else { it }

  // Contents entries: chapters bold without leaders.
  show outline.entry.where(level: 1): it => {
    if it.element.func() != heading { return it }
    set block(above: 1.15em)
    set text(weight: "bold")
    link(it.element.location(), it.indented(it.prefix(), [
      #it.body()#h(1fr)#it.page()
    ]))
  }

  theme-state.update(theme)

  // Cover.
  cover-page(
    theme,
    title: title,
    subtitle: subtitle,
    doc-type: doc-type,
    doc-id: doc-id,
    version: version,
    status: status,
    date: date,
    classification: classification,
    organisation: organisation,
    authors: authors,
    handling: handling,
    logo: logo,
  )

  // Front matter, numbered in roman.
  set page(
    margin: (x: 22mm, top: 25mm, bottom: 24mm),
    numbering: "i",
    header: none,
    footer: front-footer(theme, footer-left),
  )
  counter(page).update(1)
  document-control(
    theme,
    title: if subtitle == none { title } else [#title: #subtitle],
    doc-id: doc-id,
    version: version,
    status: status,
    date: date,
    classification: classification,
    owner: owner,
    authors: authors,
    reviewers: reviewers,
    approvers: approvers,
    distribution: distribution,
    handling: handling,
    notice: notice,
    history: history,
    specs: marks,
  )
  outline(title: [Contents], depth: outline-depth)
  render-registers(
    if registers { marks } else { (:) },
    list-of-tables: list-of-tables,
    list-of-figures: list-of-figures,
  )

  // Body, numbered from 1.
  set page(
    numbering: "1",
    header: body-header(theme, short-title),
    footer: body-footer(theme, footer-left),
    background: if is-draft { watermark(theme)[DRAFT] },
  )
  counter(page).update(1)
  set heading(numbering: heading-numbering(start: heading-start))
  body
}
