{ ... }: let

  mesh = import ../..;

in {
  imports = [
    ./hardware-configuration.nix
    mesh.modules.node
  ];

  atnnn-mesh.host = mesh.nodes.hosts.limbo;

  system.stateVersion = "26.05";

  boot.loader.grub.device = "/dev/nvme0n1p1";

  networking.interfaces = {
    enp1s0.useDHCP = true;
    wlp2s0.useDHCP = true;
  };

  boot.loader.grub.enable = false;

  boot.loader.systemd-boot.enable = true;
}
