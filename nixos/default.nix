{ pkgs, lib, config, ... }:

with lib; let

mesh = config.atnnn-mesh;

workstation = mesh.profile.laptop || mesh.profile.desktop;

linuxWorkstation = workstation && ! mesh.profile.wsl;

mesa_AZ = {
  latitude = 33.4;
  longitude = -111.8;
};

in {
  options.atnnn-mesh = {
    enable = mkEnableOption "AtnNn mesh device";

    name = mkOption {
      type = types.str;
      description = mdDoc "hostname and machine identifier";
    };

    profile.server = mkEnableOption "mesh server";
    profile.desktop = mkEnableOption "desktop configuration";
    profile.laptop = mkEnableOption "laptop configuraiton";
    profile.wsl = mkEnableOption "WSL configuration";
    profile.extras = mkEnableOption "extra packages and services";
  };

  imports = [
    ./nebula.nix
  ];

  config = mkMerge [{

    atnnn-mesh.enable = mkDefault (
      mesh.profile.server ||
      mesh.profile.desktop ||
      mesh.profile.laptop ||
      mesh.profile.wsl ||
      mesh.profile.extras);

  } (mkIf mesh.enable {

    networking = {
      hostName = mesh.name;
      firewall.allowedTCPPorts = [ 22 ];
    };

    i18n.defaultLocale = "en_US.UTF-8";

    time.timeZone = "America/Phoenix";

    users.users.atnnn = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" "audio" "docker" ];
    };

    environment.systemPackages = with pkgs; [
      vim
      wget
      smartmontools
    ];

    programs.mtr.enable = true;

    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    services.openssh.enable = true;

    services.locate.enable = true;

    services.redshift.enable = mkIf linuxWorkstation true;

    hardware.bluetooth.enable = mkIf workstation true;

    nixpkgs.config = {
      allowUnfree = true;
    };

    nix = {
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 30d";
      };
      settings = {
        auto-optimise-store = true;
        trusted-substituters = [
          "https://lean4.cachix.org/"
        ];
      };
    };

    services.nebula.networks.atnnn.enable = true;

  }) (mkIf linuxWorkstation {

    boot.loader.grub = {
      enable = true;
      useOSProber = true;
    };

    networking.networkmanager.enable = true;

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

    programs.sway = {
      enable = true;
      # extraPackages = with pkgs; [];
      # extraSessionCommands = '' '';
    };

  }) (mkIf workstation {

    location = mesa_AZ;

    hardware.opengl.enable = true;

    sound.enable = true;

    services.pipewire = {
      enable = true;
      pulse.enable = true;
      alsa.enable = true;
    };

    services.printing = {
      enable = true;
      drivers = [ pkgs.hplip ];
    };

    services.avahi = {
      enable = true;
      nssmdns = true;
    };

  }) (mkIf mesh.profile.laptop {

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

    environment.systemPackages = with pkgs; [
      powertop
      acpi
    ];

    services.auto-cpufreq.enable = true;

  }) (mkIf mesh.profile.extras {

    virtualisation.docker.enable = true;

    fonts = {
      enableDefaultFonts = true;
      fontDir.enable = true;
      fonts = with pkgs; [
        dejavu_fonts freefont_ttf unifont unifont_upper
        font-awesome noto-fonts noto-fonts-emoji
      ];
    };

  })];
}
