// The `cv` show rule and its components. Sections are level-one headings;
// entries set a bold title left and dates, a grade or a link right.

#import "@local/base:0.1.0": dash, merge-theme
#import "theme.typ": default-theme, theme-state
#import "contacts.typ": contact

// The centered header: the name in the display cut, then the contact line,
// its items kept apart by space and a hairline bar.
#let header(theme, name, contacts, icons) = {
  set align(center)
  block(below: 0.9em, text(
    font: theme.fonts.display,
    size: 26pt,
    weight: "semibold",
    tracking: -0.01em,
    name,
  ))
  let bar = box(height: 0.75em, baseline: 0.1em, line(
    angle: 90deg,
    length: 0.75em,
    stroke: 0.5pt + theme.separator,
  ))
  // Contact links stay gray; the accent is for links in the text.
  show link: set text(fill: theme.secondary)
  block(below: 0.4em, text(
    size: 8.8pt,
    fill: theme.secondary,
    contacts
      .pairs()
      .map(((kind, value)) => box(contact(kind, value, icons: icons)))
      .join(h(0.75em) + bar + h(0.75em)),
  ))
}

// An item of a section: a job, a project, a degree. `title` is bold on the
// left and `meta` (dates, a grade, a link) is set right on the same line;
// `subtitle` (organisation, place) follows in gray; the body is the
// description or a list.
#let entry(title: none, subtitle: none, meta: none, body) = context {
  let theme = theme-state.get()
  block(width: 100%, above: 1.5em, below: 1.5em, breakable: false, {
    grid(
      columns: (1fr, auto),
      column-gutter: 1.5em,
      strong(title), text(fill: theme.secondary, meta),
    )
    if subtitle != none {
      block(above: 0.45em, below: 0pt, text(fill: theme.secondary, subtitle))
    }
    if body != [] and body != none {
      block(above: 0.6em, below: 0pt, body)
    }
  })
}

// Labelled lines, such as skills by kind: a dictionary of label to content.
#let skills(items) = {
  // Lists of names: ragged, never hyphenated ("PostgreSQL", not "Post-greSQL").
  set par(justify: false)
  set text(hyphenate: false)
  grid(
    columns: (auto, 1fr),
    column-gutter: 1.4em,
    row-gutter: 0.75em,
    ..items.pairs().map(((label, value)) => (strong(label), value)).flatten(),
  )
}

// Languages and levels, joined by dot leaders.
#let languages(items) = context {
  let theme = theme-state.get()
  set par(spacing: 0.7em)
  for (language, level) in items.pairs() {
    par[#strong(language)#h(0.5em)#box(width: 1fr, repeat(
        gap: 0.3em,
        text(fill: theme.separator)[.],
      ))#h(0.5em)#level]
  }
}

#let cv(
  name: none,
  // In order: github, linkedin, email, phone, website, location, or any other
  // key, shown as given.
  contacts: (:),
  icons: true,
  paper: "a4",
  lang: "en",
  theme: (:),
  body,
) = {
  let theme = merge-theme(default-theme, theme)
  let author = if type(name) == str { name } else { () }

  set document(title: if name != none [#name, CV], author: author)
  set page(paper: paper, margin: (x: 17mm, top: 15mm, bottom: 15mm))
  set text(font: theme.fonts.body, size: 10pt, fill: theme.ink, lang: lang)
  set par(leading: 0.62em, spacing: 0.9em, justify: true)
  set strong(delta: 200)

  // Lists are marked by a short drawn rule instead of a bullet.
  set list(
    marker: dash(theme.secondary),
    indent: 0.15em,
    body-indent: 0.6em,
    spacing: 0.55em,
  )
  show link: set text(fill: theme.accent)

  show heading.where(level: 1): it => block(
    width: 100%,
    above: 1.9em,
    below: 1em,
    sticky: true,
    stack(
      spacing: 0.5em,
      text(size: 11pt, weight: "semibold", fill: theme.accent, it.body),
      line(length: 100%, stroke: 0.5pt + theme.separator),
    ),
  )

  theme-state.update(theme)
  header(theme, name, contacts, icons)
  body
}
