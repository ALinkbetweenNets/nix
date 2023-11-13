{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.services.hedgedoc;
in {
  options.link.services.hedgedoc = {
    enable = mkEnableOption "activate hedgedoc";
    expose = mkOption {
      type = types.bool;
      default = config.link.expose;
      description = "expose hedgedoc to the internet with NGINX and ACME";
    };
    nginx = mkOption {
      type = types.bool;
      default = config.link.nginx.enable;
      description = "Use service with NGINX";
    };
  };
  config = mkIf cfg.enable {
    services = {
      hedgedoc = {
        enable = true;
        # workDir = "${config.link.storage}/hedgedoc";
        settings = {
          domain = if cfg.nginx then "hedgedoc.${config.link.domain}" else "${config.link.service-ip}:${toString config.services.hedgedoc.settings.port}";
          port = 3400;
          protocolUseSSL = mkIf cfg.nginx true;
          useSSL = false;
          db = {
            dialect = "sqlite";
            storage = "${config.link.storage}/hedgedoc/db.hedgedoc.sqlite";
          };
        };
      };
      nginx.virtualHosts."hedgedoc.${config.link.domain}" =mkIf cfg.nginx {
        enableACME = mkIf cfg.expose true;
        forceSSL = true;
        locations."/" = {
          proxyPass = "127.0.0.1:${toString config.services.hedgedoc.settings.port}/";
        };
      };
    };

  };
}
