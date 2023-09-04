{ ... }: let

  mesh = import ../..;

in {
  imports = [
    ./hardware-configuration.nix
    mesh.modules.node
  ];

  atnnn-mesh.host = mesh.nodes.hosts.puck;

  system.stateVersion = "22.05";

  boot.loader.grub.device = "/dev/sda";

  networking.interfaces = {
    enp0s25.useDHCP = true;
    wlp3s0.useDHCP = true;
  };
}

