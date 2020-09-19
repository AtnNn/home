{ ... }:

let
pkgs = import (fetchTarball "https://nixos.org/channels/nixos-20.09/nixexprs.tar.xz") {};
in

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.devices = [ "/dev/sda" "/dev/sdb" ]; # or "nodev" for efi only

  networking.hostName = "thanos"; # Define your hostname.

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 443 80 3000 4000 4444 4321 4567];
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
    forwardX11 = true;
  };

  users.extraUsers.atnnn = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" "docker" "audio" "vboxusers" ];
  };
  users.extraUsers.nix = {
    isNormalUser = true;
  };

  system.stateVersion = "19.03";

  virtualisation.docker.enable = true;
  virtualisation.virtualbox.host.enable = true;

  nixpkgs.config = {
    allowUnfree = true;
  };

  nix = {
    useSandbox = "relaxed";
    sandboxPaths = [ "/home/nix/ccache" ];
    binaryCaches = [ "https://cache.nixos.org/" ];
    buildCores = 12;
    maxJobs = 3;
    extraOptions = "auto-optimise-store = true";

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
      max_output_size = 2147483647;
      <github_authorization>
        rethinkdb = ${builtins.readFile ./github_token}
      </github_authorization>
      <githubstatus>
        jobs = checkStyle|unitTests
        inputs = rethinkdb
        excludeBuildFromContext = 0
      </githubstatus>
    '';
    buildMachinesFiles = [ (
      builtins.toFile "hydra-build-machines" ''
        localhost x86_64-linux,i686-linux - 3 1 kvm
      ''
    ) ];
    logo = ./hydra-logo.jpg;
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
    virtualHosts."thanos.atnnn.com" = {
      forceSSL = true;
      extraConfig = "access_log /var/log/nginx.log;";
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

  security.acme.certs."thanos.atnnn.com" = {
    postRun = "systemctl reload nginx.service";
    email = "etienne@atnnn.com";
  };

  programs.ssh.extraConfig = ''
    StrictHostKeyChecking no
  '';

  services.fail2ban.enable = true;

  security.sudo.wheelNeedsPassword = false;

  programs.gnupg.agent.enable = true;

  services.earlyoom = {
    enable = true;
    freeMemThreshold = 1;
    freeSwapThreshold = 50; 
  };
}
