{ config, pkgs, ... }:

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
    allowedTCPPorts = [ 22 3000 ];
    allowPing = true;
  };

  i18n = {
    defaultLocale = "en_US.UTF-8";
  };

  time.timeZone = "UTF-8";

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
    useSandbox = true;
    binaryCaches = [ "http://hydra.nixos.org/" "https://cache.nixos.org/" ];
  };

  # nix.gc.automatic = true;

  services.hydra = {
    enable = true;
    hydraURL = "http://thanos.atnnn.com:3000";
    notificationSender = "etienne@atnnn.com";
    
  };
}
