// The `report` show rule: typography, page furniture, cover, front matter
// and body styling. `appendix` switches the remaining chapters to letters.

#import "@local/base:0.1.0": dash, dot, enum-numbering, merge-theme
#import "theme.typ": default-theme, theme-state
#import "utils.typ": (
  appendix-state, as-array, format-date, heading-numbering, person-name,
  plain-text,
)
#import "marks.typ": is-mark-figure
#import "cover.typ": cover-page
#import "front.typ": (
  document-control, glossary as glossary-page, registers as render-registers,
)
#import "glossary.typ": apply-glossary, no-glossary
#import "page.typ": body-footer, body-header, front-footer
#import "links.typ": accessed-state, show-link

// Chapter titles: the display cut, semibold, slightly tightened; numbers
// carry the accent.
#let display(theme, size, body) = text(
  font: theme.fonts.display,
  size: size,
  weight: "semibold",
  tracking: -0.01em,
  body,
)

// The chapter's own contents: its sections, between two rules.
#let chapter-contents(theme, chapter) = context {
  let opened = chapter.location()
  let later = query(heading.where(level: 1).after(opened, inclusive: false))
  let target = heading.where(level: 2).after(opened, inclusive: false)
  let target = if later.len() > 0 {
    target.before(later.first().location(), inclusive: false)
  } else { target }
  if query(target).len() == 0 { return }
  block(width: 100%, above: 0pt, below: 2.4em, breakable: false, {
    set align(start)
    text(size: 11pt, weight: "semibold")[Contents]
    v(5pt, weak: true)
    line(length: 100%, stroke: 0.6pt + theme.ink)
    pad(left: 2.4em, top: 7pt, bottom: 8pt, {
      set text(size: 9pt)
      show outline.entry: it => link(
        it.element.location(),
        it.indented(
          text(weight: "semibold", fill: theme.secondary, it.prefix()),
          [#text(weight: "semibold", fill: theme.secondary, it.body())#box(
              width: 1fr,
              it.fill,
            )#text(weight: "semibold", it.page())],
        ),
      )
      set outline.entry(fill: repeat(gap: 0.35em, text(
        fill: theme.separator,
      )[.]))
      set block(spacing: 0.75em)
      outline(title: none, target: target, indent: 0pt)
    })
    line(length: 100%, stroke: 0.6pt + theme.ink)
  })
}

// A numbered chapter opens on a new page: a large gray number and the title,
// set to the right, then the chapter's contents. Unnumbered openers (front
// matter, the abstract, the appendix divider) keep a plain title.
#let chapter-heading(theme, it) = {
  pagebreak(weak: true)
  if it.numbering == none {
    v(14mm)
    block(width: 100%, below: 2.2em, {
      set par(leading: 0.3em)
      display(theme, 26pt, no-glossary(it.body))
    })
  } else {
    v(16mm)
    block(width: 100%, below: 14mm, {
      set align(end)
      set par(leading: 0.3em)
      if appendix-state.get() {
        block(below: 4mm, text(
          size: 11pt,
          weight: "semibold",
          fill: theme.secondary,
        )[Appendix])
      }
      block(below: 7mm, text(
        font: theme.fonts.display,
        size: 120pt,
        weight: "bold",
        fill: theme.secondary.lighten(35%),
        top-edge: "cap-height",
        bottom-edge: "baseline",
        counter(heading).display(it.numbering),
      ))
      display(theme, 26pt, no-glossary(it.body))
    })
    chapter-contents(theme, it)
  }
}

#let section-heading(
  theme,
  it,
  size: 10pt,
  tracking: 0em,
  above: 1.6em,
  below: 0.8em,
) = {
  block(above: above, below: below, sticky: true, {
    set text(size: size, weight: "semibold", tracking: tracking)
    set par(leading: 0.4em)
    if it.numbering == none { no-glossary(it.body) } else {
      grid(
        columns: (auto, 1fr),
        column-gutter: 0.55em,
        text(fill: theme.accent, counter(heading).display(it.numbering)),
        no-glossary(it.body),
      )
    }
  })
}

