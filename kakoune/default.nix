{ nixpkgs ? import <nixpkgs> {}
}:
let
  inherit (nixpkgs) pkgs lib;

  kak-git = lib.importJSON ./github.json;

  kak = pkgs.kakoune-unwrapped.overrideAttrs (old: rec {
    version = "2019.12.10";
    src = pkgs.fetchgit {
      inherit (kak-git) url rev sha256;
    };
  });
in
  pkgs.wrapKakoune kak {}

