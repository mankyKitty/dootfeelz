self: super:
let
	gitinfo = self.lib.importJSON ./github.json;
	kakoune-selenized-src = self.fetchgit {
		inherit (gitinfo) url rev sha256;
	};
in {
	kakoune-selenized = kakoune-selenized-src;
}
