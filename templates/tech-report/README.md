# tech-report

A Typst template for technical reports and design documents: architecture designs, security reviews, platform proposals, migration plans.

![Cover and a body page](thumbnail.png)

It gives a document:

- a **cover** with a brand band, classification chip, metadata and handling statement;
- a **document control** page: metadata table, handling, notes on the version, revision history and a key to the status marks;
- **contents**, plus **generated registers** (for example every open decision, with its page) and a list of tables;
- **status marks**, callouts the document defines for itself (open decision, risk, unverified, ...), which can be referenced by id;
- running headers with the current chapter, `Page n of N` footers, a **DRAFT watermark** until the status is final, and lettered **appendices**.

Branding is data: the template ships a neutral look, and a document passes its own palette through `theme`.

## Install

The template is a local Typst package. From the repository root:

```bash
./scripts/link-local.sh
```

This symlinks `templates/tech-report` to `~/.local/share/typst/packages/local/tech-report/0.1.0`, so every document on the machine can import it and picks up edits to the template on its next compile.

### Fonts

The default theme uses **IBM Plex Sans** and **IBM Plex Mono**. On Arch:

```bash
sudo pacman -S ttf-ibm-plex
```

Without them the template falls back to Liberation Sans and DejaVu Sans Mono and Typst prints an `unknown font family` warning. Typst packages cannot bundle fonts, so a document that must look identical everywhere needs the fonts installed or passed with `--font-path`.

## Start a document

```bash
typst init @local/tech-report:0.1.0 my-document
cd my-document
typst watch main.typ
```

The starter `main.typ` shows every feature. The minimum is:

```typst
#import "@local/tech-report:0.1.0": *

#show: report.with(
  title: "Project Atlas",
  subtitle: "Target architecture",
  version: "0.1",
  status: "Draft",
  date: datetime.today(),
)

= Introduction
...
```

## `report` parameters

Every parameter is optional. Text parameters accept strings or content; people (`authors`, `owner`, `reviewers`, `approvers`, `distribution`) accept strings or `(name: .., role: ..)` dictionaries, alone or in an array.

| Parameter | Default | What it does |
|---|---|---|
| `title`, `subtitle` | `none` | Cover title and subtitle; together they form the PDF title. |
| `short-title` | `title` | Shown in the running header. |
| `doc-type` | `none` | Small label above the title, e.g. "Architecture design". |
| `doc-id`, `version`, `status` | `none` | Cover and document control; the footer shows them as `ID · Version n · Status`. |
| `date` | `none` | A `datetime` (printed as "8 October 2026") or text. |
| `classification` | `none` | Chip on the cover and a row in document control. |
| `organisation` | `none` | Cover header, or a metadata row when a logo is shown. |
| `logo` | `none` | `path("logo.svg")` or ready content such as `image(..)`. A plain string fails, because it would resolve inside the package. |
| `keywords` | `()` | PDF keywords. |
| `authors`, `owner`, `reviewers`, `approvers`, `distribution` | `()` / `none` | Document control rows; authors also go on the cover and into the PDF metadata. |
| `handling` | `none` | Handling statement, on the cover and in document control. |
| `notice` | `none` | "About this version" paragraph in document control. |
| `history` | `()` | Revision history rows: `(version:, date:, author:, change:)`. |
| `marks` | `(:)` | The mark specs (see below); used for the key and the registers. |
| `registers` | `true` | Generate a register for each mark that declares one. |
| `list-of-tables`, `list-of-figures` | `true`, `false` | Lists after the registers, built from captioned figures. |
| `outline-depth` | `2` | Heading depth in the contents. |
| `heading-start` | `1` | Number of the first chapter; `0` gives "0 Executive summary". |
| `draft` | `auto` | DRAFT watermark; `auto` shows it unless the status contains final, approved, issued or released. |
| `theme` | `(:)` | Partial theme, merged over the defaults (see below). |
| `paper`, `lang`, `region` | `"a4"`, `"en"`, `none` | Page size and text language. |

## Status marks

Marks are callouts a document defines for itself. Declare their specs once and turn them into functions:

```typst
#let mark-specs = (
  decision: (
    label: "Open decision",        // shown in small capitals
    tone: "warning",               // info, success, warning, danger, neutral, accent, or a colour
    register: "Open decisions",    // optional: generate a register with this title
    description: [A recommended default the team still has to confirm.],  // optional: key entry
  ),
  risk: (label: "Risk", tone: "danger"),
)
#let (decision, risk) = marks(mark-specs)

#show: report.with(marks: mark-specs, ..)
```

Use them in the text:

```typst
#decision(id: "D4", title: [Ingress controller])[
  Options: ... Recommended default: ...
]

#decision(id: "D4", title: [Ingress controller], mention: true)[
  Shortened copy elsewhere; its id links to the full entry.
]

#risk[The shared database is a single point of failure.]
```

A mark with a `register` and an `id` is a **canonical entry**: it is labelled with its id, so `@D4` links to it, and it appears in the register. Add `mention: true` to repeat an entry elsewhere without listing it twice. Marks without an id are plain callouts.

## References

Label headings and refer to them as usual:

```typst
== Azure layout <sec-4.2>
See @sec-4.2.
```

By default a reference reads "Section 4.2". For bare numbers ("see 4.2", "§4"), add after the show rule:

```typst
#set heading(supplement: none)
```

## Appendices

```typst
#show: appendix

= Glossary   // numbered A, its sections A.1, A.2, ...
```

## Theme

Override any token through `theme`; `fonts` and `tones` merge key by key.

| Token | Default | Used for |
|---|---|---|
| `ink` | `#1f2328` | Body text |
| `muted` | `#59636e` | Captions, labels, footers |
| `rule` | `#d1d9e0` | Hairlines |
| `surface` | `#f6f8fa` | Code and label backgrounds |
| `accent` | `#1f4e79` | Decoration: cover band, chapter bars, table header rule. May be light. |
| `on-accent` | `white` | Text drawn on the accent |
| `primary` | `#1f4e79` | Heading numbers and caption labels; must read as text on white |
| `link` | `#1a5fb4` | Links and references |
| `code` | `#3b4252` | Inline code |
| `header-fill`, `on-header` | `#e9eef3`, `#1f2328` | Table header row |
| `tones` | info, success, warning, danger, neutral | Mark colours |
| `fonts` | `(body:, heading:, mono:)` | Font stacks |

For example, a yellow-on-dark brand keeps yellow decorative and text dark:

```typst
theme: (
  accent: rgb("#ffe600"),
  primary: rgb("#2e2e38"),
  ink: rgb("#2e2e38"),
  header-fill: rgb("#2e2e38"),
  on-header: white,
),
```

## Long documents

Split chapters into files and keep shared definitions in one place:

```
my-document/
  setup.typ      // #import "@local/tech-report:0.1.0": *, mark specs, theme
  main.typ       // #import "setup.typ": *, #show: report.with(..), #include chapters
  chapters/
    01-introduction.typ   // #import "../setup.typ": *, then content
```

Included files have their own scope, which is why each chapter imports `setup.typ`; the show rules in `main.typ` still style them.
