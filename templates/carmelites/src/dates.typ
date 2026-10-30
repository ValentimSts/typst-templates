// Dates in Portuguese, months in lower case as the 1990 spelling agreement
// writes them.

#let months = (
  "janeiro",
  "fevereiro",
  "março",
  "abril",
  "maio",
  "junho",
  "julho",
  "agosto",
  "setembro",
  "outubro",
  "novembro",
  "dezembro",
)

#let day-month(d) = [#d.day() de #months.at(d.month() - 1)]

// A `datetime` gives "9 de outubro de 2026". A pair gives a range:
// "9 a 11 de outubro de 2026", "30 de outubro a 1 de novembro de 2026", or
// "30 de dezembro de 2026 a 1 de janeiro de 2027". Text passes through.
#let format-date(date) = {
  if type(date) == datetime {
    [#day-month(date) de #date.year()]
  } else if type(date) == array and date.len() == 2 {
    let (first, last) = date
    if first.year() != last.year() {
      [#format-date(first) a #format-date(last)]
    } else if first.month() != last.month() {
      [#day-month(first) a #day-month(last) de #last.year()]
    } else {
      [#first.day() a #format-date(last)]
    }
  } else { date }
}
