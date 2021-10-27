let
  remotes = {
    nixpkgs = "https://nixos.org/channels/nixos-unstable/nixexprs.tar.xz";
    home-manager = "https://github.com/nix-community/home-manager/archive/master.tar.gz";
    rust-overlay = "https://github.com/oxalica/rust-overlay/archive/master.tar.gz";
  };

  nix-path-remotes = pkgs.linkFarm "nix-path" (map (name: { name = name; path = fetchTarball remotes.${name}; }) (builtins.attrNames remotes));
  pkgs = import (fetchTarball remotes.nixpkgs) { overlays = [];};
  home-manager = (import (fetchTarball remotes.home-manager) {inherit pkgs;}).home-manager;

  nix-path = "${nix-path-remotes}:/nix/var/nix/profiles/per-user/root/channels";

in
pkgs.writeScriptBin "home-upgrade" ''
  #!${pkgs.stdenv.shell}
  export NIX_PATH="${nix-path}"
  exec ${home-manager}/bin/home-manager --argstr nix-path "$NIX_PATH" "${"$"}{@:-switch}"
''
