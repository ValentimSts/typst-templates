// Placeholder text in Portuguese, the counterpart of `lorem` for drafts that
// still wait for their readings, chants or excerpts. The words come from a
// paragraph that says what it is, so a slice can never pass for a quotation.

#let text-source = "Este texto provisório ocupa o lugar do original e serve apenas para mostrar como a página se compõe antes de lá estar a versão verdadeira. Quando o texto certo for colado no seu lugar, as linhas, os parágrafos e as citações manterão a mesma forma, com o mesmo comprimento aproximado, as mesmas quebras e a mesma hierarquia de títulos. Assim é possível avaliar a leitura em papel, a acentuação, a hifenização das palavras mais compridas e o equilíbrio entre o texto, as margens e os espaços em branco. Nenhuma destas frases pertence ao documento final nem deve ser lida em voz alta durante a oração; ficam aqui somente até que alguém as substitua pela leitura, pelo cântico ou pelo excerto que corresponde a este momento do encontro. Convém confirmar no fim que não restou nenhum fragmento provisório, revendo cada secção com atenção, de preferência numa cópia impressa e com tempo."

#let words = (
  text-source
    .split(" ")
    .map(w => lower(w.replace(regex("[^\\p{L}-]"), "")))
    .filter(w => w != "")
)

#let phrase(from, n) = {
  let s = range(from, from + n)
    .map(i => words.at(calc.rem(i, words.len())))
    .join(" ")
  upper(s.first()) + s.slice(s.first().len())
}

// `n` words as a sentence: `#placeholder(40)`. `from` starts further into
// the text, so neighbouring placeholders differ; `end` closes the sentence.
#let placeholder(n, from: 0, end: ".") = phrase(from, n) + end

// Lines of the given lengths, as a string for #chant or #verses:
// `#verses(placeholder-lines(5, 7, 4))`.
#let placeholder-lines(from: 0, ..sizes) = {
  let at = from
  let out = ()
  for n in sizes.pos() {
    out.push(phrase(at, n))
    at += n
  }
  out.join("\n")
}
