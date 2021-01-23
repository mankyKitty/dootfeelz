{ config, pkgs, lib, ... }:
let
  from-home = dir: ./repos/dootfeelz/nixos/homemgr + dir;
  pkgs-unstable = import <nixpkgs-unstable> { config = { allowBroken = true; allowUnfree = true; }; };
  ghcide-nix = import (builtins.fetchTarball "https://github.com/cachix/ghcide-nix/tarball/master") {};

  nivToken = "2578eeea7034fb742727846f1ac3eba02fd9762c";

  postman780 = import ./packages/postman;

  isKakFile = name: type: type == "regular" && lib.hasSuffix ".kak" name;
  isDir     = name: type: type == "directory";
  allKakFiles = (dir:
    let fullPath = p: "${dir}/${p}";
        files = builtins.readDir dir;
        subdirs  = lib.concatMap (p: allKakFiles (fullPath p)) (lib.attrNames (lib.filterAttrs isDir files));
        subfiles = builtins.map fullPath (lib.attrNames (lib.filterAttrs isKakFile files));
    # This makes sure the most shallow files are loaded first
    in (subfiles ++ subdirs)
  );
  kakImport = name: ''source "${name}"'';
  allKakImports = dir: builtins.concatStringsSep "\n" (map kakImport (allKakFiles dir));

  vsCodeWithSomeExtensions = pkgs-unstable.vscode-with-extensions.override (_: {
    vscodeExtensions = with pkgs-unstable.vscode-extensions; [
      bbenoist.Nix
      ms-vscode.Go
      ms-vscode.cpptools
      justusadam.language-haskell
      skyapps.fish-vscode
      vscodevim.vim
    ] ++ pkgs-unstable.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "project-manager";
        publisher = "alefragnani";
        version = "12.0.1";
        sha256 = "1bckjq1dw2mwr1zxx3dxs4b2arvnxcr32af2gxlkh4s26hvp9n1v";
      }
      {
        name = "nix-env-selector";
        publisher = "arrterian";
        version = "0.1.2";
        sha256 = "1n5ilw1k29km9b0yzfd32m8gvwa2xhh6156d4dys6l8sbfpp2cv9";
      }
      {
        name = "bracket-pair-colorizer";
        publisher = "coenraads";
        version = "1.0.61";
        sha256 = "0r3bfp8kvhf9zpbiil7acx7zain26grk133f0r0syxqgml12i652";
      }
      {
        publisher = "faustinoaq";
        name = "crystal-lang";
        version = "0.4.0";
        sha256 = "04dnyap8hl2a25kh5r5jv9bgn4535pxdaa77r1cj9hmsadqd4sgr";
      }
      {
        publisher = "freebroccolo";
        name = "reasonml";
        version = "1.0.38";
        sha256 = "1nay6qs9vcxd85ra4bv93gg3aqg3r2wmcnqmcsy9n8pg1ds1vngd";
      }
      {
        publisher = "gleam";
        name = "gleam";
        version = "1.0.0";
        sha256 = "0r8k7y1247dmd0jc1d5pg31cfxi7q849x5psajw8h2s4834c4dk9";
      }
      {
        publisher = "kahole";
        name = "magit";
        version = "0.6.2";
        sha256 = "0qr11k4n96wnsc2rn77i01dmn0zbaqj32wp9cblghhr6h5vs2y9h";
      }
      {
        publisher = "xaver";
        name = "clang-format";
        version = "1.9.0";
        sha256 = "0bwc4lpcjq1x73kwd6kxr674v3rb0d2cjj65g3r69y7gfs8yzl5b";
      }
      {
        publisher = "monokai";
        name = "theme-monokai-pro-vscode";
        version = "1.1.18";
        sha256 = "0dg68z9h84rpwg82wvk74fw7hyjbsylqkvrd0r94ma9bmqzdvi4x";
      }
    ];
  } );

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
      (import ./overlays/kak-fzf)
      (import ./overlays/kakoune)
      (import ./overlays/kakoune-selenized)
      (import ./overlays/ormolu)

      # Fixing NSS & Slack behaviour
      (_: super:  {
        slack = super.slack.override {
          nss = pkgs-unstable.nss_3_44;
        };
      })

      (_: super: {
        sublime4 = super.callPackage ./packages/sublime4 {};
      })

      (_: super: {
        zoom-us = super.libsForQt5.callPackage ./packages/zoom-us {};
      })

      # KDB+ !
      (_: super: {
        kdbplus = super.callPackage_i686 ./packages/kdbplus {};
      })

      # Fix up the weird renaming of the factor binary
      (_: super: {
        factor-lang = super.callPackage ./packages/factor-lang {
          gtkglext = super.gnome2.gtkglext;
        };
      })

      # Sbtix (scala build helper for nixpkgs)
      (import ./overlays/sbtix)
    ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  imports = [
    ./development.nix
    # ./polybar.nix
    ./dunst.nix
  ];

  # Misc apps etc
  home.packages = with pkgs; [
    sbtix
    # system
    file
    cacert
    sudo
    dmenu
    alsaUtils
    upower
    powertop
    xorg.xbacklight
    networkmanagerapplet
    ed
    stevenblack-hosts
    cachix
    dnsmasq
    fmt
    pkgs-unstable.openssl.dev
    ncdu

    aspell
    aspellDicts.en

    git-crypt

    # gamez
    pkgs-unstable.steam

    # editor shenanigans
    pkgs-unstable.sublime-merge
    sublime4
    kakoune
    pkgs-unstable.vscode
    wrappedVSCode
    pkgs-unstable.ormolu

    # languages
    # pkgs-unstable.mercury
    pkgs-unstable.exercism
    # pkgs-unstable.racket
    factor-lang
    gforth
    kdbplus

    # turtle power
    shellcheck
    wget
    gawk
    which
    tree
    html2text
    pkgs-unstable.silver-searcher
    pkgs-unstable.lorri
    pkgs-unstable.universal-ctags
    pkgs-unstable.entr
    pkgs-unstable.cool-retro-term

    # apps
    evince
    pandoc
    shutter
    thunderbird
    simplescreenrecorder
    pkgs-unstable.keybase-gui
    pkgs-unstable.zeal
    krita
    libreoffice
    pkgs-unstable.postman
    pkgs-unstable.signal-desktop

    # Sigh...
    pkgs-unstable.ledger-live-desktop
    pkgs-unstable.ledger-udev-rules

    # fonts
    iosevka
    mononoki
    roboto-mono
    font-awesome-ttf

    # nix-tility
    nix-prefetch-scripts
    pkgs-unstable.haskellPackages.niv

    # omg unfree!
    spotify
    playerctl
    epiphany
    pkgs-unstable.discord
    pkgs-unstable.brave
    slack
    zoom-us
  ];

  programs.feh.enable = true;
  programs.jq.enable = true;
  programs.htop.enable = true;

  programs.taskwarrior.enable = true;

  programs.fish = {
    enable = true;
      shellAliases = {
      # ghci = "ghci -interactive-print=Text.Pretty.Simple.pPrint -package pretty-simple";
      ns = "nix-shell $argv --command fish";
      gs = "git status";
      ob-standup = "zoom-us \"zoommtg://zoom-us/join?confno=9355149074\"";
      nivv = "GITHUB_TOKEN=${nivToken} niv";
      sb = "nix-shell -p openssl --command subl";
      sstop = "systemctl --user stop xscreensaver.service";
      sstart = "systemctl --user restart xscreensaver.service";
    };
  };

  home.file.".ghci".source = ~/repos/dootfeelz/nixos/homemgr/.ghci_config;
  home.file.".config/nvim/init.vim".source = ~/repos/dootfeelz/editor/neovim/init.vim;
  home.file.".fehbg" = {
    executable = true;
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

  programs.firefox.enable = true;
  programs.chromium.enable = true;
  programs.fzf.enable = true;

   home.file.".config/kak/colors" = {
    source = pkgs.kakoune-selenized + /colors;
    recursive = true;
  };

  programs.kakoune = {
    enable = true;
    config = {
      colorScheme = "kaleidoscope-light";
      numberLines.enable = true;
      showWhitespace.enable = true;
      tabStop = 2;
      indentWidth = 2;
      ui = {
        enableMouse = true;
        assistant = "cat";
      };
      keyMappings = [
        { mode = "normal"; key = "'<c-p>'"; effect = ":fzf-mode<ret>"; }
        { mode = "normal"; key = "'<c-l>'"; effect = ":enter-user-mode lsp<ret>"; }
        { mode = "normal"; key = "'#'"; effect = ":comment-line<ret>"; }
        { mode = "user"; key = "'p'"; effect = "!xsel --output --clipboard<ret>"; docstring = "paste (after) from clipboard"; }
        { mode = "user"; key = "'P'"; effect = "<a-!>xsel --output --clipboard<ret>"; docstring = "paste (before) from clipboard"; }
        { mode = "user"; key = "'y'"; effect = "<a-|>xsel --input --clipboard<ret>:echo copied selection to x11 clipboard<ret>"; docstring = "Yank to clipboard"; }

        { mode = "user"; key = "'l'"; effect = ": lint-next-error<ret>"; docstring = "Go to next linting error"; }
        { mode = "user"; key = "'L'"; effect = ": lint-previous-error<ret>"; docstring = "Go to previous linting error"; }
        { mode = "user"; key = "'<a-l>'"; effect = ": lint-disable<ret>"; docstring = "Disable linting"; }
      ];
    };
    extraConfig = ''

      ${allKakImports pkgs.kak-fzf}

      # eval %sh{kak-lsp --kakoune -s $kak_session}
      # hook global WinSetOption filetype=(haskell) %{
      #   lsp-enable-window
      # }

      # Custom mercury mode, lets roll
      source /home/manky/repos/adventofcode/mercury.kak

      hook global InsertChar k %{ try %{
        exec -draft hH <a-k>jk<ret> d
        exec <esc>
      }}

      map global normal = '|${pkgs-unstable.fmt}/bin/fmt -w $kak_opt_autowrap_column<ret>'

      hook global BufCreate .*[.](hsc) %{
          set-option buffer filetype haskell
      }

      hook global WinSetOption filetype=haskell %{
        # HLinty goodness
        set-option window lintcmd 'hlint'
        lint-enable

        # Hasktaggy goodness
        set-option window ctagscmd "hasktags -x -c -R"

        hook window BufWritePost %val{buffile} %{
          lint
        }
      }

      hook global KakBegin .* %{
          evaluate-commands %sh{
              path="$PWD"
              while [ "$path" != "$HOME" ] && [ "$path" != "/" ]; do
                  if [ -e "./tags" ]; then
                      printf "%s\n" "set-option -add current ctagsfiles %{$path/tags}"
                      break
                  else
                      cd ..
                      path="$PWD"
                  fi
              done
          }
      }

      define-command mkdir %{ nop %sh{ mkdir -p $(dirname $kak_buffile) } }
      set-option global grepcmd 'ag --column'
      add-highlighter global/ show-matching

      def suspend-and-resume \
          -params 1..2 \
          -docstring 'suspend-and-resume <cli command> [<kak command after resume>]: backgrounds current kakoune client and runs specified cli command.  Upon exit of command the optional kak command is executed.' \
          %{ evaluate-commands %sh{

          # Note we are adding '&& fg' which resumes the kakoune client process after the cli command exits
          cli_cmd="$1 && fg"
          post_resume_cmd="$2"

          # automation is different platform to platform
          platform=$(uname -s)
          case $platform in
              Darwin)
                  automate_cmd="sleep 0.01; osascript -e 'tell application \"System Events\" to keystroke \"$cli_cmd\\n\" '"
                  kill_cmd="/bin/kill"
                  break
                  ;;
              Linux)
                  automate_cmd="sleep 0.2; xdotool type '$cli_cmd'; xdotool key Return"
                  kill_cmd="/usr/bin/kill"
                  break
                  ;;
          esac

          # Uses platforms automation to schedule the typing of our cli command
          nohup sh -c "$automate_cmd"  > /dev/null 2>&1 &
          # Send kakoune client to the background
          $kill_cmd -SIGTSTP $kak_client_pid

          # ...At this point the kakoune client is paused until the " && fg " gets run in the $automate_cmd

          # Upon resume, run the kak command is specified
          if [ ! -z "$post_resume_cmd" ]; then
              echo "$post_resume_cmd"
          fi
      }}
    '';
  };

  programs.gpg.enable = true;
  services.gpg-agent = {
    enable = true;
    pinentryFlavor = "curses";
    grabKeyboardAndMouse = true;
  };
  services.gnome-keyring.enable = true;

  services.keybase.enable = true;
  services.kbfs.enable = true;

  # home.file.".emacs.d/init.el".source = ~/repos/dootfeelz/editor/emacs/init.el;
  # services.emacs.enable = true;
  programs.emacs = {
    enable = true;
    package = pkgs-unstable.emacs;
  };

  home.sessionVariables = {
    EDITOR = "kak";
    HOSTALIASES = "${pkgs.stevenblack-hosts}/hosts";
  };

  programs.direnv = {
    enable = true;
    enableFishIntegration = true;
  };

  services.redshift = {
    enable = true;
    tray = true;
    brightness.day = "1.0";
    brightness.night = "0.7";
    provider = "geoclue2";
    # Brisbane lat/long
    # longitude  = "153.0251";
    # latitude = "-27.4698";
  };

  services.xscreensaver = {
    enable = true;
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
      name = "Iosevka Regular 11";
      package = pkgs-unstable.iosevka;
    };
    settings = {
      enable_audio_bell = false;
      copy_on_select = true;
      allow_remote_control = true;
    };
  };

  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        size = 8.0;
        normal = {
          family = "Fira Code";
          style = "Regular";
        };
        italic = {
          family = "Fira Code";
        };
        bold = {
          family = "Fira Code";
        };
      };
    };
  };

  # Shamelessly stolen from benkoleras config for great copy/paste justice.
   # programs.urxvt = {
   #   enable = true;
   #   fonts = ["xft:Iosevka=11"];
   #   keybindings = {
   #     "Shift-Control-C" = "eval:selection_to_clipboard";
   #     "Shift-Control-V" = "eval:paste_clipboard";
   #   };
   # };

  services.pasystray.enable = true;
  services.network-manager-applet.enable = true;
  services.blueman-applet.enable = true;
  systemd.user.startServices = true;

  xsession =
    let
      i3mod = "Mod4";
      plyr = cmd: "exec playerctl --player=spotify ${cmd}";
    in {
    enable = true;
    windowManager.i3 = {
      enable = true;
      config = {
        terminal = "kitty";
        modifier = i3mod;
        fonts = ["FontAwesome 6" "DejaVu Sans Mono 10" "Iosevka Regular 10"];
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
