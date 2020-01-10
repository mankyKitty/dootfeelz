{ lib, fetchzip }:
let
  version = "1.0";
  commit = "82b0adbe05d24ecfe2188807ed23993b0fa63468";
in
fetchzip {
  name = "press-start-2p-font-${version}";
  url = "https://github.com/alexeiva/PressStart2P/archive/${commit}.zip";
  sha256 = "0qjs0lg7aqazspzzjjbmhagnlz0ikqcdc9sbi7lmiqfy5s8x7cmg";

  postFetch = ''
    mkdir -p $out/share/fonts/truetype
    mkdir trash

    unzip $downloadedFile -d trash

    cp trash/PressStart2P-${commit}/fonts/PressStart2P-Regular.otf $out/share/fonts/truetype/
    cp trash/PressStart2P-${commit}/fonts/PressStart2P-Regular.ttf $out/share/fonts/truetype/

    # unzip -j $downloadedFile \*.ttf -d $out/share/fonts/truetype
  '';

  meta = with lib; {
    description = "Press Start 2P Font";
    homepage = "https://github.com/alexeiva/PressStart2P";
    license = licenses.ofl;
    maintainers = [ "alexeiva" ];
  };
}
