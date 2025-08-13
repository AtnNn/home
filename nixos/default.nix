mesh: {
  node = import ./node.nix mesh;
  nebula = import ./nebula.nix mesh;
  garage = import ./garage.nix mesh;
}
