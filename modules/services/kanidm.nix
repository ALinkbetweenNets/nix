{
  config,
  system-config,
  pkgs,
  lib,
  ...
}:
with lib;
let
  cfg = config.link.services.kanidm;
in
{
  options.link.services.kanidm = {
    enable = mkEnableOption "activate kanidm";
    expose-port = mkOption {
      type = types.bool;
      default = config.link.service-ports-expose;
      description = "directly expose the port of the application";
    };
    nginx = mkOption {
      type = types.bool;
      default = config.link.nginx.enable;
      description = "expose the application to the internet with NGINX and ACME";
    };
    nginx-expose = mkOption {
      type = types.bool;
      default = config.link.nginx-expose;
      description = "expose the application to the internet";
    };
    port = mkOption {
      type = types.int;
      default = 9999;
      description = "port to run the application on";
    };
  };
  config = mkIf cfg.enable {
    sops.secrets.kanidm = {
      owner = "kanidm";
      group = "kanidm";
    };
    # services.kanidm = {
    #   # database.createDB = false;
    #   enable = true;
    #   serverSettings ={bindaddress = "127.0.0.1:${cfg.port}";};
    #   clientSettings ={uri="https";};
    #   # port = cfg.port;
    #   # host = if cfg.expose-port then "0.0.0.0" else "localhost";
    #   # secretsFile = config.sops.secrets.kanidm.path;
    # };
    # networking.firewall.allowedTCPPorts = mkIf cfg.expose-port [ cfg.port ];
    # sops.secrets.kanidm = {
    #   path = "/run/keys/kanidm.env";
    };
}
