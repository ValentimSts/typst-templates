// The cover page: identity at the top, the title block, and the authors.
// Document metadata lives on the document control page instead.

#import "theme.typ": pill
#import "utils.typ": as-array, person-email, person-name

// A logo is a `path(..)` (resolved relative to the file that made it) or
// ready-made content such as `image(..)`.
#let render-logo(logo) = {
  if type(logo) == str {
    panic(
      "tech-report: pass the logo as path(\""
        + logo
        + "\") so it resolves relative to your document",
    )
  }
  if type(logo) == content { logo } else { image(logo, height: 10mm) }
}

#let author-block(theme, person) = {
  let email = person-email(person)
  text(size: 10pt, weight: "semibold", fill: theme.ink, person-name(person))
  if email != none {
    linebreak()
    link("mailto:" + email, text(size: 9pt, fill: theme.secondary, email))
  }
}

#let cover-page(
  theme,
  title: none,
  subtitle: none,
  doc-type: none,
  classification: none,
  organisation: none,
  authors: (),
  logo: none,
  draft: false,
) = page(
  margin: (x: 24mm, top: 26mm, bottom: 24mm),
  header: none,
  footer: none,
  numbering: none,
  background: none,
)[
  #let pills = (
    if classification != none { pill(theme, classification) },
    if draft { pill(theme, filled: true)[Draft] },
  ).filter(p => p != none)
  #grid(
    columns: (1fr, auto),
    align: (left + horizon, right + horizon),
    if logo != none { render-logo(logo) } else if organisation != none {
      text(size: 10pt, weight: "semibold", fill: theme.ink, organisation)
    },
    stack(dir: ltr, spacing: 6pt, ..pills),
  )

  #v(1fr)

  #if doc-type != none {
    block(below: 14pt, text(
      size: 11pt,
      weight: "semibold",
      fill: theme.accent,
      doc-type,
    ))
  }
  #block(below: 14pt, {
    set par(leading: 0.28em)
    text(
      font: theme.fonts.display,
      size: 40pt,
      weight: "semibold",
      tracking: -0.015em,
      fill: theme.ink,
      title,
    )
  })
  #if subtitle != none {
    block({
      set par(leading: 0.45em)
      text(size: 17pt, tracking: -0.01em, fill: theme.secondary, subtitle)
    })
  }

  #v(1.6fr)

  #let people = as-array(authors)
  #if people.len() > 0 {
    block(below: 8pt, text(
      size: 8.5pt,
      fill: theme.secondary,
      if people.len() > 1 [Authors] else [Author],
    ))
    grid(
      columns: calc.min(people.len(), 3),
      column-gutter: 32pt,
      row-gutter: 14pt,
      ..people.map(person => author-block(theme, person)),
    )
  }
]
