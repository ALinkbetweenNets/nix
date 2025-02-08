{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.services.cockpit;
in {
  options.link.services.cockpit = {
    enable = mkEnableOption "activate cockpit";
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
      default = 9090;
      description = "port to run the application on";
    };
  };
  config = mkIf cfg.enable {
    services.cockpit={
      enable=true;
      port=cfg.port;
    };
    networking.firewall.allowedTCPPorts = mkIf cfg.expose-port [ cfg.port ];
  };
}
