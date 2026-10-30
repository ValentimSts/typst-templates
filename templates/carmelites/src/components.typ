// The building blocks of a guide or a handout. Each reads the theme in
// force from `theme-state`, so the same components serve both documents.
// What they print (R., "Pistas de oracao", "Notas") stays Portuguese.

#import "theme.typ": label-text, theme-state

// Pasted text split into stanzas (separated by blank lines) of lines.
#let stanzas-of(source) = {
  let out = ()
  let current = ()
  for line in source.split("\n") {
    let line = line.trim()
    if line == "" {
      if current.len() > 0 {
        out.push(current)
        current = ()
      }
    } else { current.push(line) }
  }
  if current.len() > 0 { out.push(current) }
  out
}

// One verse line is its own paragraph, so a line too long for the measure
// wraps with a hanging indent instead of passing for a new line. Lines are
// Typst markup: *bold*, _italic_ and #lorem(n) all work. `eval` here only
// turns the author's own text back into markup.
#let verse-line(line) = par(
  hanging-indent: 1.4em,
  first-line-indent: 0em,
  justify: false,
  eval(line, mode: "markup"),
)

// The lines of a stanza, or content as written (break lines with `\`).
#let stanza(lines) = {
  if type(lines) == array { lines.map(verse-line).join() } else { lines }
}

// Text kept line by line: a reading in verse, a psalm, a poem, a prayer
// said together. Give it as a string, with a blank line between stanzas.
#let verses(body) = context {
  set par(spacing: par.leading)
  let parsed = if type(body) == str { stanzas-of(body) } else { (body,) }
  for lines in parsed {
    block(above: 1em, below: 1em, stanza(lines))
  }
}

// A chant. `refrain` is shown first, in bold and marked R.; the stanzas
// follow, numbered when there is more than one (`numbered` overrides). Each
// stanza is a string (several, separated by blank lines, are split) or
// content. `columns: 2` sets the parts side by side, balanced by their line
// count, with a hairline between columns.
#let chant(refrain: none, columns: 1, numbered: auto, ..stanzas) = context {
  let theme = theme-state.get()
  let parsed = ()
  for s in stanzas.pos() {
    if type(s) == str { parsed += stanzas-of(s) } else { parsed.push(s) }
  }
  let numbered = if numbered == auto { parsed.len() > 1 } else { numbered }

  let parts = ()
  if refrain != none {
    let lines = if type(refrain) == str { stanzas-of(refrain).join() } else {
      refrain
    }
    parts.push((marker: [R.], lines: lines, bold: true))
  }
  for (i, lines) in parsed.enumerate() {
    parts.push((
      marker: if numbered [#(i + 1).],
      lines: lines,
      bold: false,
    ))
  }
  let marked = parts.any(p => p.marker != none)

  set par(spacing: par.leading)
  let gap = 1em
  // Each part stays whole; the refrain also stays with the stanza after it,
  // so it is never left alone at the foot of a page.
  let render(p) = block(
    breakable: false,
    sticky: p.bold,
    above: gap,
    below: gap,
    {
      set text(weight: "bold") if p.bold
      if marked {
        grid(
          columns: (1.9em, 1fr),
          text(weight: "bold", fill: theme.accent, p.marker), stanza(p.lines),
        )
      } else { stanza(p.lines) }
    },
  )

  block(above: 1em, below: 1.4em, if columns <= 1 {
    parts.map(render).join()
  } else {
    // Fill each column up to an even share of the lines. A part given as
    // content has no line count; it is taken for a stanza of four.
    let size(p) = if type(p.lines) == array { p.lines.len() } else { 4 }
    let share = parts.map(size).sum() / columns
    let groups = ((),)
    let filled = 0
    for p in parts {
      let full = filled + size(p) / 2 > share * groups.len()
      if full and groups.last().len() > 0 and groups.len() < columns {
        groups.push(())
      }
      groups.last().push(p)
      filled += size(p)
    }
    // Padding rather than a gutter, so the rule falls midway between columns.
    grid(
      columns: (1fr,) * columns,
      inset: (x, _) => (
        left: if x == 0 { 0pt } else { 1.2em },
        right: if x == columns - 1 { 0pt } else { 1.2em },
      ),
      ..range(1, columns).map(x => grid.vline(
        x: x,
        stroke: 0.5pt + theme.separator,
      )),
      ..groups.map(g => stack(spacing: gap, ..g.map(render))),
    )
  })
}

// The reference or source under a heading: "Lc 1, 46-55", or the author and
// work of a text. It stays with the heading and the text that follow.
#let source(body) = context {
  let theme = theme-state.get()
  block(above: 0.5em, below: 1.1em, sticky: true, text(
    size: 0.9em,
    fill: theme.secondary,
    body,
  ))
}

// An instruction, not to be read aloud: "Todos de pe", "Pausa de silencio".
#let rubric(body) = context {
  let theme = theme-state.get()
  block(above: 1em, below: 1em, text(
    size: 0.9em,
    style: "italic",
    fill: theme.accent,
    body,
  ))
}

// Pistas de Oracao: optional hints for personal prayer, inside a fine
// brown frame with the title set into its top line, numbered in roman
// numerals. Each hint stays whole; if the hints run over a page, every
// piece gets its own closed frame.
#let hints(title: [Pistas de oração], body) = context {
  let theme = theme-state.get()
  let label-size = 11pt
  let top-inset = 20pt
  block(
    width: 100%,
    above: 2em,
    below: 1.6em,
    stroke: 0.6pt + theme.accent.lighten(55%),
    inset: (x: 18pt, top: top-inset, bottom: 16pt),
    breakable: true,
    {
      // The title sits on the frame's top line, over a patch of paper. As the
      // frame's first content it is drawn over the line, and it lands on the
      // first piece when the frame breaks across pages.
      {
        set text(size: label-size)
        place(top + center, dy: -top-inset - 0.42em, box(
          fill: white,
          inset: (x: 0.8em),
          label-text(theme, title, size: label-size, fill: theme.accent),
        ))
      }
      set par(justify: true)
      // Hints are numbered I, II, III in small capitals, each kept whole and
      // set well apart, whether written as a list (-) or an enum (+).
      let numbered(it) = for (i, item) in it.children.enumerate() {
        block(above: 1.1em, below: 1.1em, breakable: false, grid(
          columns: (2.2em, 1fr),
          label-text(
            theme,
            numbering("I", i + 1),
            size: label-size,
            fill: theme.accent,
          ),
          item.body,
        ))
      }
      show list: numbered
      show enum: numbered
      body
    },
  )
}

// Intercessions: the people's response, then the intentions as a list.
#let intercessions(response: none, body) = context {
  let theme = theme-state.get()
  if response != none {
    block(above: 0.8em, below: 1em, sticky: true, grid(
      columns: (1.9em, 1fr),
      text(weight: "bold", fill: theme.accent)[R.], strong(response),
    ))
  }
  body
}

// Ruled lines for notes taken by hand during the session.
#let notes(lines: 6, title: [Notas]) = context {
  let theme = theme-state.get()
  block(width: 100%, above: 2em, breakable: false, {
    label-text(theme, title, size: 10pt, fill: theme.secondary)
    v(2pt)
    stack(
      spacing: 8.5mm,
      v(0pt),
      ..range(lines).map(_ => line(
        length: 100%,
        stroke: 0.5pt + theme.separator,
      )),
    )
  })
}
