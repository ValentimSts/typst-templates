// Status marks: callouts each document defines for itself, such as open
// decisions or unverified facts. `marks()` turns a dictionary of specs into
// one function per mark. A mark whose spec has a `register` becomes a
// labelled, referenceable entry when it is given an `id`, so `@O4` links to
// it and `register()` can list it.

#import "theme.typ": theme-state, tone-color
#import "utils.typ": page-label

#let mark-kind(name) = "tech-report-mark-" + name

#let is-mark-figure(it) = (
  type(it.kind) == str and it.kind.starts-with("tech-report-mark-")
)

// The small uppercase label used in a mark's header and in the key.
#let mark-chip(theme, spec) = {
  let tone = tone-color(theme, spec.at("tone", default: "neutral"))
  text(
    size: 0.78em,
    weight: "bold",
    tracking: 0.07em,
    fill: tone.darken(15%),
    upper(spec.at("label", default: spec.at("name", default: ""))),
  )
}

#let mark-box(spec, id: none, title: none, mention: false, body) = context {
  let theme = theme-state.get()
  let tone = tone-color(theme, spec.tone)
  // A mention points back at the canonical entry when one exists.
  let id-part = if id == none { none } else if (
    mention and query(label(id)).len() > 0
  ) { link(label(id), id) } else { id }
  block(
    width: 100%,
    breakable: true,
    fill: tone.lighten(94%),
    stroke: (left: 2.5pt + tone),
    radius: (right: 2pt),
    inset: (left: 11pt, right: 10pt, top: 8pt, bottom: 9pt),
    above: 1.4em,
    below: 1.4em,
  )[
    // Canonical entries are figures, which centre their body by default.
    #set align(start)
    #set text(size: 0.94em)
    #set par(spacing: 0.85em)
    #block(sticky: true, below: 0.6em)[
      #mark-chip(theme, spec)
      #if id-part != none or title != none {
        h(0.5em)
        strong({
          id-part
          if id-part != none and title != none [ #sym.dot.c ]
          title
        })
      }
    ]
    #body
  ]
}

// Builds one mark function. Call it as `#decision(id: "O4", title: [..])[..]`
// for the canonical entry and add `mention: true` for shortened copies.
#let mark(
  name,
  label: none,
  tone: "neutral",
  register: none,
  description: none,
) = {
  let spec = (
    name: name,
    label: if label == none { name } else { label },
    tone: tone,
    register: register,
    description: description,
  )
  (id: none, title: none, mention: false, body) => {
    let shell = mark-box(spec, id: id, title: title, mention: mention, body)
    if register == none or id == none or mention { shell } else {
      [#figure(
          kind: mark-kind(name),
          supplement: none,
          numbering: _ => id,
          caption: title,
          outlined: false,
          shell,
        )#std.label(id)]
    }
  }
}

// One function per spec: `#let (decision, precedent) = marks(specs)`.
#let marks(specs) = {
  let out = (:)
  for (name, spec) in specs {
    out.insert(name, mark(name, ..spec))
  }
  out
}

// Sorts "O2" before "O10" and keeps prefixes grouped.
#let id-key(id) = id.replace(regex("\d+"), m => str(100000 + int(m.text)))

// A table of every canonical entry of one mark, ordered by id.
#let register(name, title: none) = context {
  let entries = query(figure.where(kind: mark-kind(name)))
  if entries.len() == 0 { return }
  let rows = entries
    .map(f => (
      id: (f.numbering)(1),
      title: if f.caption == none { [] } else { f.caption.body },
      loc: f.location(),
    ))
    .sorted(key: e => id-key(e.id))
  if title != none {
    heading(level: 1, numbering: none, outlined: false, bookmarked: true, title)
  }
  table(
    columns: (auto, 1fr, auto),
    align: (left, left, right),
    table.header([ID], [Title], [Page]),
    ..rows
      .map(e => (
        link(e.loc, strong(e.id)),
        link(e.loc, e.title),
        link(e.loc, page-label(e.loc)),
      ))
      .flatten(),
  )
}

// "How to read the marks": each mark that has a description, with its chip.
#let marks-key(specs) = context {
  let theme = theme-state.get()
  let described = specs
    .pairs()
    .filter(((_, spec)) => spec.at("description", default: none) != none)
  if described.len() == 0 { return }
  grid(
    columns: (auto, 1fr),
    column-gutter: 14pt,
    row-gutter: 10pt,
    align: (left + top, left + top),
    ..described
      .map(((name, spec)) => (
        box(
          fill: tone-color(theme, spec.at("tone", default: "neutral")).lighten(
            94%,
          ),
          stroke: (
            left: 2pt + tone-color(theme, spec.at("tone", default: "neutral")),
          ),
          inset: (x: 6pt, y: 4pt),
          mark-chip(theme, (name: name) + spec),
        ),
        spec.description,
      ))
      .flatten(),
  )
}
