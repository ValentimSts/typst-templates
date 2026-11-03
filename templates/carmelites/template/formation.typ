#import "@local/carmelites:0.1.0": *
#import "gathering.typ": gathering

#show: formation.with(
  ..gathering,
  series: [Título do ciclo de formação],
  part: 1,
  title: [Título da sessão],
)

= Título do primeiro texto
#source[Autor, _Título da obra_, página]

Primeiro parágrafo do texto.#footnote[Referência da citação.]

#quote(block: true)[«Citação longa.»]

Parágrafo seguinte.

= Título do segundo texto
#source[Autor, _Título da obra_]

Texto.

#notes(lines: 5)
