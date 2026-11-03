// Design tokens: the shared grays, a fill and a reference gray, and one
// accent for signposts: heading numbers, mark and caption labels, the
// cover's eyebrow, web links. A document overrides any subset through
// `report(theme: (..))`; `fonts` merges key by key.

#import "@local/base:0.1.0": grays

#let default-theme = (
  ..grays,
  fill: luma(245), // callouts, code, inline code
  reference: luma(110), // glossary terms and table and figure references
  accent: rgb("#ea580c"), // the one colour: pumpkin orange
  fonts: (
    body: ("Inter", "Liberation Sans"),
    heading: ("Inter", "Liberation Sans"),
    // Large type (cover title, chapter titles), as Apple switches to its
    // Display cut from 20 pt.
    display: ("Inter Display", "Inter", "Liberation Sans"),
    // The ancestor of Menlo, and bundled with Typst.
    mono: ("DejaVu Sans Mono",),
  ),
)

// The theme in force, set once by `report()` and read by components that
// are defined before the show rule runs (marks).
#let theme-state = state("tech-report-theme", default-theme)

// A small rounded capsule, used for status and classification labels.
#let pill(theme, body, filled: false) = box(
  fill: if filled { theme.fill },
  stroke: if filled { none } else { 0.75pt + theme.separator },
  radius: 8pt,
  inset: (x: 7pt, y: 3pt),
  text(size: 7.5pt, weight: "medium", fill: theme.secondary, body),
)
