mesh: spec: {
  lighthouse = true;
  profiles = mesh.nodes.mkProfiles {
    server = true;
    extra = true;
  };
}
