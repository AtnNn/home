{ pkgs, ... }:

{
  nebula-ca = pkgs.concatTextFiles {
    name = "nebula-all-ca.crt";
    files = [ ./nebula-ca.crt ./nebula-ca-old.crt ];
  };
  garage_rpc_port = 3901;
}
