{ nixpkgs ? import <nixpkgs-unstable> {} }:
let
  common = opts: nixpkgs.callPackage (import ./common.nix opts);
in
  rec {
    sublime3_3176 = common {
      buildVersion = "3176";
      x32sha256 = "";
      x64sha256 = "0cppkh5jx2g8f6jyy1bs81fpb90l0kn5m7y3skackpjdxhd7rwbl";
    } {};
    sublime3_3197 = common {
      buildVersion = "3197";
      x32sha256 = "";
      x64sha256 = "0gxr33q7gwd922qkpsq7nxqmrybrac84r25z8sg084ii05w0c426";
    } {};
    sublime3_3200 = common {
      buildVersion = "3200";
      x32sha256 = "";
      x64sha256 = "1gagc50fqb0d2bszi8m5spzb64shkaylvrwl6fxah55xcmy2kmdr";
    } {};
}
