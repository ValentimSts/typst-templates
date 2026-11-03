// The contact line: known kinds get an icon, a link built from the value
// and, for profiles, the address written out; anything else is shown as
// given. Icons are Font Awesome 7 glyphs, written as code points so the
// source stays ASCII.

// Solid icons have their own family in the OTF release; the second name
// covers builds that merge them.
#let solid = ("Font Awesome 7 Free Solid", "Font Awesome 7 Free")
#let brands = "Font Awesome 7 Brands"

// Profiles show their address without the scheme ("github.com/user"), so a
// parser that reads only the text still finds a link it can recognise.
#let kinds = (
  github: (
    font: brands,
    weight: "regular",
    glyph: "\u{f09b}",
    url: v => "https://github.com/" + v,
    shown: v => "github.com/" + v,
  ),
  linkedin: (
    font: brands,
    weight: "regular",
    glyph: "\u{f08c}",
    url: v => "https://www.linkedin.com/in/" + v,
    shown: v => "linkedin.com/in/" + v,
  ),
  email: (
    font: solid,
    weight: "black",
    glyph: "\u{f0e0}",
    url: v => "mailto:" + v,
    shown: none,
  ),
  phone: (
    font: solid,
    weight: "black",
    glyph: "\u{f095}",
    url: v => "tel:" + v.replace(" ", ""),
    shown: none,
  ),
  website: (
    font: solid,
    weight: "black",
    glyph: "\u{f0ac}",
    url: v => if v.starts-with("http") { v } else { "https://" + v },
    shown: none,
  ),
  location: (
    font: solid,
    weight: "black",
    glyph: "\u{f3c5}",
    url: none,
    shown: none,
  ),
)

// The icon is decoration: marked as a PDF artifact, it stays out of the
// tagged text that accessibility tools and some parsers read.
#let icon(spec) = pdf.artifact(box(
  baseline: 0.08em,
  text(
    font: spec.font,
    weight: spec.weight,
    fallback: false,
    size: 0.95em,
    spec.glyph,
  ),
))

// One entry of the contact line. `value` is a string; the shown text can be
// overridden with `(value: .., label: ..)`.
#let contact(kind, value, icons: true) = {
  let (label, raw) = if type(value) == dictionary {
    (value.at("label", default: none), value.value)
  } else { (none, value) }
  let spec = kinds.at(kind, default: none)
  if spec == none { return if label == none { raw } else { label } }
  let shown = if label != none { label } else if (
    spec.shown != none and type(raw) == str
  ) { (spec.shown)(raw) } else { raw }
  let body = if icons [#icon(spec)#h(0.35em)#shown] else { shown }
  if spec.url == none or type(raw) != str { body } else {
    link((spec.url)(raw), body)
  }
}
