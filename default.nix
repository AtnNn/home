let

nixpkgs-url = "https://github.com/NixOS/nixpkgs/archive/nixos-23.05.tar.gz";

pkgs = import (builtins.fetchTarball {
  url = nixpkgs-url;
  sha256 = builtins.substring 0 52 (builtins.readFile ./nixpkgs.sha256);
}) {};

mesh = {
  inherit pkgs nixpkgs-url;
  inherit (pkgs) lib;

  nodes = import ./nodes mesh;
  shared = import ./shared mesh;  
};

in mesh