#!/usr/bin/env bash
# Symlink every template in templates/ into Typst's local package directory,
# so any document can `#import "@local/<name>:<version>": *`. Edits in this
# repository then apply to every document on the next compile.
set -euo pipefail

repo="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

case "$(uname -s)" in
  Darwin) data="$HOME/Library/Application Support" ;;
  *) data="${XDG_DATA_HOME:-$HOME/.local/share}" ;;
esac
target="$data/typst/packages/local"

field() {
  sed -n "s/^$1 *= *\"\(.*\)\"/\1/p" "$2" | head -n 1
}

for manifest in "$repo"/templates/*/typst.toml; do
  dir="$(dirname "$manifest")"
  name="$(field name "$manifest")"
  version="$(field version "$manifest")"
  mkdir -p "$target/$name"
  ln -sfn "$dir" "$target/$name/$version"
  echo "@local/$name:$version -> $dir"
done
