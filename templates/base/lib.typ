// base: what every template in this repository shares. Each template builds
// its `default-theme` on `grays`, merges a document's overrides with
// `merge-theme`, and draws its list markers instead of typing glyphs.
//
//   #import "@local/base:0.1.0": grays, merge-theme, dot, dash, enum-numbering

// Neutral grays at the levels of Apple's text and separator colours, without
// their blue cast.
#let grays = (
  ink: luma(29), // text
  secondary: luma(110), // labels, dates, captions, header and footer
  separator: luma(210), // hairlines and outlines
)

// `override` wins key by key; a dictionary value such as `fonts` is merged
// one level deep rather than replaced.
#let merge-theme(base, override) = {
  let out = base
  for (key, value) in override {
    let current = base.at(key, default: none)
    if type(value) == dictionary and type(current) == dictionary {
      out.insert(key, current + value)
    } else {
      out.insert(key, value)
    }
  }
  out
}

// Drawn list markers: no bullet glyphs in the chrome.
#let dot(fill) = box(height: 0.55em, align(horizon, circle(
  radius: 0.15em,
  fill: fill,
)))

#let dash(fill) = box(height: 0.55em, align(horizon, line(
  length: 0.42em,
  stroke: 0.09em + fill,
)))

// "1." in the given colour, for `set enum(numbering: ..)`.
#let enum-numbering(fill) = n => text(fill: fill, numbering("1.", n))

// The first grapheme in upper case; anything but a string passes through.
#let capitalise(value) = {
  if type(value) == str and value.len() > 0 {
    upper(value.first()) + value.slice(value.first().len())
  } else { value }
}
