{ config, lib, ... }:
with lib;
let cfg = config.link.services.vaultwarden;
in {
  options.link.services.vaultwarden = {
    enable = mkEnableOption "activate vaultwarden";
    expose-port = mkOption {
      type = types.bool;
      default = config.link.service-ports-expose;
      description = "directly expose the port of the application";
    };
    nginx = mkOption {
      type = types.bool;
      default = config.link.nginx.enable;
      description = "expose the application to the internet with NGINX and ACME";
    };
    nginx-expose = mkOption {
      type = types.bool;
      default = config.link.nginx-expose;
      description = "expose the application to the internet";
    };
    port = mkOption {
      type = types.int;
      default = 8222;
      description = "port to run the application on";
    };
  };
  config = mkIf cfg.enable {
    services = {
      vaultwarden = {
        enable = true;
        backupDir = "${config.link.storage}/vaultwarden";
        environmentFile = "${config.link.secrets}/vaultwarden.env";
        config = {
          domain = "https://vaultwarden.${config.link.domain}";
          ROCKET_ADDRESS = "0.0.0.0";
          ROCKET_PORT = cfg.port;
          ROCKET_LOG = "critical";
          # SMTP_HOST = "127.0.0.1";
          # SMTP_PORT = 25;
          # SMTP_SSL = false;
          # SMTP_FROM = "admin@bitwarden.example.com";
          # SMTP_FROM_NAME = "example.com Bitwarden server";
        };
      };
      nginx.virtualHosts."vaultwarden.${config.link.domain}" = mkIf cfg.nginx-expose {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString cfg.port}";
        };
        extraConfig = mkIf (!cfg.nginx-expose) ''
          allow ${config.link.service-ip}/24;
          allow 127.0.0.1;
          deny all; # deny all remaining ips
        '';
      };
    };
    networking.firewall.interfaces."${config.link.service-interface}".allowedTCPPorts = mkIf cfg.expose-port [ cfg.port ];
  };
}
