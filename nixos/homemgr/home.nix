{ config, pkgs, lib, ... }:
let
  from-home = dir: ./repos/dootfeelz/nixos/homemgr + dir;
  pkgs-unstable = import <nixpkgs-unstable> {};
  ghcide-nix = import (builtins.fetchTarball "https://github.com/cachix/ghcide-nix/tarball/master") {};

  nivToken = "48dc89c30815de98496469a71b6f15599ba07b66";

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
in
{
  nixpkgs.config = {
    allowUnfree = true;
  };

  nixpkgs.overlays =
    [ (import ./overlays/stevenblack-hosts.nix)
      (import ./overlays/kak-fzf)
      (import ./overlays/lorri)
      (import ./overlays/kakoune)
      (import ./overlays/kakoune-selenized)

      # Get the theme of synth.
      (import ./overlays/synthwave-x-fluoromachine)

      # This triggers a 'corrupt installation' warning from vscode.. worth it.
      (self: super: {
        vscode = pkgs-unstable.vscode.overrideAttrs (old: {
          # This injects the CSS into the workbench.html, which is nicer and more reliable
          # than doing it via JS on the fly via an extension which requires that I alter
          # my file permissions so it can work its evil.
          patches = [ ./patches/add-synthwave-css.patch ];
        });
      })
    ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  imports = [
    ./development.nix
    ./polybar.nix
    ./dunst.nix
  ];

  # Misc apps etc
  home.packages = with pkgs; [
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

    # editor shenanigans
    kakoune
    # pkgs-unstable.kak-lsp
    ghcide-nix.ghcide-ghc865

    # languages
    # pkgs-unstable.mercury
    pkgs-unstable.exercism

    # turtle power
    shellcheck
    wget
    gawk
    which
    tree
    html2text
    pkgs-unstable.silver-searcher
    lorri
    pkgs-unstable.universal-ctags
    pkgs-unstable.entr
    pkgs-unstable.cool-retro-term

    # apps
    evince
    pandoc
    shutter
    thunderbird
    zoom-us
    signal-desktop
    krita
    gnome3.pomodoro
    libreoffice
    pkgs-unstable.postman

    # fonts
    iosevka
    mononoki
    font-awesome-ttf

    # nix-tility
    nix-prefetch-scripts
    pkgs-unstable.haskellPackages.niv

    # omg unfree!
    spotify
    epiphany
    pkgs-unstable.discord
    pkgs-unstable.brave
  ];

  programs.jq.enable = true;
  programs.htop.enable = true;

  programs.fish = {
    enable = true;
    # promptInit = ''
    # function fish_prompt -d "my nix fish"
    #   set -l nix_shell_info (
    #     if set -q IN_NIX_SHELL
    #       echo -n -s " <nix-shell> "
    #     end
    #   )
    #   set -l color_cwd
    #   set -l suffix
    #   switch "$USER"
    #       case root toor
    #           if set -q fish_color_cwd_root
    #               set color_cwd $fish_color_cwd_root
    #           else
    #               set color_cwd $fish_color_cwd
    #           end
    #           set suffix '#'
    #       case '*'
    #           set color_cwd $fish_color_cwd
    #           set suffix '>'
    #   end
    #   echo -n -s "$USER" @ (prompt_hostname) ' ' (set_color $color_cwd) (prompt_pwd) (set_color normal) "$nix_shell_info$suffix "
    # end

    # starship init fish | source
    # '';
    shellAliases = {
      # ghci = "ghci -interactive-print=Text.Pretty.Simple.pPrint -package pretty-simple";
      ns = "nix-shell $argv --command fish";
      gs = "git status";
      ob-standup = "zoom-us \"zoommtg://zoom-us/join?confno=9355149074\"";
      nivv = "GITHUB_TOKEN=${nivToken} niv";
    };
  };

  home.file.".ghci".source = ~/repos/dootfeelz/nixos/homemgr/.ghci_config;
  # home.file.".config/nvim/init.vim".source = ~/repos/dootfeelz/editor/neovim/init.vim;

  programs.firefox.enable = true;
  programs.chromium.enable = true;
  programs.fzf.enable = true;

  # Fix this to use a 'toTOML' generators
  # At least at some point when kak-lsp is more useful for haskell projects... ;<
  # home.file.".config/kak-lsp/kak-lsp.toml".text  = ''
  #   snippet_support = false
  #   verbosity = 2

  #   # exit session if no requests were received during given period in seconds
  #   # works only in unix sockets mode (-s/--session)
  #   # set to 0 to disable
  #   [server]
  #   timeout = 1800 # seconds = 30 minutes

  #   [language.haskell]
  #   filetypes = ["haskell"]
  #   roots = ["Setup.hs", "stack.yaml", "*.cabal"]
  #   command = "hie-wrapper"
  #   args = ["--lsp"]
  # '';

  home.file.".config/kak/colors" = {
    source = pkgs.kakoune-selenized + /colors;
    recursive = true;
  };

  programs.kakoune = {
    enable = true;
    config = {
      colorScheme = "base16";
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
      add-highlighter global/ show-whitespaces

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

  # To add an extension, use this template:
  # {
  #   name = "git-project-manager";
  #   publisher = "felipecaputo";
  #   version = "1.7.1";
  #   sha256 = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa";
  # }
  programs.vscode = {
    # package = pkgs-unstable.vscode; # Needs unstable home-manager
    enable = true;
    extensions = with pkgs.vscode-extensions; [
        bbenoist.Nix
        justusadam.language-haskell
        ms-vscode.cpptools

      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "haskell-linter";
          publisher = "hoovercj";
          version = "0.0.6";
          sha256 = "0fb71cbjx1pyrjhi5ak29wj23b874b5hqjbh68njs61vkr3jlf1j";
        }
        {
          name = "synthwave-x-fluoromachine";
          publisher = "webrender";
          version = "0.0.9";
          sha256 = "1d43gfwja7nlfvrx1gb912vkv4p59g10agamlbkcy3sfv1kp9agx";
        }
        {
          name = "git-project-manager";
          publisher = "felipecaputo";
          version = "1.7.1";
          sha256 = "1pghgzs89qwp9bx6z749z6a00pfqm2416n4lmna6dhpk5671hah9";
        }
        {
          name = "rewrap";
          publisher = "stkb";
          version = "1.9.1";
          sha256 = "1gr51m2n0wgsijkh7nizja91ail9f83hmy5wy3h5j0xhgi3hpkar";
        }
        {
          name = "code-spell-checker";
          publisher = "streetsidesoftware";
          version = "1.7.24";
          sha256 = "09iv72k045w88ycqbmgirxn27a4fbd28skp7gyz9a6aing6rm3kj";
        }
        {
          name = "vscode-pull-request-github";
          publisher = "GitHub";
          version = "0.14.0";
          sha256 = "00x2nls2nmz9qc8hyp4nfgw300snr7l2dx5mc7y9ll11429iba6j";
        }
        {
          name = "bracket-pair-colorizer";
          publisher = "CoenraadS";
          version = "1.0.61";
          sha256 = "0r3bfp8kvhf9zpbiil7acx7zain26grk133f0r0syxqgml12i652";
        }
        {
          name = "gitlens";
          publisher = "eamodio";
          version = "10.2.1";
          sha256 = "1bh6ws20yi757b4im5aa6zcjmsgdqxvr1rg86kfa638cd5ad1f97";
        }
      ];
    userSettings = {
      "editor.tabSize" = 2;
      "editor.fontFamily" = "Fira Code";
      "editor.fontLigatures" = true;
      "editor.rulers" = [80 90 100];

      "files.trimTrailingWhitespace" = true;
      "files.associations" = {
        "*.hsc" = "haskell";
      };

      "telemetry.enableCrashReporter" = false;
      "telemetry.enableTelemetry" = false;

      "workbench.editor.highlightModifiedTabs" = true;
      "workbench.iconTheme" = "vs-minimal";
      "workbench.colorTheme" = "Synthwave x Fluoromachine";

      "terminal.integrated.shell.linux" = "${pkgs.fish}/bin/fish";

      "gitProjectManager.baseProjectsFolders" = [
        "/home/manky/repos"
      ];

      "gitProjectManager.storeRepositoriesBetweenSessions" = true;

      # "rewrap.wrappingColumn" = 90;
      "rewrap.wholeComment" = false;
      "rewrap.doubleSentenceSpacing" = true;

      "cSpell.language" = "en-GB";
    };
  };

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

  # services.lorri.enable = true;

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

  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        size = 7.0;
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
   programs.urxvt = {
     enable = true;
     fonts = ["xft:Iosevka=11"];
     keybindings = {
       "Shift-Control-C" = "eval:selection_to_clipboard";
       "Shift-Control-V" = "eval:paste_clipboard";
     };
   };

  services.pasystray.enable = true;
  services.network-manager-applet.enable = true;

  systemd.user.startServices = true;

  xsession = {
    enable = true;
    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      extraPackages = hpkgs: with hpkgs; [
        xmonad-contrib
      ];
      config = ~/repos/dootfeelz/xmonad/xmonad.hs;
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
