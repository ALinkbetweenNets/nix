{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.services.grafana;
in {
  options.link.services.grafana = {
    enable = mkEnableOption "activate grafana";
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
    port = mkOption {
      type = types.int;
      default = 7890;
      description = "port to run the application on";
    };
  };
  config = mkIf cfg.enable {
    services = {
      grafana = {
        enable = true;
        settings = {
          server = {
            domain = "grafana.${config.link.domain}";
            http_addr = if cfg.expose-port then "0.0.0.0" else "127.0.0.1";
            http_port = cfg.port;
          };
        };
      };
      nginx.virtualHosts."grafana.${config.link.domain}" = mkIf cfg.nginx {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://${
              toString config.services.grafana.settings.server.http_addr
            }:${toString config.services.grafana.settings.server.http_port}/";
          proxyWebsockets = true;
        };
      };
    };
    networking.firewall.interfaces."${config.link.service-interface}".allowedTCPPorts =
      mkIf cfg.expose-port [ cfg.port ];
  };
}
