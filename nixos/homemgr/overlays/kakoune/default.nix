self: super:
let
  kak-git = super.lib.importJSON ./github.json;

  kak = super.kakoune-unwrapped.overrideAttrs (old: rec {
    version = "2019.12.10";
    src = self.fetchgit {
      inherit (kak-git) url rev sha256;
    };
  });
in
{
  kakoune = super.wrapKakoune kak {};
}
