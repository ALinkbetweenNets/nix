{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.services.vaultwarden;
in {
  options.link.services.vaultwarden = {
    enable = mkEnableOption "activate vaultwarden";
    expose = mkOption {
      type = types.bool;
      default = false;
      description = "expose vaultwarden to the internet with NGINX and ACME";
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
          ROCKET_ADDRESS = "127.0.0.1";
          ROCKET_PORT = 8222;
          ROCKET_LOG = "critical";
          # SMTP_HOST = "127.0.0.1";
          # SMTP_PORT = 25;
          # SMTP_SSL = false;
          # SMTP_FROM = "admin@bitwarden.example.com";
          # SMTP_FROM_NAME = "example.com Bitwarden server";
        };
      };
      nginx.virtualHosts."vaultwarden.${config.link.domain}" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString config.services.vaultwarden.config.ROCKET_PORT}";
        };
        extraConfig = mkIf (!cfg.expose) ''
          allow ${config.link.service-ip}/24;
          allow 127.0.0.1;
          deny all; # deny all remaining ips
        '';
      };
    };
  };
}
