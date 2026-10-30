# base

What the templates in this repository share, so that each of them defines only what is its own. Documents do not import it; the templates do.

| Export | What it is |
|---|---|
| `grays` | `(ink:, secondary:, separator:)`, the neutral grays every template starts its `default-theme` from. |
| `merge-theme(base, override)` | A document's partial theme over the template's defaults; a dictionary value such as `fonts` merges key by key. |
| `dot(fill)`, `dash(fill)` | Drawn list markers, so the chrome carries no bullet glyphs. |
| `enum-numbering(fill)` | "1." in a colour, for `set enum(numbering: ..)`. |
| `capitalise(value)` | The first grapheme of a string in upper case. |

## Install

From the repository root, `./scripts/link-local.sh` links the package as `@local/base:0.1.0` together with the templates (see the [repository README](../../README.md)). A template that imports it needs it linked on the same machine.
