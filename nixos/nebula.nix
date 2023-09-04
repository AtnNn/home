mesh: { config, ... }:

with mesh.lib; let

host = config.atnnn-mesh.host;

lighthouses = remove host.ip mesh.nodes.lighthouses;

in {
  config.services.nebula.networks.atnnn = {
    staticHostMap = mesh.nodes.staticHostMap;
    relays = lighthouses;
    isRelay = host.lighthouse;
    isLighthouse = host.lighthouse;
    key = "/etc/nebula/${host.name}.key";
    cert = host.crt;
    ca = mesh.nodes.ca;
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
  };
}
