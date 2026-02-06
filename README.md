# coreutils.hs

Implementation of some GNU core utilities in haskell, for practicing the language.

This project is not meant to be perfectly compatible nor a completed implementation.

## Build

```bash
ghc -no-keep-hi-files -no-keep-o-files Main.hs -o coreutils
```

## Usage

Run commands through `./exec`:

```bash
./exec ls
./exec ls -a
./exec coreutils
```
