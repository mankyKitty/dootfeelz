{ fetchurl, stdenv, xorg, glib, glibcLocales, gtk3, cairo, pango, libredirect, makeWrapper, wrapGAppsHook, libGL
, pkexecPath ? "/run/wrappers/bin/pkexec"
, dev ? false
, writeScript, common-updater-scripts, curl, gnugrep
, openssl, bzip2, bash, unzip, zip, zlib
}:

let
  pname = "sublimetext4";
  packageAttribute = "sublime4${stdenv.lib.optionalString dev "-dev"}";
  binaries = [ "sublime_text" "plugin_host-3.3" "plugin_host-3.8" "crash_reporter" ];
  primaryBinary = "sublime_text";
  primaryBinaryAliases = [ "subl" "sublime" "sublime4" ];
  versionUrl = "https://download.sublimetext.com/latest/${if dev then "dev" else "stable"}";
  versionFile = builtins.toString ./packages.nix;
  arch = "x64";
  buildVersion = "4106";

  libPath = stdenv.lib.makeLibraryPath [ xorg.libX11 glib gtk3 cairo pango ];
  redirects = [ "/usr/bin/pkexec=${pkexecPath}" ];

  pluginHostRPATHs = builtins.concatStringsSep ":"
    [ "${stdenv.cc.cc.lib}/lib${stdenv.lib.optionalString stdenv.is64bit "64"}/libgcc_s.so.1"
      "$out/libcrypto.so.1.1"
      "$out/libssl.so.1.1"
      "${bzip2.out}/lib/libbz2.so"
      "${zlib.out}/lib/libz.so.1"
    ];

