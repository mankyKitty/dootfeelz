{ config, pkgs, lib, ... }:
let
  from-home = dir: ./repos/dootfeelz/nixos/homemgr + dir;

  # Unstable is my default when using nix on darwin, for better or worse.
  pkgs-unstable = if pkgs.stdenv.isDarwin then pkgs else import <nixpkgs-unstable> {
    config = {
      allowBroken = true;
      allowUnfree = true;
    };
  };

  # nivToken = "2578eeea7034fb742727846f1ac3eba02fd9762c";

  vsCodeWithSomeExtensions = pkgs-unstable.vscode-with-extensions.override (_: {
    vscodeExtensions =  with pkgs-unstable.vscode-extensions; [
      # These require external tools and need more nixos specific massaging
      ms-vscode.cpptools
    ] ++ pkgs-unstable.vscode-utils.extensionsFromVscodeMarketplace
      # This lets me pull in updates when required using my update ext script
      (import ./../../editor/vscode/extensions.nix).extensions;
  } );

  # My wrapped version of vscode that keeps my data folder in a writable location.
  wrappedVSCode = pkgs.writeScriptBin "wcode" ''
    #!${pkgs.stdenv.shell}
    exec ${vsCodeWithSomeExtensions}/bin/code \
     --user-data-dir ~/.config/vscode/data/ \
     "$\{extraFlagsArray[@]\}" \
     "$@"
  '';
