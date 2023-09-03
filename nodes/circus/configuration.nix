{ ... }: let

mesh = import ../..;

in {
  imports = [
    ./hardware-configuration.nix
    mesh.modules.node
  ];

  atnnn-mesh.host = mesh.nodes.hosts.circus;

  boot.loader.grub.device = "nodev";
  boot.loader.grub.forceInstall = true;

  system.stateVersion = "22.11"; # Did you read the comment?

  networking.usePredictableInterfaceNames = false;
  networking.interfaces.eth0.useDHCP = true;
}
