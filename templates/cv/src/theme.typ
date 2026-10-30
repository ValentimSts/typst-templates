// Design tokens. A CV is all black tones: the accent (section titles, links)
// is the text colour by default, and can be set to a colour through
// `cv(theme: (accent: ..))`; `fonts` merges key by key.

#import "@local/base:0.1.0": grays

#let default-theme = (
  ..grays,
  accent: luma(29), // section titles and links: black like the text
  fonts: (
    body: ("Inter", "Liberation Sans"),
    // The name, as Apple switches to its Display cut for large sizes.
    display: ("Inter Display", "Inter", "Liberation Sans"),
  ),
)

// The theme in force, set once by `cv()` and read by the components.
#let theme-state = state("cv-theme", default-theme)
