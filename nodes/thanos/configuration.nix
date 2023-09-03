{ pkgs, ... }: let

  mesh = import ../..;

in {
  imports = [
    mesh.modules.node
    ./hardware-configuration.nix
  ];

  atnnn-mesh.host = mesh.nodes.hosts.thanos;

  boot.loader.grub.enable = true;
  boot.loader.grub.devices = [ "/dev/sda" "/dev/sdb" ]; # or "nodev" for efi only

  networking.firewall = {
    allowedTCPPorts = [ 443 80 3000 4000 4444 4321 4567 4242 ];
  };

  system.stateVersion = "23.05";

  nix = {
    settings.cores = 12;
    distributedBuilds = true; # TODO
    # buildMachines = [
    #   { hostName = "localhost";
    #     maxJobs = 3;
    #     system = "x86_64-linux,i686-LINUX";
    #     supportedFeatures = [ "kvm" ]; }
    # ];
  };

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
    # };
  };

  security.acme.defaults.email = "etienne@atnnn.com";
  security.acme.acceptTerms = true;

  programs.gnupg.agent.enable = true;

  services.earlyoom = {
    enable = true;
    freeMemThreshold = 1;
    freeSwapThreshold = 50; 
  };
}

