{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.nextcloud;
in {
  options.link.nextcloud.enable = mkEnableOption "activate nextcloud";
  config = mkIf cfg.enable {
    services = {
      grafana = {
        enable = false;
        settings.server = {
          domain = "grafana.alinkbetweennets.de";
          http_addr = "127.0.0.1";
          http_port = 7890;
        };
      };
      nginx.virtualHosts."grafana.alinkbetweennets.de" = {
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