in
{
  nixpkgs.config = {
    allowUnfree = true;
  };

  nixpkgs.overlays =
    [ (import ./overlays/stevenblack-hosts.nix)
      # (import ./overlays/kak-fzf)
      # (import ./overlays/kakoune)
      # (import ./overlays/kakoune-selenized)
      # (import ./overlays/ormolu)

      # Nix community overlay for gccEmacs
      (import (builtins.fetchTarball {
        url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
      }))

      # Fixing NSS & Slack behaviour
      (_: super:  {
        slack = super.slack.override {
          nss = pkgs-unstable.nss_3_44;
        };
      })

      (_: super: {
        sublime4 = super.callPackage ./packages/sublime4 {};
      })
    ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  imports = [
    ./development.nix
    ./dunst.nix
  ];

  home.stateVersion = "21.05";
  home.username = if pkgs.stdenv.isDarwin
    then "mankypants"
    else "manky";

  home.homeDirectory = if pkgs.stdenv.isDarwin
    then /Users/mankypants
    else /home/manky;

  # Misc apps etc
  home.packages = with pkgs; [
    # Nix-thunk for great thunkening
    # (import (builtins.fetchTarball "https://github.com/obsidiansystems/nix-thunk/archive/master.tar.gz") {}).command

    (pkgs.writeScriptBin "nixFlakes" ''
      #!/usr/bin/env bash
      exec ${pkgs.nixUnstable}/bin/nix --experimental-features "nix-command flakes" "$@"
    '')

    # system
    file
    cachix
    dnsmasq
    fmt
    pkgs-unstable.openssl.dev
    ncdu
    lorri

    aspell
    aspellDicts.en

    git-crypt
    gitAndTools.gitui

    # For neovim CoC
    pkgs-unstable.nodejs
    # Clang LSP client
    pkgs-unstable.ccls

    # turtle power
    shellcheck
    wget
    gawk
    which
    tree
    html2text
    pkgs-unstable.silver-searcher
    pkgs-unstable.universal-ctags
    pkgs-unstable.ripgrep

    # fonts
    iosevka
    mononoki
    roboto-mono
    font-awesome-ttf

    # nix-tility
    nix-prefetch-scripts
    pkgs-unstable.haskellPackages.niv

  ] ++ (if pkgs.stdenv.isLinux then with pkgs; [
    # System utils
    cacert
    sudo
    dmenu
    alsaUtils
    upower
    powertop
    xorg.xbacklight
    networkmanagerapplet

    # Editor(s)
    sublime4
    wrappedVSCode

    # Sigh...
    pkgs-unstable.ledger-live-desktop
    pkgs-unstable.ledger-udev-rules


    # gamez
    pkgs-unstable.steam

    # apps
    evince
    pandoc
    shutter
    simplescreenrecorder
    pkgs-unstable.keybase-gui
    pkgs-unstable.blender
    libreoffice

    # omg unfree!
    spotify
    playerctl
    epiphany
    pkgs-unstable.discord
    pkgs-unstable.brave
    # slack
  ] else if pkgs.stdenv.isDarwin then [

  ] else [

  ]);

  programs.feh.enable = !pkgs.stdenv.isDarwin;
  programs.jq.enable = true;
  programs.htop.enable = true;

  # programs.qutebrowser = {
  #   enable = true;
  #   searchEngines = {
  #     w = "https://en.wikipedia.org/wiki/Special:Search?search={}&go=Go&ns0=1";
  #     archw = "https://wiki.archlinux.org/?search={}";
  #     nw = "https://nixos.wiki/index.php?search={}";
  #     goog = "https://www.google.com/search?hl=en&q={}";
  #     hack = "https://hackage.haskell.org/package/{}";
  #   };
  # };

  programs.fish = {
    enable = true;
      shellAliases = {
      # ghci = "ghci -interactive-print=Text.Pretty.Simple.pPrint -package pretty-simple";
      ns = "nix-shell $argv --command fish";
      gs = "git status";
      sstop = "systemctl --user stop xscreensaver.service";
      sstart = "systemctl --user restart xscreensaver.service";
    };
  };

  home.file.".ghci".source = ~/repos/dootfeelz/nixos/homemgr/.ghci_config;

  home.file."init.vim" = {
    source = ~/repos/dootfeelz/editor/neovim/init.vim;
    target = ".config/nvim";
  };

  home.file.".fehbg" = {
    executable = !pkgs.stdenv.isDarwin;
    onChange = "/home/manky/.fehbg";
    text = ''
    #!/usr/bin/env bash
    ${pkgs.feh}/bin/feh --no-fehbg --bg-center '/home/manky/pictures/radnom/depressurisation.png'
    '';
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    withPython3 = true;
  };

  programs.firefox.enable = !pkgs.stdenv.isDarwin;
  programs.chromium.enable = !pkgs.stdenv.isDarwin;
  programs.fzf.enable = true;

  # home.file.".config/kak/colors" = {
  #   source = pkgs.kakoune-selenized + /colors;
  #   recursive = true;
  # };

  # programs.kakoune = {
  #   enable = true;
  #   config = {
  #     colorScheme = "kaleidoscope-light";
  #     numberLines.enable = true;
  #     showWhitespace.enable = true;
  #     tabStop = 2;
  #     indentWidth = 2;
  #     ui = {
  #       enableMouse = true;
  #       assistant = "cat";
  #     };
  #     keyMappings = [
  #       { mode = "normal"; key = "'<c-p>'"; effect = ":fzf-mode<ret>"; }
  #       { mode = "normal"; key = "'<c-l>'"; effect = ":enter-user-mode lsp<ret>"; }
  #       { mode = "normal"; key = "'#'"; effect = ":comment-line<ret>"; }
  #       { mode = "user"; key = "'p'"; effect = "!xsel --output --clipboard<ret>"; docstring = "paste (after) from clipboard"; }
  #       { mode = "user"; key = "'P'"; effect = "<a-!>xsel --output --clipboard<ret>"; docstring = "paste (before) from clipboard"; }
  #       { mode = "user"; key = "'y'"; effect = "<a-|>xsel --input --clipboard<ret>:echo copied selection to x11 clipboard<ret>"; docstring = "Yank to clipboard"; }

  #       { mode = "user"; key = "'l'"; effect = ": lint-next-error<ret>"; docstring = "Go to next linting error"; }
  #       { mode = "user"; key = "'L'"; effect = ": lint-previous-error<ret>"; docstring = "Go to previous linting error"; }
  #       { mode = "user"; key = "'<a-l>'"; effect = ": lint-disable<ret>"; docstring = "Disable linting"; }
  #     ];
  #   };
  #   extraConfig = (import ./../../kakoune/conf.nix {
  #     inherit lib pkgs pkgs-unstable;
  #   });
  # };

  programs.gpg.enable = true;
  services.gpg-agent = {
    enable = !pkgs.stdenv.isDarwin;
    pinentryFlavor = "curses";
    grabKeyboardAndMouse = true;
  };
  services.gnome-keyring = {
    enable = !pkgs.stdenv.isDarwin;
    components = [ "pkcs11" "secrets" "ssh" ];
  };

  services.keybase.enable = !pkgs.stdenv.isDarwin;
  services.kbfs.enable = !pkgs.stdenv.isDarwin;

  # home.file."init.el" = {
  #   source = ~/repos/dootfeelz/editor/emacs/init.el;
  #   target = ".emacs.d";
  # };

  programs.emacs = {
    enable = true;
  };

  home.sessionVariables = {
    EDITOR = "subl";
  };

  services.udiskie.enable = !pkgs.stdenv.isDarwin;
  programs.autorandr.enable = !pkgs.stdenv.isDarwin;

  programs.direnv = {
    enable = true;
    enableFishIntegration = true;
    enableNixDirenvIntegration = true;
  };

  services.redshift = {
    enable = !pkgs.stdenv.isDarwin;
    tray = true;
    settings.redshift = {
      brightness-day = "1.0";
      brightness-night = "0.7";
    };
    provider = "geoclue2";
    # Brisbane lat/long
    # longitude  = "153.0251";
    # latitude = "-27.4698";
  };

  services.xscreensaver = {
    enable = !pkgs.stdenv.isDarwin;
    settings = {
      lock = true;
    };
  };

  programs.git = {
    enable = true;
    userEmail = "sean.chalmers@obsidian.systems";
    userName = "Sean Chalmers";
    aliases = {
      code-changes = "!git log --format=format: --name-only | egrep -v '^$' | sort | uniq -c | sort -rg | head -10";
      cc = "!git code-changes";
      co = "checkout";
    };
    extraConfig = {
      github = {
        user = "mankyKitty";
      };
      gitlab = {
        user = "schalmers";
      };
    };
    ignores = [
      "*dist"
      "*dist-newstyle"
      ".ghc-environment*"
      "cabal.project.local*"
      "tags"
      "TAGS"
    ];
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.kitty = {
    enable = true;
    font = {
      name = "Iosevka Semibold 9";
      package = pkgs-unstable.iosevka;
    };
    settings = {
      enable_audio_bell = false;
      copy_on_select = true;
      allow_remote_control = true;
    };
  };

  services.pasystray.enable = !pkgs.stdenv.isDarwin;
  services.network-manager-applet.enable = !pkgs.stdenv.isDarwin;
  services.blueman-applet.enable = !pkgs.stdenv.isDarwin;
  systemd.user.startServices = true;

  xsession =
    let
      i3mod = "Mod4";
      plyr = cmd: "exec playerctl --player=spotify ${cmd}";
    in {
    enable = !pkgs.stdenv.isDarwin;
    windowManager.i3 = {
      enable = !pkgs.stdenv.isDarwin;
      config = {
        terminal = "kitty";
        modifier = i3mod;
        fonts = {
          names = ["FontAwesome" "DejaVu Sans Mono" "Iosevka Semibold"];
          size = 9.0;
        };
        startup =
          [ { command = "/home/manky/.fehbg"; }
          ];
        keybindings = lib.mkOptionDefault {
          # Activate screenlock
          "${i3mod}+Ctrl+l" = "exec sh -c 'xscreensaver-command -lock'";
          # Spotify control
          "XF86AudioPlay" = plyr "play-pause";
          "XF86AudioNext" = plyr "next";
          "XF86AudioPrev" = plyr "previous";
          # Monitor Brightness
          "${i3mod}+Shift+b" = "exec sh -c 'xbacklight -dec 5'";
          "${i3mod}+b" = "exec sh -c 'xbacklight -inc 5'";
          # Volumne
          "XF86AudioLowerVolume" = "exec sh -c 'amixer sset Master 5%-'";
          "XF86AudioRaiseVolume" = "exec sh -c 'amixer sset Master 5%+'";
          "XF86AudioMute" = "exec pactl set-sink-mute @DEFAULT_SINK@ toggle";
          # Multi-monitor control
          "${i3mod}+m" = "move workspace to output eDP-1";
          "${i3mod}+Shift+m" = "move workspace to output HDMI-2";
          # Focus
          "${i3mod}+j" = "focus left";
          "${i3mod}+k" = "focus down";
          "${i3mod}+l" = "focus up";
          "${i3mod}+semicolon" = "focus right";
          # Move
          "${i3mod}+Shift+j" = "move left";
          "${i3mod}+Shift+k" = "move down";
          "${i3mod}+Shift+l" = "move up";
          "${i3mod}+Shift+semicolon" = "move right";
        };
      };
    };
  };

  xresources.extraConfig = ''
  ! special
  *.foreground:   #c5c8c6
  *.background:   #1d1f21
  *.cursorColor:  #c5c8c6
  ! black
  *.color0:       #282a2e
  *.color8:       #373b41
  ! red
  *.color1:       #a54242
  *.color9:       #cc6666
  ! green
  *.color2:       #8c9440
  *.color10:      #b5bd68
  ! yellow
  *.color3:       #de935f
  *.color11:      #f0c674
  ! blue
  *.color4:       #5f819d
  *.color12:      #81a2be
  ! magenta
  *.color5:       #85678f
  *.color13:      #b294bb
  ! cyan
  *.color6:       #5e8d87
  *.color14:      #8abeb7
  ! white
  *.color7:       #707880
  *.color15:      #c5c8c6
  home.language.base = "en_au":
  '';
}
