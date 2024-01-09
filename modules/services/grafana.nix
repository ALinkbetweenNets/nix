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
      networking.firewall.interfaces."${config.link.service-interface}".allowedTCPPorts = [ 7890 9005 ];
      prometheus = {
        enable = true;
        port = 9005;
        exporters = {
          zfs = {
            enable = true;
            listenAddress = "127.0.0.1";
          };
          # nextcloud={
          #   enable=true;
          #   username="l";
          #   user="l";
          #   port="443";
          # };
        };
        scrapeConfigs = [
          {
            job_name = "zfs";
            static_configs = [{
              targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.zfs.port}" ];
            }];
          }
        ];
      };
    };
  };
}
