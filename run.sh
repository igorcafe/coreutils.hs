#!/usr/bin/env bash

set -eu

echo "> cleaning up" >&2
rm -f coreutils

echo "> compiling..." >&2
ghc -no-keep-hi-files -no-keep-o-files -Wincomplete-patterns -Werror Main.hs -o coreutils

name="${1:-coreutils}"
shift

echo "> running: $name $@" >&2
exec -a $name ./coreutils $@
