// The glossary: abbreviations a document uses, as in research papers. Every
// entry the body uses at least twice is listed after the front-matter
// lists, and its first use in the body reads "full name (ABBR)". A use
// written "(ABBR)" counts as the author's own definition and is left as is;
// a hyphenated compound ("AKS-required") is never expanded.

#import "@local/base:0.1.0": capitalise

#let skip-depth = state("tech-report-glossary-skip", 0)
#let uses(key) = counter("tech-report-glossary-uses:" + key)
#let defined(key) = counter("tech-report-glossary-defined:" + key)
// Where an entry sits in the Glossary, so every use can link to it.
#let anchor(key) = label("tech-report-glossary:" + key)

// Shows its body without treating abbreviations in it as glossary uses:
// for names that only contain one ("Argo CD"), and for headings, captions,
// callout titles and code.
#let no-glossary(body) = {
  skip-depth.update(n => n + 1)
  body
  skip-depth.update(n => n - 1)
}

#let escape(key) = key.replace(regex("[\\\\.*+?^$(){}|\\[\\]/-]"), m => (
  "\\" + m.text
))

// One pattern for every key, longest first so "CI/CD" wins over "CI", with
// what the show rule needs to see around it: an article, parentheses and
// hyphens.
#let pattern(keys) = regex(
  "(?:\\b[Aa]n? )?\\(?-?\\b(?:"
    + keys.sorted(key: k => -k.len()).map(escape).join("|")
    + ")s?\\b-?\\)?",
)

// "a" or "an" for a full name, by its first sound.
#let article-for(words) = {
  let w = lower(words)
  if ("eu", "uni", "use", "usu", "one").any(p => w.starts-with(p)) {
    "a"
  } else if (
    ("a", "e", "i", "o", "u", "hour", "honest").any(p => w.starts-with(p))
  ) { "an" } else { "a" }
}

#let apply-glossary(entries, theme, body) = {
  if entries.len() == 0 { return body }
  show pattern(entries.keys()): it => context {
    if skip-depth.get() > 0 { return it }
    let parts = it.text.match(
      regex(
        "^(?:([Aa]n?) )?(\\(?)(-?)(.+?)(-?)(\\)?)$",
      ),
    )
    if parts == none { return it }
    let (article, open-paren, lead, core, trail, close-paren) = parts.captures
    let opens = open-paren != ""
    let closes = close-paren != ""
    let compound = lead != "" or trail != ""
    let plural = core not in entries and core.ends-with("s")
    let key = if plural { core.slice(0, -1) } else { core }
    if key not in entries { return it }
    let listed = uses(key).final().first() >= 2
    // The first plain use of a listed entry defines it. "(ABBR)" is the
    // author's own definition, so it is shown as written.
    let defines = (
      listed and not compound and defined(key).get().first() == 0
    )
    // Listed entries link to the Glossary, in the reference gray.
    let short = if listed {
      link(anchor(key), text(fill: theme.reference, core))
    } else { core }
    let shown = if not listed { it } else if (
      defines and not (opens and closes)
    ) {
      let meaning = entries.at(key)
      let full = if plural { meaning + "s" } else { meaning }
      // The article was chosen for the abbreviation; choose again.
      let lead-in = if article == none { "" } else {
        let fitting = article-for(full)
        let fitting = if article.starts-with("A") {
          upper(fitting.first()) + fitting.slice(1)
        } else { fitting }
        fitting + " "
      }
      [#lead-in#open-paren#full (#short)#close-paren]
    } else {
      let lead-in = if article == none { "" } else { article + " " }
      [#lead-in#open-paren#lead#short#trail#close-paren]
    }
    [#uses(key).step()#if defines { defined(key).step() }#shown]
  }
  body
}

// The list itself: entries used at least twice, sorted, in two columns.
#let glossary-list(entries, heading-fn) = context {
  let listed = entries
    .pairs()
    .filter(((key, _)) => uses(key).final().first() >= 2)
    .sorted(key: ((key, _)) => lower(key))
  if listed.len() == 0 { return }
  heading-fn[Glossary]
  set text(size: 9pt)
  columns(2, gutter: 10mm, grid(
    columns: (auto, 1fr),
    column-gutter: 10pt,
    row-gutter: 5.5pt,
    ..listed
      .map(((key, meaning)) => (
        [#metadata(key)#anchor(key)#strong(key)],
        capitalise(meaning),
      ))
      .flatten(),
  ))
}
