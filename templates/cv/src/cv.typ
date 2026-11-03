// The `cv` show rule and its components. Sections are level-one headings;
// entries set a bold title over a gray line of organisation and dates.

#import "@local/base:0.1.0": dot, merge-theme
#import "theme.typ": default-theme, theme-state
#import "contacts.typ": contact

// The centered header: the name in the display cut, an optional headline
// (the role sought), then the contact line, its items kept apart by space
// and a hairline bar.
#let header(theme, name, headline, contacts, icons) = {
  set align(center)
  block(below: 0.9em, text(
    font: theme.fonts.display,
    size: 26pt,
    weight: "semibold",
    tracking: -0.01em,
    name,
  ))
  if headline != none {
    block(above: 0pt, below: 0.85em, text(
      size: 11pt,
      weight: "medium",
      fill: theme.ink,
      headline,
    ))
  }
  let bar = box(height: 0.75em, baseline: 0.1em, line(
    angle: 90deg,
    length: 0.75em,
    stroke: 0.5pt + theme.separator,
  ))
  // Contact links stay gray; the accent is for links in the text.
  show link: set text(fill: theme.secondary)
  let items = contacts
    .pairs()
    .map(((kind, value)) => box(contact(kind, value, icons: icons)))
  let row(part) = part.join(h(0.75em) + bar + h(0.75em))
  // One row when it fits; otherwise two balanced rows, so that no bar is
  // left hanging at the end of a line.
  block(below: 0.4em, text(size: 8.8pt, fill: theme.secondary, layout(
    size => {
      if measure(row(items)).width <= size.width { row(items) } else {
        let half = calc.ceil(items.len() / 2)
        row(items.slice(0, half))
        linebreak()
        row(items.slice(half))
      }
    },
  )))
}

// An item of a section: a job, a project, a degree. `title` is bold; under
// it, in gray, `subtitle` (organisation), `location` (city, country) and
// `meta` (dates, a grade, a link) share one line, kept apart by middle dots;
// the body is the description or a list. Dates are not set right: a parser
// takes a wide empty gap for a column break and, under an entry with a short
// body, binds right-set dates to the wrong entry.
#let entry(
  title: none,
  subtitle: none,
  location: none,
  meta: none,
  body,
) = context {
  let theme = theme-state.get()
  let details = (subtitle, location, meta).filter(part => part != none)
  // A typed middle dot (U+00B7), not a drawn one: a drawn shape leaves no
  // delimiter in the text a parser reads, which then runs the organisation,
  // place and dates together.
  let sep = [#h(0.3em)#text(fill: theme.separator)[\u{b7}]#h(0.3em)]
  // A long entry may break across pages, but its heading (title and
  // details) is sticky, so it never sits at the foot of a page apart from
  // the text it introduces.
  let has-body = body != [] and body != none
  block(width: 100%, above: 1.3em, below: 1.3em, {
    block(below: 0pt, sticky: has-body, breakable: false, {
      par(justify: false, strong(title))
      if details.len() > 0 {
        // A link here (a project's repository) stays gray like the rest of
        // the line, as in the contact line.
        show link: set text(fill: theme.secondary)
        block(above: 0.45em, below: 0pt, par(justify: false, text(
          fill: theme.secondary,
          details.map(box).join(sep),
        )))
      }
    })
    if has-body {
      block(above: 0.85em, below: 0pt, body)
    }
  })
}

// How far a pill reaches past its text on each side.
#let pill-reach = 0.55em

// One skill on a soft gray pill. The pill is a highlight drawn behind
// inline text rather than a box around a block: a parser then reads the
// skills in order instead of as scattered blocks.
#let skill-pill(theme, name) = box(highlight(
  fill: theme.fill,
  radius: 1em,
  extent: pill-reach,
  top-edge: 1.1em,
  bottom-edge: -0.42em,
  text(size: 0.9em, name),
))

// Skills by kind: a dictionary of label to an array of skills. Each label
// is a small heading above its pills, in one column: a label column beside
// the pills would read to CV reviewers as a table. Content instead of an
// array is shown as written.
#let skills(items) = context {
  let theme = theme-state.get()
  // Lists of names: ragged, never hyphenated ("PostgreSQL", not "Post-greSQL").
  set par(justify: false, leading: 1.15em)
  set text(hyphenate: false)
  // A real comma between pills, in the separator gray, so that a parser
  // still splits the list where one skill ends. The space around it clears
  // the pills' reach and no more: a wider gap reads as a column break.
  let sep = [#h(pill-reach + 0.07em)#text(fill: theme.separator)[,]#h(
      pill-reach + 0.13em,
    )]
  for (label, value) in items.pairs() {
    block(above: 1.15em, below: 1.15em, breakable: false, {
      block(below: 0.85em, text(
        size: 0.85em,
        weight: "semibold",
        fill: theme.secondary,
        tracking: 0.05em,
        upper(label),
      ))
      // Inset by the pills' reach, so their edges line up with the label.
      if type(value) == array {
        pad(x: pill-reach, value.map(skill-pill.with(theme)).join(sep))
      } else { value }
    })
  }
}

// Languages and levels, joined by dot leaders. The dots are typed, not
// drawn: a parser treats a wide empty gap as a column break and would list
// the languages apart from their levels, while typed dots keep each pair on
// one line of text.
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
  // The role sought, under the name: "Cybersecurity Engineer".
  headline: none,
  // In order: github, linkedin, email, phone, website, location, or any other
  // key, shown as given.
  contacts: (:),
  icons: true,
  paper: "a4",
  // Body text size. Spacing is set in em, so a smaller size tightens the
  // whole layout evenly, as a one-page version needs.
  size: 10pt,
  lang: "en",
  theme: (:),
  body,
) = {
  let theme = merge-theme(default-theme, theme)
  let author = if type(name) == str { name } else { () }

  set document(title: if name != none [#name, CV], author: author)
  set page(paper: paper, margin: (x: 17mm, top: 15mm, bottom: 15mm))
  // No hyphenation, and no line break inside a hyphenated word: a parser
  // joins the two halves of a broken line, so "trace-ability" and
  // "two-level" would reach it as "traceability" and "twolevel".
  set text(
    font: theme.fonts.body,
    size: size,
    fill: theme.ink,
    lang: lang,
    hyphenate: false,
  )
  show regex("\w+(?:-\w+)+"): box
  set par(leading: 0.62em, spacing: 0.9em, justify: true)
  set strong(delta: 200)

  // Lists are marked by a drawn round bullet, not a typed glyph.
  set list(
    marker: dot(theme.secondary),
    indent: 0.15em,
    body-indent: 0.6em,
    spacing: 0.55em,
  )
  show link: set text(fill: theme.accent)

  show heading.where(level: 1): it => block(
    width: 100%,
    above: 1.7em,
    below: 1em,
    sticky: true,
    stack(
      spacing: 0.5em,
      text(size: 11pt, weight: "semibold", fill: theme.accent, it.body),
      line(length: 100%, stroke: 0.5pt + theme.separator),
    ),
  )

  theme-state.update(theme)
  header(theme, name, headline, contacts, icons)
  body
}
