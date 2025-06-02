{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.services.netbox;
in {
  options.link.services.netbox = {
    enable = mkEnableOption "activate netbox";
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
      default = 8001;
      description = "port to run the application on";
    };
  };
  config = mkIf cfg.enable {
    sops.secrets."netbox" = {
      owner = "netbox";
      group = "netbox";
    };
    services = {
      nginx = {
        enable = true;
        # user = "netbox";
        recommendedTlsSettings = true;
        # clientMaxBodySize = "25m";
        virtualHosts."${config.networking.fqdn}" = {
          locations = {
            "/" = {
              proxyPass = "http://[::1]:8001";
              # proxyPass = "http://${config.services.netbox.listenAddress}:${config.services.netbox.port}";
            };
            "/static/" = {
              alias = "${config.services.netbox.dataDir}/static/";
            };
          };
          serverName = "${config.networking.fqdn}";
        };
      };
      netbox = {
        enable = true;
        package = pkgs.netbox;
        secretKeyFile = config.sops.secrets."netbox".path;
      };
    };
    networking.firewall.interfaces."${config.link.service-interface}".allowedTCPPorts =
      mkIf cfg.expose-port [ cfg.port ];
    systemd.services.netbox-backup.environment.BACKUP = "dump";
  };
}
