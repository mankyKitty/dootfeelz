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

  networking.hostName = "mankyhole"; # Define your hostname.
  networking.networkmanager.enable = true;
  networking.extraHosts = "127.0.0.1 my-chainweaver.com";

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_AU.UTF-8";
  };

  # Set your time zone.
  # time.timeZone = "Australia/Brisbane";
  time.timeZone = "Europe/London";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    pkgs.hicolor-icon-theme
    pkgs.arandr
    pkgs.gitAndTools.hub
    pkgs.xscreensaver
  ];

  # Fishy fishy
  programs.fish.enable = true;

  # List services that you want to enable:
  powerManagement.enable = true;
  programs.ssh.startAgent = true;

  fonts = {
    fonts = [
      pkgs.iosevka
      pkgs.hasklig
      pkgs.source-code-pro
      pkgs.fira-code
      pkgs.mononoki
      pkgs.fantasque-sans-mono
      pkgs.fixedsys-excelsior
      pkgs.ultimate-oldschool-pc-font-pack
    ];
    fontconfig = {
      enable = true;
      ultimate.enable = true;
    };
  };

  # SERVICES
  services = {
    # Enable the OpenSSH daemon.
    openssh.enable = true;

    # Enable brightness controls
    # brightnessctl.enable = true;

    # Geoclue2 for Redshift
    geoclue2.enable = true;

    # Handle lid close ?
    logind.extraConfig = ''
    HandleLidSwitch=suspend
    HandlePowerKey=hibernate
    '';

    xserver = {
      enable = true;
      layout = "us";
      xkbOptions = "ctrl:nocaps";
      displayManager.lightdm.enable = true;

      # Touchpad setup
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
  };

  hardware.pulseaudio = {
    enable = true;
    daemon.config = {
      flat-volumes = "no";
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.manky = {
    isNormalUser = true;
    home = "/home/manky";
    extraGroups = [
      "wheel"
      "networkmanager"
      "cdrom"
      "audio"
    ];
    description = "Sean Chalmers";
    uid = 1000;
    shell = pkgs.fish;
  };

  nixpkgs.config.allowUnfree = true;

  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.host.enableExtensionPack = true;
  users.extraGroups.vboxusers.members = [ "manky" ];

  nix.trustedUsers = [ "root" "manky" ];

  nix.binaryCaches = [
    # Added from https://github.com/reflex-frp/reflex-platform/blob/develop/notes/NixOS.md
    "https://cache.nixos.org"
    "https://nixcache.reflex-frp.org"

    # Chainweb
    "https://nixcache.chainweb.com"
    
    # Added from cachix
    "https://hie-nix.cachix.org"

    # IOHK Binary cache
    "https://hydra.iohk.io"

    # Kadena IO Binary cache
    "http://nixcache.kadena.io"
  ];
  nix.binaryCachePublicKeys = [
    "ryantrinkle.com-1:JJiAKaRv9mWgpVAz8dwewnZe0AzzEAzPkagE9SP5NWI="
    "hie-nix.cachix.org-1:EjBSHzF6VmDnzqlldGXbi0RM3HdjfTU3yDRi9Pd0jTY="
    "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
    "kadena-cache.local-1:8wj8JW8V9tmc5bgNNyPM18DYNA1ws3X/MChXh1AQy/Q="
    "ci.chainweb.com-1:GwLTkIGpMnMFD31eXjrP+qdkOQDBXbOj4imFMcyNBYs="
  ];

}
