#import "@local/carmelites:0.1.0": *
#import "gathering.typ": gathering

#show: prayer-guide.with(..gathering, title: [Oração da noite de sábado])

= Cântico inicial

// Paste the lyrics as they are: one line per line, a blank line between
// stanzas. `refrain:` adds a refrain marked R.; `columns: 2` sets the
// stanzas side by side.
#chant(
  "
  Primeira linha do cântico
  Segunda linha do cântico
  Terceira linha do cântico
",
)

= Do Evangelho segundo São Lucas
#source[Lc 1, 46-55]

// Readings in verse keep their lines with #verses; prose is typed as
// ordinary paragraphs.
#verses("
  Primeira linha da leitura
  Segunda linha da leitura
")

#hints(title: [Pistas para o tempo de silêncio])[
  - Primeira pista.
  - Segunda pista.
]

= Cântico final

#chant("
  Primeira linha do cântico
  Segunda linha do cântico
")
