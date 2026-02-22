let
  remotes = {
    nixpkgs.url = "https://nixos.org/channels/nixos-unstable/nixexprs.tar.xz";
    nixpkgs.patches = [
      /home/atnnn/.config/nixpkgs/patches/491704.patch
    ];
    home-manager.url = "https://github.com/nix-community/home-manager/archive/master.tar.gz";
    rust-overlay.url = "https://github.com/oxalica/rust-overlay/archive/master.tar.gz";
  };

  nix-path-remotes = pkgs.linkFarm "nix-path" (builtins.attrValues nix-path);
  nix-path = (builtins.mapAttrs (name: { url, patches ? [] }: {
    name = name;
    path =
      let src = fetchTarball url; in
      if patches != []
      then pkgsBoot.applyPatches { inherit name src patches; }
      else src;
  }) remotes);
  pkgsBoot = import (fetchTarball remotes.nixpkgs.url) { overlays = [];};
  pkgs = import nix-path.nixpkgs.path { overlays = [];};
  home-manager = (import nix-path.home-manager.path {inherit pkgs;}).home-manager;

  nix-path-string = "${nix-path-remotes}";

in
pkgs.writeScriptBin "home-upgrade" ''
  #!${pkgs.stdenv.shell}
  export NIX_PATH="${nix-path-string}"
  exec ${home-manager}/bin/home-manager "${"$"}{@:-switch}"
''
