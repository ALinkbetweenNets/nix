{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.searx;
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
      default = 9483;
      description = "port to run the application on";
    };
  };
  config = mkIf cfg.enable {
    sops.secrets.microbin={};
    services = {
      microbin = {
        enable = true;
        passwordFile=config.sops.secrets.microbin.path;
        settings = {
          MICROBIN_HIDE_LOGO = true;
          MICROBIN_PORT = cfg.port;

        };
      };
    };
  };
}
