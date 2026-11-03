// carmelites: prayer guides and formation handouts for a Discalced
// Carmelite youth group, in Portuguese.
//
//   #import "@local/carmelites:0.1.0": *
//   #show: prayer-guide.with(group: "..", date: .., motto: "..", title: [..])
//   #show: formation.with(group: "..", date: .., series: [..], part: 3, title: [..])
//
// See README.md for every parameter.

#import "src/documents.typ": formation, prayer-guide
#import "src/components.typ": (
  chant, hints, intercessions, notes, rubric, source, verses,
)
#import "src/theme.typ": default-theme
#import "src/placeholder.typ": placeholder, placeholder-lines
