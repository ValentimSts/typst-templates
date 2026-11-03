// Design tokens: the shared grays and a single accent, the brown of the
// Discalced Carmelites as carmelitas.pt uses it. A document overrides any
// subset through `theme: (..)`; `fonts` merges key by key.

#import "@local/base:0.1.0": grays

#let default-theme = (
  ..grays,
  accent: rgb("#4a2700"), // the one colour: Carmelite brown
  fonts: (
    // Calibri, the face of the group's own documents. It is licensed with
    // Windows and Office; Carlito, its free metric-compatible stand-in
    // (ttf-carlito), takes over where Calibri is not installed.
    body: ("Calibri", "Carlito", "Liberation Sans"),
    // Labels: masthead, headings, the hints title, footer.
    labels: ("Calibri", "Carlito", "Liberation Sans"),
  ),
  body-weight: "regular",
)

// The theme in force, set once by the document function and read by the
// components, which are defined before the show rule runs.
#let theme-state = state("carmelites-theme", default-theme)

// A label in the labels face, bold by default as the group's own
// documents set their headings; `caps` sets it in capitals.
#let label-text(
  theme,
  body,
  size: 1em,
  fill: none,
  weight: "bold",
  tracking: 0em,
  caps: false,
) = text(
  font: theme.fonts.labels,
  size: size,
  fill: if fill == none { theme.ink } else { fill },
  weight: weight,
  tracking: tracking,
  if caps { upper(body) } else { body },
)
