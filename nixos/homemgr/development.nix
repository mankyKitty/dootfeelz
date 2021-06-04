{ config, pkgs, unstable, ... }:
let
  pkgs-unstable = import <nixpkgs-unstable> {};

  niv-srcs = import ./nix/sources.nix;
  # easy-hls-src = pkgs.fetchFromGitHub {
  #   owner  = "jkachmar";
  #   repo   = "easy-hls-nix";
  #   rev = "cf0cb016e1c57934592fd4c9d07d6b7a67d3f6ce";
  #   sha256 = "1whs5xckd1p4r8xskyfh5h098ks0fw1ki3ccjgb1fpmc4hbdx7sb";
  # };

  easy-hls = pkgs.callPackage (niv-srcs.easy-hls-nix) {
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
      # "8.10.4"
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
    # easy-hls

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
