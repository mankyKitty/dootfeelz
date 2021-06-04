{ config, pkgs, ... }:
let
  # Unstable is my default when using nix on darwin, for better or worse.
  pkgs-unstable = if pkgs.stdenv.isDarwin then pkgs else import <nixpkgs-unstable> {
    config = {
      allowBroken = true;
      allowUnfree = true;
    };
  };

  easy-hls = pkgs.callPackage (import ./nix/sources.nix).easy-hls-nix {
    ghcVersions = [
      # nixpkgs style: "865" "884"

      # easy-hls style:
      # "8.6.4"
      "8.6.5"
      # "8.8.2"
      # "8.8.3"
      "8.8.4"
      # "8.10.2"
      # "8.10.3"
      "8.10.4"
    ];
  };

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
    # easy-hls # One day this will work :/

    cabal-install
    ghcid
    cabal2nix
    hlint
    pkgs-unstable.haskellPackages.brittany

    (ghcWithHoogle (haskPkgs: with haskPkgs; [
      pretty-simple
      lens
      mtl
      text
      bytestring
    ]))
  ]);
}
