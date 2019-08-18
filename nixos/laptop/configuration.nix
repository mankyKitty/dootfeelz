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

  # programs.firejail = {
  #   enable = true;
  #   wrappedBinaries = {
  #     spotify = "${pkgs.lib.getBin pkgs.unstable.spotify}/bin/spotify";
  #   };
  # };

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    # Misc system level things
    unstable.bolt
    pkgs.hicolor-icon-theme
    pkgs.shellcheck
    pkgs.jq
    pkgs.alsaUtils
    pkgs.arandr
    pkgs.networkmanagerapplet
    pkgs.redshift
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
    silver-searcher
    sudo
    htop
    dmenu
    keepassx
    iosevka
    mononoki
    keychain
    pkgs.gitAndTools.hub
    pkgs.xscreensaver
    pkgs.nix-prefetch-git
    pkgs.pandoc
    unstable.direnv
    # omg unfree!
    unstable.spotify
    # unstable.steam
    # unstable.steam-run
    # Wowsers Bowsers
    unstable.chromium
    unstable.firefox
    # Yubikey!
    unstable.yubioath-desktop
    pkgs.networkmanager_openconnect
    # Sigh, fragmentation
    unstable.slack
    unstable.discord
  ] ++ [
    # Editor shenanigans
    emacs
    emacsPackages.proofgeneral

    unstable.neovim

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
    unstable.ats2
    unstable.gcc
    unstable.coq
    unstable.gnumake
    unstable.python3
  ] ++ [
    # Haskell Packages
    unstable.haskellPackages.cabal-install
    unstable.haskellPackages.ghcid
    unstable.haskellPackages.cabal2nix
    unstable.haskellPackages.hlint
    unstable.haskellPackages.stylish-haskell
    unstable.haskellPackages.hoogle

    unstable.haskellPackages.doctest
    unstable.haskellPackages.ghc
    unstable.haskellPackages.ShellCheck
    (pkgs.haskell.lib.justStaticExecutables haskellPackages.haskell-ci)

    # XMonad Haskell type things
    haskellPackages.taffybar
    haskellPackages.gtk-sni-tray
    haskellPackages.status-notifier-item
  ];

  # Fishy fishy
  programs.fish.enable = true;

  # Android Dev!
  programs.adb.enable = true;

  # List services that you want to enable:

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

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Handle lid close ?
  services.logind.extraConfig = ''
  HandleLidSwitch=suspend
  HandlePowerKey=hibernate
  '';

  services.upower.enable = true;
  powerManagement.enable = true;

  programs.ssh.startAgent = true;

  # ERMAGERD PERSTGREEZ
  # services.postgresql.enable = true;
  # services.postgresql.package = pkgs.postgresql;

  fonts = {
    fonts = [
      pkgs.iosevka
      pkgs.hasklig
      pkgs.source-code-pro
      pkgs.fira-code
      pkgs.mononoki
      pkgs.fantasque-sans-mono
      pkgs.fixedsys-excelsior
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

    xrandrHeads = [ "eDP-1" "HDMI-1" ];
    # resolutions = [ { x = 2560; y = 1440; } { x = 1920; y = 1200; } ];
    resolutions = [ { x = 1920; y = 1080; } { x = 1920; y = 1200; } ];

    displayManager = {
      lightdm.enable = true;
    };

    windowManager.default = "xmonad";
    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      extraPackages = haskPkgs: [
        haskPkgs.taffybar
      ];
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

  services.gnome3.at-spi2-core.enable = true;

  services.udev.packages = [ pkgs.unstable.bolt ];
  systemd.packages = [ pkgs.unstable.bolt ];

  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;

  # Enable some user level services
  systemd.user.services = {
    status-notifier-watcher = {
      enable = true;
      description= "status notifier watcher";
      wantedBy = [ "default.target" ];
      before = [ "taffybar.service" ];

      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.haskellPackages.status-notifier-item}/bin/status-notifier-watcher";
      };
    };

    # nm-applet = {
    #   enable = true;
    #   description = "network manager applet";
    #   wants = [ "status-notifier-watcher.service" ];
    #   after = [ "status-notifier-watcher.service" "taffybar.service" ];
    #   serviceConfig = {
    #     Type = "simple";
    #     ExecStart = "${pkgs.networkmanagerapplet}/bin/nm-applet --sm-disable --indicator";
    #   };
    # };

    taffybar = {
      enable = true;
      description = "Taffybar";
      wants = [ "status-notifier-watcher.service" ];
      after = [ "status-notifier-watcher.service" ];

      restartIfChanged = true;

      environment.XDG_DATA_HOME = "/home/manky/.local/share";
      environment.XDG_DATA_DIRS = "/run/opengl-driver/share:/run/opengl-driver-32/share:/home/manky/.nix-profile/share:/nix/var/nix/profiles/default/share:/run/current-system/sw/share:/etc/profiles/per-user/manky/share";
      environment.GDK_PIXBUF_MODULE_FILE = "${pkgs.librsvg.out}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache";

      serviceConfig = {
        Type="simple";
        ExecStart="${pkgs.haskellPackages.taffybar}/bin/taffybar";
        Restart="always";
        RestartSec=3;
        NotifyAccess="all";
      };
    };

  };
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
    shell = "/run/current-system/sw/bin/fish";
  };

  nixpkgs.config = {
    allowUnfree = true;

    # Create an alias for the unstable channel
    packageOverrides = pkgs: {
      unstable = import <nixpkgs-unstable> {
        # pass the nixpkgs config to the unstable alias
        # to ensure `allowUnfree = true;` is propagated:
        config = config.nixpkgs.config;
      };
    };
  };

  nix.trustedUsers = [ "root" "manky" ];

  nix.binaryCaches = [
    # Added from https://github.com/reflex-frp/reflex-platform/blob/develop/notes/NixOS.md
    "https://cache.nixos.org"
    "https://nixcache.reflex-frp.org"
    "https://hydra.qfpl.io"

    # Added from cachix
    "https://hie-nix.cachix.org"

    # IOHK Binary cache
    "https://hydra.iohk.io"
  ];
  nix.binaryCachePublicKeys = [
    "ryantrinkle.com-1:JJiAKaRv9mWgpVAz8dwewnZe0AzzEAzPkagE9SP5NWI="
    "qfpl.io:xME0cdnyFcOlMD1nwmn6VrkkGgDNLLpMXoMYl58bz5g="
    "hie-nix.cachix.org-1:EjBSHzF6VmDnzqlldGXbi0RM3HdjfTU3yDRi9Pd0jTY="
    "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
  ];

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "19.03";
}
