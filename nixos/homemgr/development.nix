{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    # misc
    ats2
    gcc
    coq
    gnumake
    python3

  ] # Haskell Shenanigans
  ++ (with pkgs.haskellPackages; [
    cabal-install
    ghcid
    cabal2nix
    hlint
    stylish-haskell
    ghc
    (pkgs.haskell.lib.justStaticExecutables haskell-ci)
  ]);
}
