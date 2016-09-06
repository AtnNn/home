# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.extraEntries = ''
    menuentry "gentoo" {
      set root='(hd0,msdos1)'
      linux /boot/vmlinuz-4.3.3-gentoo root=/dev/sda1 acpi_osi="!Windows 2012" pcie_aspm=force acpi_backlight=vendor
    }
  '';
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda";

  networking.hostName = "queen"; # Define your hostname.
  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.wireless.networks = {
    Igtol.psk = "quebeccanada";
  };
  # networking.supplicant.wlp3s0 = {};

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "America/New_York";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    wget
    firefox
    bind
    docker
    emacs
    file
    git
    htop
    lsof
    mplayer
    ncdu
    sudo
    wget
    which
  ];

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "us";
    xkbOptions = "ctrl:nocaps";
    windowManager.xmonad.enable = true;
    windowManager.xmonad.enableContribAndExtras = true;
    windowManager.openbox.enable = true;
    synaptics.enable = true;
    synaptics.horizTwoFingerScroll = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.atnnn = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" "docker" "audio" ];
    createHome = true;
  };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "@nixosRelease@";

  programs.bash.enableCompletion = true;
  
  virtualisation.docker.enable = true;

  hardware.enableAllFirmware = true;

  nixpkgs.config = {
    allowUnfree = true;
  };

  i18n.inputMethod.enabled = "ibus";
  i18n.inputMethod.ibus.engines = [ pkgs.ibus-engines.m17n ];
}
