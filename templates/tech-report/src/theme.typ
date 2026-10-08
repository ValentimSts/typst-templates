// Design tokens. A document overrides any subset through
// `report(theme: (..))`; the nested `fonts` and `tones` dictionaries merge
// key by key, so `theme: (tones: (info: blue))` keeps the other tones.

#let default-theme = (
  // Text and surfaces.
  ink: rgb("#1f2328"),
  muted: rgb("#59636e"),
  rule: rgb("#d1d9e0"),
  surface: rgb("#f6f8fa"),
  // Brand. `accent` is decorative (cover band, bars, rules) and may be a
  // light colour; `primary` must stay readable as text on white.
  accent: rgb("#1f4e79"),
  on-accent: white,
  primary: rgb("#1f4e79"),
  link: rgb("#1a5fb4"),
  code: rgb("#3b4252"),
  // Table header row.
  header-fill: rgb("#e9eef3"),
  on-header: rgb("#1f2328"),
  // Semantic tones used by marks.
  tones: (
    info: rgb("#2f6fb0"),
    success: rgb("#2e7d4f"),
    warning: rgb("#b25e00"),
    danger: rgb("#b42318"),
    neutral: rgb("#59636e"),
  ),
  fonts: (
    body: ("IBM Plex Sans", "Liberation Sans"),
    heading: ("IBM Plex Sans", "Liberation Sans"),
    mono: ("IBM Plex Mono", "DejaVu Sans Mono"),
  ),
)

// The theme in force, set once by `report()` and read by components that
// are defined before the show rule runs (marks).
#let theme-state = state("tech-report-theme", default-theme)

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

// A tone is either a name from `theme.tones`, "accent" for the brand
// colour, or a colour value.
#let tone-color(theme, tone) = {
  if type(tone) == color { tone } else if tone == "accent" {
    theme.primary
  } else { theme.tones.at(tone, default: theme.tones.neutral) }
}
