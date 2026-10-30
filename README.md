# typst-templates

Typst templates for professional documents, each packaged as a local Typst package so any document on the machine can import it.

## Templates

| Template | For | Import |
|---|---|---|
| [tech-report](templates/tech-report/README.md) | Technical reports and design documents: cover, document control, status marks, generated registers | `@local/tech-report:0.1.0` |
| [carmelites](templates/carmelites/README.md) | Prayer guides and formation handouts for a Carmelite youth group, in Portuguese | `@local/carmelites:0.1.0` |
| [cv](templates/cv/README.md) | A minimal CV in black tones: contact icons, sections over hairlines, entries with dates or links | `@local/cv:0.1.0` |

They share [base](templates/base/README.md) (`@local/base:0.1.0`): the neutral grays, theme merging and drawn list markers. The templates import it; documents never do.

## Setup

Requires Typst 0.15 or later.

```bash
./scripts/link-local.sh
```

The script symlinks every package under `templates/` into Typst's local package directory (`~/.local/share/typst/packages/local/` on Linux). Run it again after adding a template or bumping a version; edits to an existing template apply on the next compile.

Then start a document anywhere:

```bash
typst init @local/tech-report:0.1.0 documents/tech-report/my-document
```

## Layout

```
templates/<name>/
  typst.toml        package manifest: name, version, entrypoint
  lib.typ           public API
  src/              implementation
  template/         starter documents used by `typst init`
  example/          every component with placeholder text, for checking changes
  placeholder.svg   tech-report only: neutral stand-in logo, `placeholder-logo`
  README.md         usage and parameters
templates/base/     what the templates share: grays, theme merging, list markers
scripts/link-local.sh
documents/          your own documents, git-ignored
```

Documents built with these templates live in `documents/`, one folder per template (`documents/<template>/<document>/`). The folder is git-ignored: real documents stay on this machine and never reach the public repository.
