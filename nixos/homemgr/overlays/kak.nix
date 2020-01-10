self: super:
let
  kak-git = super.lib.importJSON ./kakoune/github.json;

  kak = super.kakoune.overrideAttrs (old: rec {
    version = "2019.12.10";
    src = self.fetchgit {
      inherit (kak-git) url rev sha256;
    };
  });
in
{
  kakoune = kak;
}
