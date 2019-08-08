#!/usr/bin/env bash

cd "$(pwd)" || exit
echo "Running in $(pwd)"

# if you don't set this, reloading on .cabal changes does not work.
CABALPKGNAME="$(basename "$(pwd)")"
TGT="$1"

ghcid -o=ghcid-out.txt -c"cabal new-repl ${TGT}" --restart "./$CABALPKGNAME.cabal"
