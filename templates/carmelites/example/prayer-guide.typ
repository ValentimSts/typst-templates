#import "@local/carmelites:0.1.0": *

// Every component of a prayer guide, with Portuguese placeholder text, for
// checking the look after a change. From templates/carmelites:
//   typst watch example/prayer-guide.typ

#show: prayer-guide.with(
  group: "Grupo de Jovens Carmelitas em Fátima",
  date: (
    datetime(year: 2026, month: 12, day: 4),
    datetime(year: 2026, month: 12, day: 6),
  ),
  motto: "Tema do ano pastoral",
  title: [Eucaristia de domingo],
  subtitle: [II Domingo do Advento],
)

= Cântico de entrada

#chant(
  refrain: placeholder-lines(5, 4, 6, 3),
  placeholder-lines(from: 20, 6, 5, 7, 4),
  placeholder-lines(from: 40, 5, 6, 4, 6),
)

#rubric[Todos de pé.]

= Primeira leitura
#source[Is 40, 1-5. 9-11]

#placeholder(70, from: 60)

#placeholder(40, from: 130)

= Salmo responsorial
#source[Sl 84 (85)]

#chant(
  refrain: placeholder-lines(from: 60, 7),
  placeholder-lines(from: 70, 7, 5, 8, 4),
  placeholder-lines(from: 95, 6, 7, 5, 6),
)

= Evangelho
#source[Mc 1, 1-8]

#verses(
  placeholder-lines(from: 120, 3, 9, 7, 11, 6)
    + "\n\n"
    + placeholder-lines(from: 160, 8, 14, 6),
)

= Oração dos fiéis

#intercessions(response: [Senhor, escutai a nossa prece.])[
  - #placeholder(18, from: 10)
  - #placeholder(14, from: 40)
  - #placeholder(20, from: 70)
]

#hints(title: [Pistas para o tempo de silêncio])[
  - #placeholder(45, from: 5) O que desperta em mim esta palavra?
  - #placeholder(38, from: 55) Onde reconheço hoje a ação de Deus?
  - #placeholder(30, from: 100)
]

= Cântico final

#chant(
  columns: 2,
  numbered: false,
  placeholder-lines(from: 20, 5, 6, 5, 4, 6, 5, 5, 4),
  placeholder-lines(from: 70, 5, 6, 4, 5, 6, 5, 4, 5),
)
