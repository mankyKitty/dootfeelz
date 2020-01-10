self: super: {
  stevenblack-hosts = super.stdenv.mkDerivation rec {
    name = "StevenBlackHostsFile";
    src = builtins.fetchurl {
      url = "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts";
      sha256 = "1n705z2c4ly96spjqlshj8240ac9v240cqhlfg0i1h8ypfdj8bfg"; 
      name = "hosts";
    };
    unpackCmd = "mkdir _futz_";
    installPhase = ''
      mkdir -p $out
      cp ${src} $out/hosts
    '';
  };
}
