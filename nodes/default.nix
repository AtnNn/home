{ lib, shared, ... }@mesh:
with lib; let

make-nodes = mapAttrs (name: spec: let
  f = import ./${name} mesh;
  attrs = spec // {
    ip = "10.85.0.${toString spec.id}";
    crt = ./nodes/${name}/nebula.crt;
    lighthouse = spec.lighthouse or false;
  };
  in f attrs // attrs;
});

in fix (self: {
  ca = ./shared/nebula-ca.crt;

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
