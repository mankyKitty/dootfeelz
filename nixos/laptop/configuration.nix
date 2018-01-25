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
    pkgs.arandr
    pkgs.networkmanagerapplet
    upower
    powertop
    evince
    xpdf
    wget
    gawk
    which
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
  ] ++ [
    # Editor shenanigans
    emacs
    emacsPackages.proofgeneral
    # unstable.sublime3
    neovim
    ed
    plan9port
    (unstable.vscode-with-extensions.override {
      vscode = unstable.vscode;
      vscodeExtensions = with unstable.vscode-extensions; [
        bbenoist.Nix
      ]
      ++ unstable.vscode-utils.extensionsFromVscodeMarketplace [
        { name      = "org-mode";
          publisher = "tootone";
          version   = "0.5.0";
          sha256    = "bd7c28de814bc0aff063b5c4a61f651af5d82318d9b317881384d50113a6576a";
        }
        { name      = "stylish-haskell";
          publisher = "vigoo";
          version   = "0.0.9";
          sha256    = "195646786391d1679dea8354394dd9ea4fd7c03f9c46f2cd8755f0ffbd5fcd9e";
        }
        { name      = "language-haskell";
          publisher = "JustusAdam";
          version   = "2.4.0";
          sha256    = "fb75d783c6d5ec21a6e4cd9a207033190abb3510c0516d4d196e163e34d0fdf5";
        }
        { name      = "vscode-hie-server";
          publisher = "alanz";
          version   = "0.0.6";
	  sha256    = "28e223543aac5ad7fb7ef6116bb389f6b05ce67aeb70eaf1d76c4e856f3df5dd";
        }
        { name      = "Vim";
          publisher = "VsCodeVim";
          version   = "0.10.11";
	  sha256    = "2b29ace673e33610ce87852a807b8986c8596a27ef8198a46bb4c90a41935f60";
        }
        { name      = "vscode-markdownlint";
          publisher = "DavidAnson";
          version   = "0.12.1";
	  sha256    = "3f08939831bd51ba0c91a41aa0f283d9c8792a3a0b76ff0e0d25ba3bbcdaaa47";
        }
      ];
    })
  ] ++ [
    # AVR / Arduino Embedded Things
    avrdude
    avrbinutils
    avrgcc
    avrlibc
  ] ++ [
    # Bonus language round!
    pkgs.erlang
    pkgs.ats2
    pkgs.gcc
    pkgs.coq
    pkgs.coqPackages.ssreflect
    pkgs.racket
    pkgs.mercury
    pkgs.pakcs
    pkgs.j
    pkgs.gnumake
    # Eww
    pkgs.python3
  ] ++ [
    # Haskell Packages
    haskellPackages.cabal-install
    unstable.haskellPackages.ghcid
    haskellPackages.cabal2nix
    unstable.haskellPackages.hlint
    haskellPackages.doctest
    haskellPackages.ghc
    haskellPackages.stylish-haskell
    haskellPackages.hoogle
    # unstable.haskell.packages.ghc802.haskell-ide-engine
    unstable.haskellPackages.haskell-ide-engine
    # XMonad Haskell type things
    haskellPackages.taffybar
  ];

  # Fishy fishy
  programs.fish.enable = true;

  # Android Dev!
  programs.adb.enable = true;

  # List services that you want to enable:
  
  # Emacs!
  # services.emacs.enable = true;
  
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

    displayManager = {
      lightdm.enable = true;
    };
    windowManager.default = "xmonad";
    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      extraPackages = haskellPackages : [haskellPackages.taffybar];
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
    options = [ "username=machines" "password=machines" "x-systemd.automount" "noauto" ];
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
    
  # Added from https://github.com/reflex-frp/reflex-platform/blob/develop/notes/NixOS.md
  nix.binaryCaches = [
    "https://cache.nixos.org"
    "https://nixcache.reflex-frp.org"
  ];
  nix.binaryCachePublicKeys = [
    "ryantrinkle.com-1:JJiAKaRv9mWgpVAz8dwewnZe0AzzEAzPkagE9SP5NWI="
  ];

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "17.09";

}

