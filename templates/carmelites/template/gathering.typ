// The details shared by every document of one gathering: each document
// imports this file, so the group, the dates and the theme are typed once.

#let gathering = (
  group: "Grupo de Jovens Carmelitas em Fátima",
  // One date, or the first and last day of a weekend.
  date: (
    datetime(year: 2026, month: 12, day: 4),
    datetime(year: 2026, month: 12, day: 6),
  ),
  motto: "Tema do ano pastoral",
)
