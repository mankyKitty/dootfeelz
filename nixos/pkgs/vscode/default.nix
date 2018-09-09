{ pkgs ? import <nixpkgs> {}
}:

with pkgs;

let
  hie = import (fetchTarball "https://github.com/domenkozar/hie-nix/archive/e3113da93b479bec3046e67c0123860732335dd9.tar.gz") { inherit pkgs; };

  hieWrapper = writeShellScriptBin "hie" ''
    argv=( "$@" )
    exec nix-shell --pure --run "${hie.hie82}/bin/hie ''${argv[*]}"
  '';

  version = "1.25.1";
  plat = "linux-x64";

  myvscode = vscode.overrideAttrs( old: {
    inherit version plat;

    name = "vscode-${version}";

    src = fetchurl {
      name = "VSCode_${version}_${plat}.tar.gz";
      url = "https://vscode-update.azurewebsites.net/${version}/${plat}/stable";
      sha256 = "0f1lpwyxfchmbymzzxv97w9cy1z5pdljhwm49mc5v84aygmvnmjq";
    };
  });

  exts = import ./extensions.nix;

  new_vscode = vscode-with-extensions.override {
    vscode = myvscode;
    vscodeExtensions = with vscode-extensions; [ bbenoist.Nix ]
      ++ vscode-utils.extensionsFromVscodeMarketplace (
        __filter (e: e.name != "Nix") exts.extensions
      );
  };

  codez = {
    code = runCommand "${new_vscode.name}" { nativeBuildInputs = [ makeWrapper ]; } ''
      mkdir -p $out/bin
      makeWrapper \
        ${new_vscode}/bin/code \
        $out/bin/code \
        --prefix PATH : ${lib.makeBinPath [ cabal-install hieWrapper ]}
    '';
  };
in
  codez
