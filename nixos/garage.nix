mesh: { pkgs, config, ... }:

with mesh.lib; let

host = config.atnnn-mesh.host;

in {
  config.services.garage = {
    package = pkgs.garage_2;
    enable = true;
    settings = {
      replication_factor = 3;
      rpc_bind_addr = "[::]:${toString mesh.shared.garage_rpc_port}";
      s3_api = {
        s3_region = "atnnn";
        api_bind_addr = "[::1]:3900";
        root_domain = ".s3.atnnn";
      };
      s3_web = {
        bind_addr = "[::1]:3902";
        root_domain = ".web.atnnn";
        index = "index.html";
      };
    };
  };
  config.systemd.services.garage = {
    environment = {
      GARAGE_RPC_SECRET_FILE = "%d/garage_rpc_secret";
      GARAGE_ALLOW_WORLD_READABLE_SECRETS = "true";
    };
    serviceConfig.LoadCredential = "garage_rpc_secret:/etc/garage/rpc_secret";
  };
  environment.variables.GARAGE_RPC_SECRET_FILE = "/etc/garage/rpc_secret";
}
