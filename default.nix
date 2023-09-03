let

nixpkgs-url = "https://github.com/NixOS/nixpkgs/archive/nixos-23.05.tar.gz";

nixpkgs = builtins.fetchTarball {
  url = nixpkgs-url;
  sha256 = builtins.substring 0 52 (builtins.readFile ./nixpkgs.sha256);
};

pkgs = import nixpkgs {};

mesh = {
  inherit pkgs nixpkgs nixpkgs-url;
  inherit (pkgs) lib;

  nodes = import ./nodes mesh;
  shared = import ./shared mesh;
  modules = import ./nixos mesh; 
};

in mesh