// Starts the appendices: a divider page titled `title` that lists them,
// then chapters numbered A, B, C.
#let appendix(title: [Appendix], body) = {
  [#heading(level: 1, numbering: none, title)<tech-report-appendix>]
  outline(
    title: none,
    depth: 1,
    target: heading
      .where(level: 1)
      .after(<tech-report-appendix>, inclusive: false),
  )
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
  glossary: (:),
  links-accessed: none,
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
    .join[ | ]

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
  set par(leading: 0.7em, spacing: 1.2em)
  set strong(delta: 200)
  // List markers are drawn, not typed: no Unicode glyphs in the chrome.
  set list(
    marker: (dot(theme.secondary), dash(theme.secondary)),
    indent: 0.2em,
    body-indent: 0.65em,
    spacing: 0.8em,
  )
  set enum(
    numbering: enum-numbering(theme.secondary),
    indent: 0.2em,
    body-indent: 0.65em,
    spacing: 0.8em,
  )
  set terms(separator: h(0.7em, weak: true), hanging-indent: 1.4em)
  set footnote.entry(
    separator: line(length: 25%, stroke: 0.5pt + theme.separator),
  )
  show footnote.entry: set text(size: 8pt, fill: theme.secondary)
  show quote.where(block: true): it => block(
    width: 100%,
    inset: (x: 1.4em),
    above: 1.6em,
    below: 1.6em,
    {
      set text(size: 1.05em, fill: theme.secondary)
      set par(leading: 0.6em)
      it.body
      if it.attribution != none {
        v(0.5em, weak: true)
        align(end, text(size: 0.85em, it.attribution))
      }
    },
  )

  // Headings.
  show heading: set text(font: theme.fonts.heading, fill: theme.ink)
  show heading.where(level: 1): it => chapter-heading(theme, it)
  show heading.where(level: 2): it => section-heading(
    theme,
    it,
    size: 15pt,
    tracking: -0.01em,
    above: 2.2em,
    below: 0.9em,
  )
  show heading.where(level: 3): it => section-heading(theme, it, size: 11.5pt)
  show heading.where(level: 4): it => section-heading(
    theme,
    it,
    size: 10pt,
    above: 1.4em,
    below: 0.7em,
  )

  // Web links take the accent; references and e-mail stay plain text,
  // except references to tables and figures, which take the reference gray.
  show ref: it => if (
    it.element != none
      and it.element.func() == figure
      and not is-mark-figure(it.element)
  ) { text(fill: theme.reference, it) } else { it }
  // Web links become footnotes: a gray superscript in the text, the URL at
  // the foot of the page.
  show link: show-link.with(theme)
  show footnote: set text(fill: theme.reference)

  // Code: monochrome, on the fill gray.
  set raw(theme: none)
  show raw: set text(font: theme.fonts.mono)
  show raw.where(block: false): it => highlight(
    fill: theme.fill,
    top-edge: "ascender",
    bottom-edge: "descender",
    extent: 1.5pt,
    radius: 3pt,
    no-glossary(it),
  )
  show raw.where(block: true): it => block(
    width: 100%,
    fill: theme.fill,
    radius: 8pt,
    inset: (x: 14pt, y: 12pt),
    breakable: true,
    {
      set text(size: 8.2pt)
      set par(leading: 0.55em)
      no-glossary(it)
    },
  )

  // Tables: hairlines only, a darker rule under the header.
  set table(
    inset: (x: 6pt, y: 5.5pt),
    align: left + top,
    stroke: (_, y) => if y == 0 { (bottom: 0.75pt + theme.ink) } else {
      (bottom: 0.5pt + theme.separator)
    },
  )
  show table: set text(size: 8.8pt, hyphenate: true)
  show table: set par(leading: 0.55em, spacing: 0.75em)
  show table.cell.where(y: 0): set text(weight: "semibold", fill: theme.ink)
  set figure(gap: 0.8em)
  show figure: set block(breakable: true)
  show figure.caption: it => align(left, text(size: 8.5pt, {
    text(weight: "semibold", fill: theme.accent)[
      #it.supplement #context it.counter.display(it.numbering)
    ]
    h(0.6em)
    text(fill: theme.secondary, no-glossary(it.body))
  }))
  show figure: it => if is-mark-figure(it) { it.body } else { it }

  // Contents: chapters semibold without leaders; faint leaders below.
  set outline.entry(fill: repeat(text(fill: theme.separator)[.], gap: 0.3em))
  show outline.entry.where(level: 1): it => {
    if it.element.func() != heading { return it }
    set block(above: 1.2em)
    set text(weight: "semibold")
    link(it.element.location(), it.indented(it.prefix(), [
      #it.body()#h(1fr)#it.page()
    ]))
  }

  theme-state.update(theme)
  accessed-state.update(if type(links-accessed) == datetime {
    format-date(links-accessed)
  } else { links-accessed })

  cover-page(
    theme,
    title: title,
    subtitle: subtitle,
    doc-type: doc-type,
    classification: classification,
    organisation: organisation,
    authors: authors,
    logo: logo,
    draft: is-draft,
  )

  // Front matter, numbered in roman.
  set page(
    margin: (x: 24mm, top: 26mm, bottom: 24mm),
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
    organisation: organisation,
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
  glossary-page(glossary)

  // Body, numbered from 1.
  set page(
    numbering: "1",
    header: body-header(theme, short-title, is-draft),
    footer: body-footer(theme, footer-left),
  )
  counter(page).update(1)
  set heading(numbering: heading-numbering(start: heading-start))
  apply-glossary(glossary, theme, body)
}
