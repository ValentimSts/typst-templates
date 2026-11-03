#import "@local/carmelites:0.1.0": *

// Every component of a formation handout, with Portuguese placeholder text,
// for checking the look after a change. From templates/carmelites:
//   typst watch example/formation.typ

#show: formation.with(
  group: "Grupo de Jovens Carmelitas em Lisboa",
  date: datetime(year: 2026, month: 10, day: 21),
  motto: "Tema do ano pastoral",
  series: [Título do ciclo de formação],
  part: 2,
  title: [Título da sessão, que pode ser longo e ocupar mais de uma linha],
)

= Título do primeiro texto
#source[Autor, _Título da obra: subtítulo da obra_, 12]

#placeholder(160)

#placeholder(90, from: 30)#footnote[Autor, _Título da obra_ (1974), p. 568.]
#placeholder(40, from: 120)

#quote(block: true)[«#placeholder(60, from: 15, end: ".»")]

#placeholder(110, from: 70)

= Título do segundo texto
#source[
  Autora#footnote[#placeholder(20, from: 50)
    https://www.vatican.va/content/vatican/pt.html],
  _Título da obra_. Lisboa: Editora, 1950, p. 96
]

#placeholder(55, from: 90)

#placeholder(80, from: 10)#footnote[Cf. 1Pd 3, 1.]

#notes(lines: 5)
