# typst-templates

Typst templates for professional documents, each packaged as a local Typst package so any document on the machine can import it.

## Templates

| Template | For | Import |
|---|---|---|
| [tech-report](templates/tech-report/README.md) | Technical reports and design documents: cover, document control, status marks, generated registers | `@local/tech-report:0.1.0` |

## Setup

Requires Typst 0.15 or later.

```bash
./scripts/link-local.sh
```

The script symlinks every template under `templates/` into Typst's local package directory (`~/.local/share/typst/packages/local/` on Linux). Run it again after adding a template or bumping a version; edits to an existing template apply on the next compile.

Then start a document anywhere:

```bash
typst init @local/tech-report:0.1.0 my-document
```

## Layout

```
templates/<name>/
  typst.toml        package manifest: name, version, entrypoint
  lib.typ           public API
  src/              implementation
  template/main.typ starter document used by `typst init`
  README.md         usage and parameters
scripts/link-local.sh
```

Documents built with these templates live outside this repository.
