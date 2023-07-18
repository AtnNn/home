{ lib }:
with lib; let

make-hosts = mapAttrs (name: host: host // {
  ip = "10.85.0.${toString host.id}";
  crt = ./nebula/${name}.crt;
  lighthouse = host.lighthouse or false;
});

in fix (self: {
  ca = ./nebula/ca.crt;

  hosts = make-hosts {
    stormtrooper = {
      id = 2;
    };
    circus = {
      id = 3;
      lighthouse = true;
    };
    thanos = {
      id = 4;
      lighthouse = true;
    };
    piezzophone = {
      id = 5;
    };
    puck = {
      id = 6;
    };
  };

  lighthouses = map (host: host.ip) (filter (host: host.lighthouse) (attrValues self.hosts));

  staticHostMap = concatMapAttrs (name: host: if host.lighthouse then { "${host.ip}" = [ "${name}.atnnn.com:4242" ]; } else {}) self.hosts;
})
