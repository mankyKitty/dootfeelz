self: super:
let
  gitinfo = self.lib.importJSON ./github.json;
  synthwave-src = self.fetchgit {
    inherit (gitinfo) url rev sha256;
  };
in {
  vscode-theme-synthwave = synthwave-src;
}
