{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.grafana;
in {
  options.link.grafana.enable = mkEnableOption "activate grafana";
  config = mkIf cfg.enable {
    services = {
      grafana = {
        enable = true;
        settings.server = {
          domain = "grafana.${config.link.domain}";
          http_addr = "127.0.0.1";
          http_port = 7890;
        };
      };
      nginx.virtualHosts."grafana.${config.link.domain}" = {
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

  };
}
