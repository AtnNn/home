{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    /home/atnnn/code/mesh/nixos
  ];

  atnnn-mesh = {
    profile.laptop = true;
    profile.extras = true;
    name = "puck";
  };

  system.stateVersion = "22.05";

  boot.loader.grub.device = "/dev/sda";

  networking.interfaces = {
    enp0s25.useDHCP = true;
    wlp3s0.useDHCP = true;
  };

}

