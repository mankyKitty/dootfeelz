{ nixpkgs ? import <nixpkgs> {}
}: 
let
  inherit (nixpkgs) pkgs;
in
pkgs.python3.withPackages (ps: with ps; [
  jupyter
  numpy
  scipy
  matplotlib
  tensorflow
  ])
