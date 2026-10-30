// The contact line: known kinds get an icon and a link built from the value;
// anything else is shown as given. Icons are Font Awesome 7 glyphs, written
// as code points so the source stays ASCII.

// kind: (font, weight, glyph, url from value). Solid icons have their own
// family in the OTF release; the second name covers builds that merge them.
#let solid = ("Font Awesome 7 Free Solid", "Font Awesome 7 Free")

#let kinds = (
  github: (
    "Font Awesome 7 Brands",
    "regular",
    "\u{f09b}",
    v => "https://github.com/" + v,
  ),
  linkedin: (
    "Font Awesome 7 Brands",
    "regular",
    "\u{f08c}",
    v => "https://www.linkedin.com/in/" + v,
  ),
  email: (solid, "black", "\u{f0e0}", v => "mailto:" + v),
  phone: (
    solid,
    "black",
    "\u{f095}",
    v => "tel:" + v.replace(" ", ""),
  ),
  website: (
    solid,
    "black",
    "\u{f0ac}",
    v => if v.starts-with("http") { v } else { "https://" + v },
  ),
  location: (solid, "black", "\u{f3c5}", none),
)

#let icon(font, weight, glyph) = box(
  baseline: 0.08em,
  text(font: font, weight: weight, fallback: false, size: 0.95em, glyph),
)

// One entry of the contact line. `value` is a string; the shown text can be
// overridden with `(value: .., label: ..)`.
#let contact(kind, value, icons: true) = {
  let (shown, raw) = if type(value) == dictionary {
    (value.at("label", default: value.value), value.value)
  } else { (value, value) }
  let spec = kinds.at(kind, default: none)
  if spec == none { return shown }
  let (font, weight, glyph, to-url) = spec
  let body = if icons [#icon(font, weight, glyph)#h(0.35em)#shown] else {
    shown
  }
  if to-url == none or type(raw) != str { body } else {
    link(to-url(raw), body)
  }
}
