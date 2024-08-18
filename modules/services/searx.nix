{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.services.searx;
in {
  options.link.services.searx = {
    enable = mkEnableOption "activate searx";
    expose-port = mkOption {
      type = types.bool;
      default = config.link.service-ports-expose;
      description = "directly expose the port of the application";
    };
    nginx = mkOption {
      type = types.bool;
      default = config.link.nginx.enable;
      description =
        "expose the application to the internet with NGINX and ACME";
    };
    nginx-expose = mkOption {
      type = types.bool;
      default = config.link.nginx-expose;
      description = "expose the application to the internet";
    };
    port = mkOption {
      type = types.int;
      default = 6715;
      description = "port to run the application on";
    };
  };
  config = mkIf cfg.enable {
    sops.secrets.searx = { };
    services = {
      searx = {
        enable = true;
        redisCreateLocally = true;
        environmentFile = config.sops.secrets.searx.path;
        settings = {
          server = {
            port = cfg.port;
            bind_address = if cfg.expose-port then "0.0.0.0" else "127.0.0.1";
            secret_key = "@SEARX_SECRET_KEY@";
          };
        };
        uwsgiConfig = { };
      };
    };
  };
}
