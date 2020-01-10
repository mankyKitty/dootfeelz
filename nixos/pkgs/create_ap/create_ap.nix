{ stdenv, makeWrapper }:

stdenv.mkDerivation rec {
  name = "create_ap-${version}";
  version = "0.4.x";

  src = fetchTarball {
    url = "https://github.com/oblique/create_ap/tarball/d67a5a59df3c329058507d0cb3f6382d9a2f5f9a";
    sha256 = "1g33sc0m2zpxjxv13crahb5w6h4rz8178y9z6d4xy6bwcjq4p1ys";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  phases = [
    "unpackPhase"
    "installPhase"
  ];

  installPhase = ''
    mkdir -p $out/bin
    # mkdir -p $XDG_CONFIG_HOME/.config/create_ap
    mkdir -p $out/share/bash-completion/completions
    mkdir -p $out/share/doc/create_ap

    # install -Dm644 bash_completion $(DESTDIR)$(PREFIX)/share/bash-completion/completions/create_ap
    ln -s bash_completion $out/share/bash-completion/completions/create_ap

    # install -Dm644 README.md $(DESTDIR)$(PREFIX)/share/doc/create_ap/README.md
    ln -s README.md $out/share/doc/create_ap/README.md

    makeWrapper create_ap $out/bin/create_ap \
      --add-flags "--config $XDG_CONFIG_HOME/.config/create_ap/create_ap.conf"
  '';
}
