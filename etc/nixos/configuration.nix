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
    allowedTCPPorts = [ 22 3000 ];
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

  users.extraUsers.atnnn = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" "docker" "audio" "vboxusers" ];
  };

  system.stateVersion = "16.09";

  virtualisation.docker.enable = true;
  virtualisation.virtualbox.host.enable = true;

  nixpkgs.config = {
    allowUnfree = true;
  };

  nix = {
    useSandbox = "relaxed";
    binaryCaches = [ "http://hydra.nixos.org/" "https://cache.nixos.org/" ];
    buildCores = 0;

    # needed for Hydra (https://github.com/NixOS/hydra/issues/430)
    # buildMachines = [
    #   {
    #     hostName = "localhost";
    #     maxJobs = "10";
    #     system = "x86_64-linux";
    #   }
    # ];
  };

  # nix.gc.automatic = true;

  services.hydra-dev = {
    enable = true;
    hydraURL = "http://thanos.atnnn.com:3000";
    notificationSender = "etienne@atnnn.com";
    buildMachinesFiles = [];
  };

  services.postfix = {
    enable = true;
  };
}
