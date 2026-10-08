// The cover page: a brand band, the title block, key metadata and the
// handling statement.

#import "utils.typ": as-array, format-date, person-line

#let classification-chip(theme, classification) = box(
  stroke: 0.8pt + theme.ink,
  radius: 2pt,
  inset: (x: 7pt, y: 4pt),
  text(
    size: 8pt,
    weight: "bold",
    tracking: 0.08em,
    fill: theme.ink,
    upper(classification),
  ),
)

// A logo is a `path(..)` (resolved relative to the document) or ready-made
// content such as `image(..)`.
#let render-logo(logo) = {
  if type(logo) == str {
    panic(
      "tech-report: pass the logo as path(\""
        + logo
        + "\") so it resolves relative to your document",
    )
  }
  if type(logo) == content { logo } else { image(logo, height: 12mm) }
}

#let cover-label(theme, body) = text(
  size: 7.5pt,
  weight: "bold",
  tracking: 0.08em,
  fill: theme.muted,
  upper(body),
)

#let cover-page(
  theme,
  title: none,
  subtitle: none,
  doc-type: none,
  doc-id: none,
  version: none,
  status: none,
  date: none,
  classification: none,
  organisation: none,
  authors: (),
  handling: none,
  logo: none,
) = page(
  margin: (left: 38mm, right: 22mm, top: 26mm, bottom: 24mm),
  header: none,
  footer: none,
  numbering: none,
  background: place(left + top, rect(
    width: 18mm,
    height: 100%,
    fill: theme.accent,
  )),
)[
  #grid(
    columns: (1fr, auto),
    align: (left + horizon, right + horizon),
    if logo != none { render-logo(logo) } else if organisation != none {
      text(
        size: 10pt,
        weight: "bold",
        tracking: 0.08em,
        fill: theme.ink,
        upper(organisation),
      )
    },
    if classification != none { classification-chip(theme, classification) },
  )

  #v(1.3fr)

  #if doc-type != none {
    block(below: 12pt, text(
      size: 10pt,
      weight: "bold",
      tracking: 0.1em,
      fill: theme.primary,
      upper(doc-type),
    ))
  }
  #block(below: 12pt, {
    set par(leading: 0.35em)
    text(size: 34pt, weight: "bold", fill: theme.ink, title)
  })
  #if subtitle != none {
    block(below: 0pt, {
      set par(leading: 0.5em)
      text(size: 15pt, fill: theme.muted, subtitle)
    })
  }
  #v(18pt)
  #rect(width: 36mm, height: 3.5pt, fill: theme.accent)
  #v(18pt)

  #let rows = (
    ("Document ID", doc-id),
    ("Version", version),
    ("Status", status),
    ("Date", format-date(date)),
    (
      if as-array(authors).len() > 1 { "Authors" } else { "Author" },
      as-array(authors).map(person-line).join(linebreak()),
    ),
    ("Organisation", if logo != none { organisation }),
  ).filter(((_, value)) => value != none)
  #grid(
    columns: (auto, 1fr),
    column-gutter: 16pt,
    row-gutter: 8pt,
    align: (left + top, left + top),
    ..rows
      .map(((key, value)) => (
        cover-label(theme, key),
        text(size: 9.5pt, value),
      ))
      .flatten(),
  )

  #v(1fr)

  #if handling != none {
    block(
      width: 100%,
      inset: (left: 10pt, y: 4pt),
      stroke: (left: 2pt + theme.accent),
    )[
      #cover-label(theme)[Handling]
      #v(3pt, weak: true)
      #text(size: 8.5pt, fill: theme.ink, handling)
    ]
  }
]
