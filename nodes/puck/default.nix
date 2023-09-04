mesh: spec: {
  profiles = mesh.nodes.mkProfiles {
    laptop = true;
    extras = true;
  };
}
