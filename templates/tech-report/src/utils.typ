#let appendix-state = state("tech-report-appendix", false)

#let as-array(value) = {
  if value == none { () } else if type(value) == array { value } else {
    (value,)
  }
}

// Dates may be given as `datetime` or as preformatted text.
#let format-date(date) = {
  if type(date) == datetime {
    date.display("[day padding:none] [month repr:long] [year]")
  } else { date }
}

// A person is a string, content, or a dictionary with `name` and an
// optional `role` and `email`.
#let person-name(person) = {
  if type(person) == dictionary { person.name } else { person }
}

#let person-email(person) = {
  if type(person) == dictionary { person.at("email", default: none) } else {
    none
  }
}

#let person-line(person) = {
  if type(person) == dictionary and person.at("role", default: none) != none {
    [#person.name, #person.role]
  } else { person-name(person) }
}

#let plain-text(value) = {
  if type(value) == str { value } else if value == none { "" } else if (
    type(value) == content and value.has("text")
  ) { value.text } else if type(value) == content and value.has("children") {
    value.children.map(plain-text).join()
  } else if type(value) == content and value.has("body") {
    plain-text(value.body)
  } else { " " }
}

// Heading numbers. `start` shifts the first level (0 gives "0. Summary");
// appendices letter the first level instead.
#let heading-numbering(start: 1, appendix: false) = (..nums) => {
  let n = nums.pos()
  let first = if appendix { numbering("A", n.first()) } else {
    str(n.first() + start - 1)
  }
  ((first,) + n.slice(1).map(str)).join(".")
}

// The displayed number of a heading element, e.g. "4.2".
#let heading-number(element) = {
  numbering(element.numbering, ..counter(heading).at(element.location()))
}

// The displayed page number at a location, honouring roman front matter.
#let page-label(loc) = {
  let style = loc.page-numbering()
  let n = counter(page).at(loc).first()
  if style == none { str(n) } else { numbering(style, n) }
}
