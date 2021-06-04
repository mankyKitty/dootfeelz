self: super:
{
  stevenblack-hosts = super.stdenv.mkDerivation rec {
    name = "StevenBlackHostsFile";
    src = (import ./../nix/sources.nix).stevenblackhosts;
    unpackCmd = null;
    installPhase = ''
      mkdir -p $out
      cp ${src} $out/hosts
    '';
  };
}
