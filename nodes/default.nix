{ lib, shared, ... }@mesh:
with lib; let

defaults = {
  lighthouse = false;
};

make-hosts = mapAttrs (name: id: let
  f = import ./${name} mesh;
  attrs = {
    inherit id name;
    ip = "10.85.0.${toString id}";
    crt = ./${name}/nebula.crt;
  };
  in defaults // attrs // f attrs);

mkProfiles = profiles: {
    server = false;
    desktop = false;
    laptop = false;
    wsl = false;
    extras = false;
  } // profiles // {
    workstation = profiles.laptop or false || profiles.desktop or false;
    linuxWorkstation = (profiles.laptop or false || profiles.desktop or false) && ! profiles.wsl or false;
  };

nodes = {
  inherit mkProfiles;

  ca = shared.nebula-ca;

  hosts = make-hosts {
    stormtrooper = 1;
    circus = 3;
    thanos = 4;
    piezzophone = 5;
    puck = 6;
  };

  lighthouses = map (host: host.ip) (filter (host: host.lighthouse) (attrValues nodes.hosts));

  staticHostMap = concatMapAttrs (name: host:
    if host.lighthouse then { "${host.ip}" = [ "${name}.atnnn.com:4242" ]; } else {}
  ) nodes.hosts;
};

in nodes