with import <nixpkgs> {};

stdenv.mkDerivation {
  name = "my_doc_writing_shell";
  buildInputs =
    let
      nodepkgs = with pkgs.nodePackages; [
        write-good
        textlint
        textlint-rule-max-comma
        textlint-rule-no-start-duplicated-conjunction
      ];
    in
      nodepkgs ++ [
      ];

}