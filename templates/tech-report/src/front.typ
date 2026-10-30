// Front matter after the cover: document control, contents and registers.

#import "utils.typ": as-array, format-date, person-line
#import "marks.typ": marks-key, register
#import "glossary.typ": glossary-list

#let front-heading(level: 1, body) = heading(
  level: level,
  numbering: none,
  outlined: false,
  bookmarked: true,
  body,
)

// The document's facts: bold labels and hairlines, without a header row.
// The first row is data, so it drops the header styling tables give row 0.
#let facts-table(theme, rows) = {
  show table.cell.where(y: 0): set text(weight: "regular", fill: theme.ink)
  table(
    columns: (auto, 1fr),
    stroke: (_, y) => (
      top: if y == 0 { 0.5pt + theme.separator },
      bottom: 0.5pt + theme.separator,
    ),
    ..rows.map(((key, value)) => (strong(key), value)).flatten(),
  )
}

#let people(value) = {
  let items = as-array(value)
  if items.len() == 0 { none } else {
    items.map(person-line).join(linebreak())
  }
}

#let document-control(
  theme,
  title: none,
  doc-id: none,
  version: none,
  status: none,
  date: none,
  classification: none,
  organisation: none,
  owner: none,
  authors: (),
  reviewers: (),
  approvers: (),
  distribution: (),
  handling: none,
  notice: none,
  history: (),
  specs: (:),
) = {
  front-heading[Document control]

  facts-table(theme, (
    ("Title", title),
    ("Document ID", doc-id),
    ("Version", version),
    ("Status", status),
    ("Date", format-date(date)),
    ("Classification", classification),
    ("Organisation", organisation),
    ("Owner", people(owner)),
    ("Authors", people(authors)),
    ("Reviewers", people(reviewers)),
    ("Approvers", people(approvers)),
    ("Distribution", people(distribution)),
  ).filter(((_, value)) => value != none))

  if handling != none {
    front-heading(level: 2)[Handling]
    handling
  }

  if notice != none {
    front-heading(level: 2)[About this version]
    notice
  }

  if as-array(history).len() > 0 {
    front-heading(level: 2)[Revision history]
    table(
      columns: (auto, auto, auto, 1fr),
      table.header([Version], [Date], [Author], [Change]),
      ..as-array(history)
        .map(entry => (
          entry.at("version", default: []),
          format-date(entry.at("date", default: [])),
          person-line(entry.at("author", default: [])),
          entry.at("change", default: []),
        ))
        .flatten(),
    )
  }

  if specs.values().any(spec => spec.at("description", default: none) != none) {
    front-heading(level: 2)[How to read the status marks]
    marks-key(specs)
  }
}

#let registers(specs, list-of-tables: true, list-of-figures: false) = {
  for (name, spec) in specs {
    let title = spec.at("register", default: none)
    if title != none { register(name, title: title) }
  }
  if list-of-tables {
    context if query(figure.where(kind: table)).len() > 0 {
      outline(title: [Tables], target: figure.where(kind: table))
    }
  }
  if list-of-figures {
    context if query(figure.where(kind: image)).len() > 0 {
      outline(title: [Figures], target: figure.where(kind: image))
    }
  }
}

#let glossary(entries) = glossary-list(entries, front-heading)
