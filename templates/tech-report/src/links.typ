// Web links as footnotes, as in research papers: the linked word gets a
// superscript number and the URL is set at the foot of the page, with the
// access date when the document gives one. A bare URL leaves only the number.

#import "theme.typ": theme-state

#let inline-depth = state("tech-report-inline-links", 0)
#let accessed-state = state("tech-report-links-accessed", none)

// Shows its body with URLs written out in place instead of as footnotes,
// for lists of sources.
#let inline-links(body) = {
  inline-depth.update(n => n + 1)
  body
  inline-depth.update(n => n - 1)
}

#let is-web(it) = type(it.dest) == str and not it.dest.starts-with("mailto:")

// The URL as the template sets it. It is a link itself, so it carries a
// label that `show-link` passes over: without it, the URL inside a footnote
// would become another footnote, and so on without end.
#let url-text(theme, dest) = [#link(dest, text(
  font: theme.fonts.mono,
  size: 0.95em,
  fill: theme.accent,
  dest,
))<tech-report-url>]

#let url-note(theme, dest, accessed) = {
  url-text(theme, dest)
  if accessed != none [, last accessed on #accessed.]
}

// The show rule for links: footnotes in running text, URLs in place inside
// `inline-links`.
#let show-link(theme, it) = {
  if not is-web(it) { return it }
  if it.at("label", default: none) == <tech-report-url> { return it }
  context {
    let bare = it.body.has("text") and it.body.text == it.dest
    if inline-depth.get() > 0 {
      if bare { url-text(theme, it.dest) } else {
        text(fill: theme.accent, it)
      }
    } else {
      if not bare { it.body }
      footnote(url-note(theme, it.dest, accessed-state.get()))
    }
  }
}

// Several sources for one statement: footnote numbers separated by a
// superscript comma, so that 1 and 2 never read as 12.
#let links(..urls) = context {
  let theme = theme-state.get()
  urls.pos().map(u => link(u)).join(super(text(fill: theme.reference)[,]))
}
