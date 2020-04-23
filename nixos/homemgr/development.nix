{ config, pkgs, unstable, ... }:
let
  pkgs-unstable = import <nixpkgs-unstable> {};
  all-hies = import (fetchTarball "https://github.com/infinisil/all-hies/tarball/master") {};
  justHaskStatics = pkgs.haskell.lib.justStaticExecutables;
in
{
  home.packages = with pkgs; [
    # misc
    gcc
    coq
    gnumake
    python3

  ] # Haskell Shenanigans
  ++ (with pkgs.haskellPackages; [
    pkgs-unstable.haskellPackages.hasktags
    cabal-install
    ghcid
    cabal2nix
    hlint
    # stylish-haskell
    (ghcWithHoogle (haskPkgs: with haskPkgs; [
      pretty-simple
      lens
      mtl
      text
      bytestring
    ]))
    # (justHaskStatics haskell-ci)
    (all-hies.selection { selector = p: { inherit (p) ghc864 ghc865; }; })
  ]);
}
