{ nixpkgs ? import <nixpkgs> {} }:
let
  common = opts: nixpkgs.callPackage (import ./common.nix opts);
in
  rec {
    sublime3_3176 = common {
      buildVersion = "3176";
      x32sha256 = "";
      x64sha256 = "0cppkh5jx2g8f6jyy1bs81fpb90l0kn5m7y3skackpjdxhd7rwbl";
    } {};
}