in let
  binaryPackage = stdenv.mkDerivation {
    pname = "${pname}-bin";
    version = buildVersion;

    src = fetchurl {
      url = "https://download.sublimetext.com/sublime_text_build_${buildVersion}_${arch}.tar.xz";
      sha256 = "09jnn52zb0mjxpj5xz4sixl34cr6j60x46c2dj1m0dlgxap0sh8x";
      # sha256 = "004ikdj33i82cz6wyr974aqi8shpj7qbndlvfjssjx2ck8skng5v";
      # sha256 = "19cd48wkzfi8dvsgwyzz4fjipqf3bg57v54l1an5wy02i53ff1l4";
      # sha256 = "0divhvxnh8hclsz0k9d2yhw3ajchdwc1sw6jvi0pcfqc029r7pqm";
      # sha256 = "0mj54v53wyxxlynrk4qqnmpy87g06f9w5vqfsghzbg99p3wxyr4j";
      # sha256 = "15ja2y4aj2m4ysxdg2m85mwp5ilpcq73pvm7g2p4dyrfbjzxc6jq";
      # sha256 = "0i566aqk11hwgm31c0pycr68rp0hhyspc1rynhs6b8gc1j1ql9r6";
    };

    dontStrip = true;
    dontPatchELF = true;
    buildInputs = [ glib gtk3 libGL ]; # for GSETTINGS_SCHEMAS_PATH
    nativeBuildInputs = [ zip unzip makeWrapper wrapGAppsHook ];

    # make exec.py in Default.sublime-package use own bash with an LD_PRELOAD instead of "/bin/bash"
    patchPhase = ''
      runHook prePatch

      mkdir Default.sublime-package-fix
      ( cd Default.sublime-package-fix
        unzip -q ../Packages/Default.sublime-package
        substituteInPlace "exec.py" --replace \
          "[\"/bin/bash\"" \
          "[\"$out/sublime_bash\""
        zip -q ../Packages/Default.sublime-package **/*
      )
      rm -r Default.sublime-package-fix

      runHook postPatch
    '';

    buildPhase = ''
      runHook preBuild

      for binary in ${ builtins.concatStringsSep " " binaries }; do
        patchelf \
          --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
          --set-rpath ${libPath}:${stdenv.cc.cc.lib}/lib${stdenv.lib.optionalString stdenv.is64bit "64"} \
          $binary
      done

      # Rewrite pkexec argument. Note that we cannot delete bytes in binary.
      sed -i -e 's,/bin/cp\x00,cp\x00\x00\x00\x00\x00\x00,g' ${primaryBinary}

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp -r * $out/

      # We can't just call /usr/bin/env bash because a relocation error occurs
      # when trying to run a build from within Sublime Text
      ln -s ${bash}/bin/bash $out/sublime_bash

      runHook postInstall
    '';

    dontWrapGApps = true; # non-standard location, need to wrap the executables manually

    postFixup = ''
      wrapProgram $out/sublime_bash \
        --set LD_PRELOAD "${stdenv.cc.cc.lib}/lib${stdenv.lib.optionalString stdenv.is64bit "64"}/libgcc_s.so.1"

      wrapProgram $out/${primaryBinary} \
        --set LD_PRELOAD "${libredirect}/lib/libredirect.so:${libGL}/lib/libGL.so.1:${openssl.out}/lib/libssl.so" \
        --set NIX_REDIRECTS ${builtins.concatStringsSep ":" redirects} \
        --set LOCALE_ARCHIVE "${glibcLocales.out}/lib/locale/locale-archive" \
        "''${gappsWrapperArgs[@]}"

      # Without this, plugin_host crashes, even though it has the rpath
      wrapProgram $out/plugin_host-3.8 --prefix LD_PRELOAD : ${pluginHostRPATHs}
      wrapProgram $out/plugin_host-3.3 --prefix LD_PRELOAD : ${pluginHostRPATHs}
    '';
  };
in stdenv.mkDerivation (rec {
  inherit pname;
  version = buildVersion;

  phases = [ "installPhase" ];

  ${primaryBinary} = binaryPackage;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p "$out/bin"
    makeWrapper "''$${primaryBinary}/${primaryBinary}" "$out/bin/${primaryBinary}"
  '' + builtins.concatStringsSep "" (map (binaryAlias: "ln -s $out/bin/${primaryBinary} $out/bin/${binaryAlias}\n") primaryBinaryAliases) + ''
    mkdir -p "$out/share/applications"
    substitute "''$${primaryBinary}/${primaryBinary}.desktop" "$out/share/applications/${primaryBinary}.desktop" --replace "/opt/${primaryBinary}/${primaryBinary}" "$out/bin/${primaryBinary}"
    for directory in ''$${primaryBinary}/Icon/*; do
      size=$(basename $directory)
      mkdir -p "$out/share/icons/hicolor/$size/apps"
      ln -s ''$${primaryBinary}/Icon/$size/* $out/share/icons/hicolor/$size/apps
    done
  '';

  passthru.updateScript = writeScript "${pname}-update-script" ''
    #!${stdenv.shell}
    set -o errexit
    PATH=${stdenv.lib.makeBinPath [ common-updater-scripts curl gnugrep ]}

    latestVersion=$(curl -s ${versionUrl})

    if [[ "${buildVersion}" = "$latestVersion" ]]; then
        echo "The new version same as the old version."
        exit 0
    fi

    for platform in ${stdenv.lib.concatStringsSep " " meta.platforms}; do
        # The script will not perform an update when the version attribute is up to date from previous platform run
        # We need to clear it before each run
        update-source-version ${packageAttribute}.${primaryBinary} 0 0000000000000000000000000000000000000000000000000000000000000000 --file=${versionFile} --version-key=buildVersion --system=$platform
        update-source-version ${packageAttribute}.${primaryBinary} $latestVersion --file=${versionFile} --version-key=buildVersion --system=$platform
    done
  '';

  meta = with stdenv.lib; {
    description = "Sophisticated text editor for code, markup and prose";
    homepage = "https://www.sublimetext.com/";
    maintainers = with maintainers; [ jtojnar wmertens demin-dmitriy zimbatm ];
    license = licenses.unfree;
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
})
