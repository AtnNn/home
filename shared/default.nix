{ pkgs, ... }:

{
  nebula-ca = pkgs.concatTextFile {
    name = "nebula-all-ca.crt";
    files = [ ./nebula-ca.crt ./nebula-ca-previous.crt ];
  };
  garage_rpc_port = 3901;
}
