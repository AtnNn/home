{ pkgs, config, lib, ... }:
with lib; let

nebula = import ../nebula.nix { inherit lib; };

host = nebula.hosts.${config.atnnn-mesh.name};

in {
  config.services.nebula.networks.atnnn = (fix self: {
    lighthouses = remove host.ip nebula.lighthouses;
    staticHostMap = nebula.staticHostMap;
    relays = self.lighthouses;
    isRelay = host.lighthouse;
    isLighthouse = host.lighthouse;
    key = "/etc/nebula/${config.atnnn-mesh.name}.key";
    cert = host.crt;
    ca = nebula.ca;
    firewall.inbound = [{
      host = "any";
      port = "any";
      proto = "any";
    }];
    firewall.outbound = [{
      host = "any";
      port = "any";
      proto = "any";
    }];
  });
}
