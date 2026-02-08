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

  services.minidlna = {
    enable = true;
    settings.inotify = "yes";
    settings.notify_interval = 30;
    settings.media_dir = [ "/var/media-server" ];
    settings.wide_links = "yes";
    openFirewall = true;
  };
}

