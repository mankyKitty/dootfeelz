#! /usr/bin/env nix-shell
#! nix-shell -i bash -p coreutils jq curl

set -eou pipefail

function get_ver() {
  curl --silent "https://raw.githubusercontent.com/$1/$2/master/package.json" | grep '"version":' | tr -d '[:alpha:]", :'
}

function get_vsixpackage_sha() {
  URL="https://$1.gallery.vsassets.io/_apis/public/gallery/publisher/$1/extension/$2/latest/assetbyname/Microsoft.VisualStudio.Services.VSIXPackage"
  curl --silent "$URL" | sha256sum | awk '{ print $1 }'
}

OWNER=$1
EXT=$2

SHA=$(get_vsixpackage_sha "$OWNER" "$EXT")

VER=$(get_ver "$OWNER" "$EXT")

if [ -z "$VER" ]; then
  EXT2="vscode-$(echo "$EXT" | tr '[:upper:]' '[:lower:]')"
  VER=$(get_ver "$OWNER" "$EXT2")
fi
if [ -z "$VER" ]; then
  VER="unknown"
fi

printf "  {\\n    name = \"%s\";\\n    publisher = \"%s\";\\n    version = \"%s\";\\n    sha256 = \"%s\";\\n  }\\n" "$EXT" "$OWNER" "$VER" "$SHA"
