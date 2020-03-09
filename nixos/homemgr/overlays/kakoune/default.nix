self: super:
let
  kakSrc = (import ../nix/sources.nix).kakoune;

  kak = super.kakoune-unwrapped.overrideAttrs (old: rec {
    version = kakSrc.version;
    src = kakSrc;
  });
in
{
  kakoune = super.wrapKakoune kak {};
}
