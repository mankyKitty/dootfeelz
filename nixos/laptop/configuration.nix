# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "manky_nix"; # Define your hostname.
  networking.networkmanager = {
    enable = true;
  };

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_AU.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "Australia/Brisbane";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    # Misc system level things
    pkgs.shellcheck
    pkgs.jq
    pkgs.alsaUtils
    pkgs.arandr
    pkgs.networkmanagerapplet
    upower
    powertop
    evince
    xpdf
    wget
    gawk
    which
    tree
    rxvt_unicode-with-plugins
    xorg.xbacklight
    nix-repl
    silver-searcher
    sudo
    htop
    dmenu
    keepassx
    iosevka
    keychain
    pkgs.gitAndTools.hub
    pkgs.crawlTiles
    pkgs.xscreensaver
    pkgs.stow
    pkgs.nix-prefetch-git
    pkgs.pandoc
    # omg unfree!
    unstable.spotify
    unstable.steam
    unstable.steam-run
    # Wowsers Bowsers
    pkgs.chromium
    pkgs.firefox
    # Right in the inbox
    pkgs.thunderbird
    # Yubikey!
    unstable.yubioath-desktop
    pkgs.networkmanager_openconnect
  ] ++ [
    # Editor shenanigans
    emacs
    emacsPackages.proofgeneral

    unstable.neovim
    unstable.python35Packages.neovim

    ed
    plan9port
  ] ++ [
    # AVR / Arduino Embedded Things
    # avrdude
    # avrbinutils
    # avrgcc
    # avrlibc
  ] ++ [
    # Bonus language round!
    unstable.tlaplus
    unstable.erlang
    unstable.ats2
    unstable.gnuapl
    unstable.gcc
    unstable.coq
    unstable.coqPackages.ssreflect
    unstable.racket
    unstable.mercury
    unstable.j
    unstable.gnumake
    # Eww
    unstable.python3
  ] ++ [
    # Haskell Packages
    unstable.haskellPackages.cabal-install
    unstable.haskellPackages.ghcid
    unstable.haskellPackages.cabal2nix
    unstable.haskellPackages.hlint
    unstable.haskellPackages.stylish-haskell
    unstable.haskellPackages.hoogle

    haskellPackages.doctest
    haskellPackages.ghc

    # XMonad Haskell type things
    # unstable.haskellPackages.taffybar
    unstable.haskellPackages.xmobar
  ];

  # Fishy fishy
  programs.fish.enable = true;

  # Android Dev!
  programs.adb.enable = true;

  # List services that you want to enable:

  # Emacs!
  # services.emacs.enable = true;

  # Yubi!
  services.pcscd.enable = true;

  # VBox setup
  virtualisation.virtualbox.host = {
    enable = true;
  };

  boot.kernelPackages = pkgs.linuxPackages // {
    virtualbox = pkgs.linuxPackages.virtualbox.override {
      enableExtensionPack = true;
      pulseSupport = true;
    };
  };
  # virtualisation.virtualbox.enableExtensionPack = true;


  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Handle lid close ?
  services.logind.extraConfig = ''
  HandleLidSwitch=suspend
  HandlePowerKey=hibernate
  '';

  services.upower.enable = true;
  powerManagement.enable = true;

  # ERMAGERD PERSTGREEZ
  # services.postgresql.enable = true;
  # services.postgresql.package = pkgs.postgresql;

  # Enable core fonts - requires allowNonFree
  # fonts.enableCoreFonts = true;
  fonts = {
    fonts = [
      pkgs.iosevka
      pkgs.hasklig
      pkgs.source-code-pro
      pkgs.fira-code
    ];
    fontconfig = {
      enable = true;
      ultimate.enable = true;
      defaultFonts = {
        monospace = ["Iosevka"];
      };
    };
  };

  services.xserver = {
    enable = true;
    layout = "us";
    xkbOptions = "ctrl:nocaps";
    desktopManager.default = "none";
    desktopManager.xterm.enable = false;

    xrandrHeads = [ "eDP1" "DP1-1" ];
    resolutions = [ { x = 2560; y = 1440; } { x = 1920; y = 1200; } ];

    startOpenSSHAgent = true;
    displayManager = {
      lightdm.enable = true;
    };
    windowManager.default = "xmonad";
    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
    };
    displayManager.sessionCommands =  ''
       xrdb "${pkgs.writeText  "xrdb.conf" ''
          URxvt.font:                 xft:Iosevka:size=10
          XTerm*faceName:             xft:Iosevka:size=10
          XTerm*utf8:                 2

    ! special
    *.foreground:               \#f8f8f2
    *.background:               \#272822
    *.cursorColor:              \#f8f8f2

    ! black
    *.color0:                   \#272822
    *.color8:                   \#75715e

    ! red
    *.color1:                   \#f92672
    *.color9:                   \#f92672

    ! green
    *.color2:                   \#a6e22e
    *.color10:                  \#a6e22e

    ! yellow
    *.color3:                   \#f4bf75
    *.color11:                  \#f4bf75

    ! blue
    *.color4:                   \#66d9ef
    *.color12:                  \#66d9ef

    ! magenta
    *.color5:                   \#ae81ff
    *.color13:                  \#ae81ff

    ! cyan
    *.color6:                   \#a1efe4
    *.color14:                  \#a1efe4

    ! white
    *.color7:                   \#f8f8f2
    *.color15:                  \#f9f8f5

    Xft*dpi:                    96
    Xft.hinting:                true
          Xft.hintstyle:              hintfull
          Xft.antialias:              rgba
          Xft.rgba:                   rgb
       ''}"
    '';
    # Touchpad setup, maybe
    synaptics = {
      enable = true;
      twoFingerScroll = true;
      horizontalScroll = true;
      tapButtons = true;
      palmDetect = true;
      additionalOptions = ''
      Option            "VertScrollDelta"  "-111"
      Option            "HorizScrollDelta" "-111"
    '';
    };
  };
  services.xserver.displayManager.slim.defaultUser = "manky";

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall = {
    enable = false;
    allowedTCPPorts = [ 443 9999 22 ];
  };
  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Hardware changes to run Steam
  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
  };

  # Additional filesystems
  fileSystems."/mnt/machines" = {
    device = "//192.168.1.4/machines";
    fsType = "cifs";
    options = [ "username=no" "password=okay" "x-systemd.automount" "noauto" ];
  };

  # hardware.pulseaudio.enable = true;
  # hardware.pulseaudio.support32Bit = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.manky = {
    isNormalUser = true;
    home = "/home/manky";
    extraGroups = [
      "wheel"
      "networkmanager"
      "cdrom"
      "audio"
      "vboxusers"
      "adbusers"
    ];
    description = "Sean Chalmers";
    uid = 1000;
    shell = "/run/current-system/sw/bin/fish";
  };

  nixpkgs.config = {
    allowUnfree = true;
      # Create an alias for the unstable channel
    packageOverrides = pkgs: {
      unstable = import <nixos-unstable> {
        # pass the nixpkgs config to the unstable alias
        # to ensure `allowUnfree = true;` is propagated:
        config = config.nixpkgs.config;
      };
    };
  };

  nix.binaryCaches = [
    # Added from https://github.com/reflex-frp/reflex-platform/blob/develop/notes/NixOS.md
    "https://cache.nixos.org"
    "https://nixcache.reflex-frp.org"
  ];
  nix.binaryCachePublicKeys = [
    "ryantrinkle.com-1:JJiAKaRv9mWgpVAz8dwewnZe0AzzEAzPkagE9SP5NWI="
  ];

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "18.03";

}
