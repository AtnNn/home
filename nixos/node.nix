mesh: { pkgs, lib, config, ... }:

with lib; let

host = config.atnnn-mesh.host;

mesa_AZ = {
  latitude = 33.4;
  longitude = -111.8;
};

in {
  options.atnnn-mesh = {
    host = mkOption {
      type = types.anything;
      description = mdDoc "hostname and machine identifier";
      default = null;
    };
  };

  imports = [
    mesh.modules.nebula
  ];

  config = mkIf (host != null) (mkMerge [{

    nixpkgs = {
      pkgs = mesh.pkgs;
      config = {
        allowUnfree = true;
      };
    };

    networking = {
      hostName = host.name;
      firewall = {
        enable = true;
        allowedTCPPorts = [ 22 ];
	allowPing = true;
      };
    };

    system.copySystemConfiguration = true;

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
      coreutils
      utillinux
      screen
      ncdu
      file
    ];

    programs.mtr.enable = true;

    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    services.openssh.enable = true;

    services.fail2ban.enable = true;

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
      extraOptions = ''
        experimental-features = nix-command flakes recursive-nix
      '';
    };

    system.autoUpgrade.enable = true;

    services.journalwatch = {
      enable = true;
      mailTo = "etienne@atnnn.com";
      priority = 4; # warning
    };

    services.postfix = {
      enable = true;
      domain = "${host.name}.atnnn.com";
      hostname = "${host.name}.atnnn.com";
      virtual = "@${host.name}.atnnn.com etienne@atnnn.com";
      extraConfig = ''
        inet_interfaces = loopback-only
      '';
    };

    services.nebula.networks.atnnn.enable = true;

  } (mkIf host.profiles.linuxWorkstation {

    services.redshift.enable = true;

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

    hardware.bluetooth.enable = true;

  }) (mkIf host.profiles.workstation {

    location = mesa_AZ;

    hardware.opengl.enable = true;

    sound.enable = true;

    services.pipewire.enable = true;

    services.printing = {
      enable = true;
      drivers = [ pkgs.hplip ];
    };

    services.avahi = {
      enable = true;
      nssmdns = true;
    };

  }) (mkIf host.profiles.laptop {

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

  }) (mkIf host.profiles.extras {

    virtualisation.docker.enable = true;

    fonts = {
      enableDefaultFonts = true;
      fontDir.enable = true;
      fonts = with pkgs; [
        dejavu_fonts freefont_ttf unifont unifont_upper
        font-awesome noto-fonts noto-fonts-emoji
      ];
    };

  })]);
}
