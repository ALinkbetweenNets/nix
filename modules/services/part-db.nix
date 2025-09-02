{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.services.part-db;
in {
  options.link.services.part-db = {
    enable = mkEnableOption "activate part-db";
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
      default = 3400;
      description = "port to run the application on";
    };
  };
  config = mkIf cfg.enable {
    services = {
      part-db = {
        enable = true;
        virtualHost =
          if cfg.nginx then
            "part-db.${config.link.domain}"
          else
            config.networking.hostName;
        enableNginx = true;
      };
    };
  };
}
