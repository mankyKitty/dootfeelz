{ config, pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  imports = [
    ./development.nix
    ./polybar.nix
    ./dunst.nix
    ./services/lorri.nix
    # ./pkgs/press-start-2p-font
  ];

  # Misc apps etc
  home.packages = with pkgs; [
    # system
    sudo
    dmenu
    alsaUtils
    upower
    powertop
    xorg.xbacklight
    networkmanagerapplet
    ed

    # turtle power
    shellcheck
    jq
    wget
    gawk
    which
    tree
    silver-searcher

    # apps
    evince
    pandoc
    shutter
    thunderbird
    zoom-us


    # ssshhhhh
    keepassx
    keychain

    # fonts
    iosevka
    mononoki
    font-awesome-ttf

    # nix-tility
    nix-prefetch-scripts

    # omg unfree!
    spotify
    brave

    # Sigh, fragmentation
    slack
    discord
  ];

  programs.htop.enable = true;

  programs.fish = {
    enable = true;
    promptInit = ''
    function fish_prompt -d "my nix fish"
      set -l nix_shell_info (
        if set -q IN_NIX_SHELL
          echo -n -s " <nix-shell> "
        end
      )
      set -l color_cwd
      set -l suffix
      switch "$USER"
          case root toor
              if set -q fish_color_cwd_root
                  set color_cwd $fish_color_cwd_root
              else
                  set color_cwd $fish_color_cwd
              end
              set suffix '#'
          case '*'
              set color_cwd $fish_color_cwd
              set suffix '>'
      end
      echo -n -s "$USER" @ (prompt_hostname) ' ' (set_color $color_cwd) (prompt_pwd) (set_color normal) "$nix_shell_info$suffix "
    end
    '';
    shellAliases = {
      ns = "nix-shell $argv --command fish";
    };
  };

  programs.chromium.enable = true;

  programs.emacs.enable = true;
  programs.neovim.enable = true;

  programs.kakoune = {
    enable = true;
    config = {
      colorScheme = "lucius";
      numberLines.enable = true;
      indentWidth = 2;
      ui = {
        enableMouse = true;
      };
    };
  };

  home.sessionVariables = {
    EDITOR = "kak";
  };

  programs.direnv = {
    enable = true;
    enableFishIntegration = true;
  };

  services.redshift = {
    enable = true;
    brightness.day = "1.0";
    brightness.night = "0.7";
    longitude  = "153.0251";
    latitude = "-27.4698";
  };

  services.lorri.enable = true;

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
    ignores = [
      "dist/"
      "dist-newstyle/"
    ];
  };

  # Shamelessly stolen from benkoleras config for copy/paste great justice.
  programs.urxvt = {
    enable = true;
    fonts = ["xft:Source Code Pro:size=11"];
    keybindings = {
      "Shift-Control-C" = "eval:selection_to_clipboard";
      "Shift-Control-V" = "eval:paste_clipboard";
    };
    # transparent = true;
    shading = 50;
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
