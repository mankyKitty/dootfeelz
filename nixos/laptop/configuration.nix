# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # VBox setup
  virtualisation.virtualbox.guest.enable = true;
  boot.initrd.checkJournalingFS = false;

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  networking.hostName = "manky_nix"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

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
    wget
    which
    sublime3
    emacs
    haskellPackages.cabal-install
    haskellPackages.ghcid
    haskellPackages.cabal2nix
    haskellPackages.doctest
    haskellPackages.ghc
    haskellPackages.stylish-haskell
    nix-repl
    silver-searcher
    sudo
    htop
    dmenu
    irssi
    keepassx
    iosevka
    plan9port
    idrisPackages.idris
    erlang
  ];

  # List services that you want to enable:
  
  # Emacs!
  services.emacs.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # ERMAGERD PERSTGREEZ
  services.postgresql.enable = true;
  services.postgresql.package = pkgs.postgresql;

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
    desktopManager.default = "none";
    desktopManager.xterm.enable = false;
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
          URxvt.font:                 xft:Iosevka:size=11
          XTerm*faceName:             xft:Iosevka:size=11
          XTerm*utf8:                 2
       ''}"
    '';    
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
  # services.printing.enable = true;

  # Enable the X11 windowing system.
  # services.xserver.enable = true;
  services.xserver.layout = "us";
  services.xserver.xkbOptions = "ctrl:nocaps";

  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.manky = {
    isNormalUser = true;
    home = "/home/manky";
    extraGroups = [ "wheel" "networkmanager" "cdrom" ];
    description = "Sean Chalmers";
    uid = 1000;
  };

  nixpkgs.config = {
    allowUnfree = true;
  };
  # Added from https://github.com/reflex-frp/reflex-platform/blob/develop/notes/NixOS.md
  nix.trustedBinaryCaches = [
    "https://cache.nixos.org"
    "https://nixcache.reflex-frp.org"
  ];
  nix.binaryCachePublicKeys = [
    "ryantrinkle.com-1:JJiAKaRv9mWgpVAz8dwewnZe0AzzEAzPkagE9SP5NWI="
  ];

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "17.03";

}
