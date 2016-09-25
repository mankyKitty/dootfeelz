# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let hsPackages = with pkgs.haskellPackages; [  
  cabal2nix
  cabal-install
  djinn
  doctest
  ghc
  ghcid
  hlint
];
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda";

  boot.initrd.luks.devices = [
    {
      name = "root"; device = "/dev/sda3"; preLVM = true;
    }
  ];
 
  # networking.hostName = "nixos"; # Define your hostname.
  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 443 9999 ];
  };


  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "Australia/Brisbane";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    which
    wget
    (emacsWithPackages (with emacsPackagesNg; [
      use-package
      evil
      magit
      which-key
      paredit
      haskell-mode
      multiple-cursors
      company
      flycheck
      rainbow-delimiters
      avy
      ivy
      swiper
      counsel
    ]))
    chromium
    # Pretties
    dmenu
    # Tillities
    keepassx
    irssi
    wpa_supplicant_gui
    silver-searcher
    sbt
    oraclejdk8
    rxvt_unicode
    gitAndTools.gitFull
    sudo
    nix-repl
    htop
  ] ++ hsPackages;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  # Enable the core fonts.
  fonts.enableCoreFonts = true;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable the X11 windowing system.
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
  };
  services.xserver.layout = "us";
  services.xserver.xkbOptions = "ctrl:nocaps";

  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.kdm.enable = true;
  # services.xserver.desktopManager.kde4.enable = true;

  services.xserver.synaptics = {
    enable = true;
    twoFingerScroll = true;
    tapButtons = true;
  };

  nixpkgs.config = {
    allowUnfree = true;
    chromium.enablePepperFlash = true;
    chromium.enablePepperPDF = true;

    packageOverrides = pkgs: {
      jre = pkgs.oraclejre8;
      jdk = pkgs.oraclejdk8;
    };
  };
  
  services.xserver.displayManager.slim.defaultUser = "manky";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.manky = {
    isNormalUser = true;
    home = "/home/manky";
    extraGroups = [ "cdrom" "audio" "wheel" "networkmanager" ];
    description = "Sean Chalmers";
    uid = 1000;
  };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "16.03";

}
