{ config, pkgs, unstable, ... }:
let
  pkgs-unstable = import <nixpkgs-unstable> {};
  # all-hies = import (fetchTarball "https://github.com/infinisil/all-hies/tarball/master") {};
  # justHaskStatics = pkgs.haskell.lib.justStaticExecutables;

  easy-hls-src = pkgs.fetchFromGitHub {
    owner  = "jkachmar";
    repo   = "easy-hls-nix";
    rev    = "e4be1cd92e7103052c9e37e17210f1467016a001";
    sha256 = "1qlwznf982wfq38vsyvacc224b61gr64dxkfanpkm3mzgpxr9cv9";
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
    (pkgs.callPackage easy-hls-src {
      ghcVersions = [ # nixpkgs style: "865" "884"
        # "8.6.4"
        "8.6.5"
        # "8.8.2"
        # "8.8.3"
        "8.8.4"
        # "8.10.2"
        # "8.10.3"
        # "8.10.4"
      ];
    })

    pkgs-unstable.haskellPackages.hasktags
    cabal-install
    ghcid
    cabal2nix
    hlint
    retrie
    # stylish-haskell
    (ghcWithHoogle (haskPkgs: with haskPkgs; [
      pretty-simple
      lens
      mtl
      text
      bytestring
    ]))
  ]);
}
