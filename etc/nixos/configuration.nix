{ pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot.loader.grub.enable = true;
  boot.loader.grub.devices = [ "/dev/sda" "/dev/sdb" ]; # or "nodev" for efi only

  networking.hostName = "thanos"; # Define your hostname.

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 443 80 3000 4000 4444 4321 4567 4242 ];
    allowPing = true;
  };

  i18n = {
    defaultLocale = "en_US.UTF-8";
  };

  time.timeZone = "UTC";

  environment.systemPackages = with pkgs; [
    wget docker file git htop ncdu sudo which python3 coreutils vim utillinux
    screen gnupg w3m man man-pages stdmanpages curl nox
  ];

  services.openssh = {
    enable = true;
    listenAddresses = [
      { addr = "0.0.0.0"; port = 22; }
    ];
    settings.X11Forwarding = true;
  };

  users.extraUsers.atnnn = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" "docker" "audio" "vboxusers" ];
  };
  users.extraUsers.nix = {
    isNormalUser = true;
  };

  system.stateVersion = "23.05";

  virtualisation.docker.enable = true;
  virtualisation.virtualbox.host.enable = true;

  nixpkgs.config = {
    allowUnfree = true;
  };

  nix = {
    # useSandbox = "relaxed";
    # sandboxPaths = [ "/home/nix/ccache" ];
    settings.auto-optimise-store = true;    
    settings.substituters = [ "https://cache.nixos.org/" ];
    settings.cores = 12;
    # maxJobs = 3;
    settings.trusted-users = [ "@wheel" ];
    extraOptions = ''
      trusted-substituters = https://lean4.cachix.org/
      trusted-public-keys = cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= lean4.cachix.org-1:mawtxSxcaiWE24xCXXgh3qnvlTkyU7evRRnGeAhD4Wk=
    '';

    distributedBuilds = true; # TODO
    # buildMachines = [
    #   { hostName = "localhost";
    #     maxJobs = 3;
    #     system = "x86_64-linux,i686-LINUX";
    #     supportedFeatures = [ "kvm" ]; }
    # ];
  };

  nix.gc.automatic = true;

  services.hydra = {
    enable = true;
    hydraURL = "https://thanos.atnnn.com";
    notificationSender = "etienne@atnnn.com";
    minimumDiskFree = 5;
    extraConfig = ''
    '';
    useSubstitutes = true;
    buildMachinesFiles = [ (
      builtins.toFile "hydra-build-machines" ''
        localhost x86_64-linux,i686-linux - 3 1 kvm
      ''
    ) ];
    # logo = ./hydra-logo.jpg;
  };
  systemd.services.hydra-evaluator.serviceConfig.Nice = -15;

  services.postfix = {
    enable = true;
  };

  services.nginx = {
    enable = true;
    recommendedOptimisation = true;
    recommendedTlsSettings = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;
    virtualHosts."hydra.atnnn.com" = {
      forceSSL = true;
      # extraConfig = "access_log /var/log/nginx.log;"; # TODO ATN
      enableACME = true;
      locations = {
        "/".proxyPass = "http://localhost:3000";
        "/downloads/" = {
          extraConfig = ''
            autoindex on;
            alias /var/www/downloads/;
          '';
        };
      };
    };
    # virtualHosts."proxy" = {
    #   port = 4000;
    #   locations."/" = {
    #     proxyPass = "http://localhost:8080";
    #   };
    #   basicAuth = { private = "monday"; };
    # };
  };

  security.acme.defaults.email = "etienne@atnnn.com";
  security.acme.acceptTerms = true;

  # programs.ssh.extraConfig = ''
  #  StrictHostKeyChecking no
  # '';

  services.fail2ban.enable = true;

  security.sudo.wheelNeedsPassword = true;

  programs.gnupg.agent.enable = true;

  services.earlyoom = {
    enable = true;
    freeMemThreshold = 1;
    freeSwapThreshold = 50; 
  };

  system.autoUpgrade.enable = true;

  services.nebula.networks.atnnn = {
    enable = true;
    lighthouses = [ "10.85.0.3" ];
    staticHostMap = { "10.85.0.3" = [ "circus.atnnn.com:4242" ]; };
    relays = [ "10.85.0.3" ];
    key = "/etc/nebula/thanos.key";
    cert = "/etc/nebula/thanos.crt";
    ca = "/etc/nebula/ca.crt";
    isRelay = true;
    isLighthouse = true;
    firewall.inbound = [{
      host = "any";
      port = "any";
      proto = "any";
    }];
    firewall.outbound = [{
      host = "any";
      port = "any";
      proto = "any";
    }];
  };
}
