self: super:
let
  lorriTar = "https://github.com/target/lorri/archive/rolling-release.tar.gz";
in {
  lorri = import (fetchTarball {
    url = lorriTar;
  }) { };
}
