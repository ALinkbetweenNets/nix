{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.services.onlyoffice;
in {
  options.link.services.onlyoffice = {
    enable = mkEnableOption "activate onlyoffice";
    expose = mkOption {
      type = types.bool;
      default = config.link.expose;
      description = "expose onlyoffice to the internet with NGINX and ACME";
    };
    nginx = mkOption {
      type = types.bool;
      default = config.link.nginx.enable;
      description = "Use service with NGINX";
    };
  };
  config = mkIf cfg.enable {
    services = {
      onlyoffice = {
        enable = true;
        hostname = "onlyoffice.${config.link.domain}";
        port = 8000;

      };
      nginx.virtualHosts."onlyoffice.${config.link.domain}" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString config.services.onlyoffice.port}";
        };
        extraConfig = mkIf (!cfg.expose) ''
          allow ${config.link.service-ip}/24;
          deny all; # deny all remaining ips
        '';
      };
    };
  };
}
