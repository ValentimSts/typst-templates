// tech-report: technical reports and design documents.
//
//   #import "@local/tech-report:0.1.0": *
//   #show: report.with(title: "..", ..)
//
// See README.md for every parameter.

#import "src/report.typ": appendix, report
#import "src/marks.typ": mark, marks, marks-key, register
#import "src/theme.typ": default-theme
#import "src/glossary.typ": no-glossary
#import "src/links.typ": inline-links, links

// A neutral stand-in for a real logo: `report(logo: placeholder-logo)`.
#let placeholder-logo = path("placeholder.svg")
