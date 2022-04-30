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
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --cmd /run/current-system/sw/bin/sway";
        user = "greeter";
      };
    };
    vt = 7;
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
    ntfs3g
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
      font-awesome noto-fonts noto-fonts-emoji
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
  services.pipewire.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      # xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
    ];
    gtkUsePortal = true;
  };
  nix = {
    autoOptimiseStore = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };
  services.printing = {
    enable = true;
    drivers = [ pkgs.hplip ];
  };
  services.avahi = {
    enable = true;
    nssmdns = true;
  };
}

