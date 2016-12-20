{ config, pkgs, ... }:

let hydraSrc = builtins.fetchTarball "https://github.com/NixOS/hydra/archive/de55303197d997c4fc5503b52b1321ae9528583d.tar.gz"; in

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      "${hydraSrc}/hydra-module.nix"
    ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.devices = [ "/dev/sda" "/dev/sdb" ]; # or "nodev" for efi only

  networking.hostName = "thanos"; # Define your hostname.

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 443 80 ];
    allowPing = true;
  };

  i18n = {
    defaultLocale = "en_US.UTF-8";
  };

  time.timeZone = "UTC";

  environment.systemPackages = with pkgs; [
    wget nano docker emacs file git htop ncdu sudo which ghc python3 coreutils vim utillinux p7zip
    zip unzip nmap gcc6 llvm screen gnupg w3m gdb man gnumake graphviz ruby wine man-pages stdmanpages
    clang curl nox
  ];

  services.openssh.enable = true;
  services.openssh.permitRootLogin = "yes";
  services.openssh.listenAddresses = [
    { addr = "0.0.0.0"; port = 22; }
    # { addr = "0.0.0.0"; port = 443; }
  ];

  users.extraUsers.atnnn = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" "docker" "audio" "vboxusers" ];
  };
  users.extraUsers.nix = {
    isNormalUser = true;
  };

  system.stateVersion = "16.09";

  virtualisation.docker.enable = true;
  virtualisation.virtualbox.host.enable = true;

  nixpkgs.config = {
    allowUnfree = true;
  };

  nix = {
    useSandbox = "relaxed";
    sandboxPaths = [ "/home/nix/ccache" ];
    binaryCaches = [ "http://hydra.nixos.org/" "https://cache.nixos.org/" ];
    buildCores = 12;
    maxJobs = 3;

    distributedBuilds = false; # TODO
    buildMachines = [
      { hostName = "localhost";
        sshUser = "root";
        sshKey = "/root/.ssh/id_rsa";
        maxJobs = 3;
        system = "x86_64-linux,i686-linux";
        supportedFeatures = [ "kvm" ]; }
    ];
  };

  # nix.gc.automatic = true;

  services.hydra-dev = {
    enable = true;
    hydraURL = "https://thanos.atnnn.com";
    notificationSender = "etienne@atnnn.com";
    buildMachinesFiles = [];
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
      port = 443;
      enableSSL = true;
      extraConfig = "listen 80; listen [::]:80;";
      enableACME = true;
      locations."/" = {
        proxyPass = "http://localhost:3000";
      };
    };
  };

  security.acme.certs."thanos.atnnn.com" = {
    postRun = "systemctl reload nginx.service";
    email = "etienne@atnnn.com";
  };

  programs.ssh.extraConfig = ''
    StrictHostKeyChecking no
  '';
}
