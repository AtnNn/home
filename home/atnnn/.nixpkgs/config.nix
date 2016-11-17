{
  allowUnfree = true;
  allowBroken = true;
  packageOverrides = pkgs: rec {
    phpstorm-oraclejdk = pkgs.idea.phpstorm.override {
        jdk = pkgs.oraclejdk8psu;
    };
  };
}
