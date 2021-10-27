# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ ... }:
let
  pkgs = import (fetchTarball "https://nixos.org/channels/nixos-unstable/nixexprs.tar.xz") {};
in {
  imports = [ ./hardware-configuration.nix ];

  system.stateVersion = "21.05";
  
  boot.loader.grub = {
    enable = true;
    version = 2;
    useOSProber = true;
    device = "/dev/sda";
  };

  networking = {
    hostName = "puck";
    networkmanager.enable = true;
    interfaces.enp0s25.useDHCP = true;
    interfaces.wlp3s0.useDHCP = true;
    firewall.allowedTCPPorts = [ 22 ];
  };

  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "America/Phoenix";
  location = {
    latitude = 33.4;
    longitude = -111.8;
  };

  hardware.opengl.enable = true;
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --cmd sway";
        user = "greeter";
      };
    };
  };
  services.xserver = {
    # enable = true;
    layout = "us";
    xkbOptions = "ctrl:nocaps";
    libinput.enable = true;
    libinput.touchpad.naturalScrolling = true;
    windowManager.openbox.enable = true;
    displayManager.lightdm.enable = false;
  };
  programs.sway = {
    enable = true;
    # extraPackages = with pkgs; [];
    # extraSessionCommands = '' '';
  };

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  users.users.atnnn = {
     isNormalUser = true;
     extraGroups = [ "wheel" "networkmanager" "audio" "docker" ]; # Enable ‘sudo’ for the user. 
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    powertop
    acpi
    w3m
  ];

  programs.mtr.enable = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  services.openssh.enable = true;

  services.locate.enable = true;

  services.redshift.enable = true;

  hardware.bluetooth.enable = true;

  nixpkgs.config = {
    allowUnfree = true;
  };

  fonts = {
    enableDefaultFonts = true;
    fontDir.enable = true;
    fonts = with pkgs; [
      dejavu_fonts freefont_ttf unifont unifont_upper
    ];
  };

  virtualisation.docker.enable = true;

  powerManagement = {
    enable = true;
    cpuFreqGovernor = "ondemand";
    powertop.enable = true;
  };
  services.logind = {
    lidSwitch = "hybrid-sleep";
    lidSwitchDocked = "ignore";
    lidSwitchExternalPower = "ignore";
  };
  services.upower = {
    enable = true;
    criticalPowerAction = "HybridSleep";
  };
  services.auto-cpufreq.enable = true;
}

