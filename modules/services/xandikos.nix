{ config, pkgs, lib, ... }:
with lib;
let cfg = config.link.services.xandikos;
in {
  options.link.services.xandikos = {
    enable = mkEnableOption "activate xandikos";
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
      default = 8080;
      description = "port to run the application on";
    };
  };
  config = mkIf cfg.enable {

    services = {
      xandikos = {
        # package = pkgs.cudapkgs.xandikos;
        enable = true;
        extraOptions = [
          "--autocreate"
          "--defaults"
          "--current-user-principal user"
          "--dump-dav-xml"
        ];
        routePrefix = "/";
        address = if cfg.expose-port then "0.0.0.0" else "localhost";
        nginx = mkIf cfg.nginx {
          hostName = "cal.${config.link.domain}";
          enable = true;
        };
      };
      nginx.virtualHosts."cal.${config.link.domain}" = mkIf cfg.nginx {
        enableACME = true;
        forceSSL = true;
        # locations."/" = { proxyPass = "http://127.0.0.1:${toString cfg.port}/"; };
      };
    };
    networking.firewall.interfaces."${config.link.service-interface}".allowedTCPPorts =
      mkIf cfg.expose-port [ cfg.port ];
  };
}
