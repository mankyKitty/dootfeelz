self: super:
let
	gitinfo = self.lib.importJSON ./github.json;
	kak-smarttab-src = self.fetchgit {
		inherit (gitinfo) url rev sha256;
	};
in {
	kak-smarttab = kak-smarttab-src;
}
