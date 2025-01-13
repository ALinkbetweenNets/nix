{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.services.audiobookshelf;
in {
  options.link.services.audiobookshelf = {
    enable = mkEnableOption "activate audiobookshelf";
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
      default = 4124;
      description = "port to run the application on";
    };
  };
  config = mkIf cfg.enable {
    services.audiobookshelf = {
      enable = true;
      port = cfg.port;
      host = if cfg.expose-port then "0.0.0.0" else "127.0.0.1";
    };
    networking.firewall.allowedTCPPorts = mkIf cfg.expose-port [ cfg.port ];
  };
}
