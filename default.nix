let

nixpkgs-url = "https://github.com/NixOS/nixpkgs/archive/master.tar.gz";

nixpkgs = builtins.fetchTarball {
  url = nixpkgs-url;
  sha256 = builtins.substring 0 52 (builtins.readFile ./nixpkgs.sha256);
};

pkgs = import nixpkgs {
  allowUnfree = true;
};

mesh = {
  inherit pkgs nixpkgs nixpkgs-url;
  inherit (pkgs) lib;

  nodes = import ./nodes mesh;
  shared = import ./shared mesh;
  modules = import ./nixos mesh;
};

in mesh
