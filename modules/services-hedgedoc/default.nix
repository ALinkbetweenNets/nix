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
  };
  config = mkIf cfg.enable {
    services = {
      hedgedoc = {
        enable = true;
        # workDir = "${config.link.storage}/hedgedoc";
        settings = {
          domain = "hedgedoc.${config.link.domain}";
          host = "127.0.0.1";
          port = 3400;
          protocolUseSSL = true;
          useSSL = false;
          # db = {
          #   dialect = "sqlite";
          #   storage = "${config.link.storage}/hedgedoc/db.sqlite";
          # };
        };
      };
      nginx.virtualHosts."hedgedoc.${config.link.domain}" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString config.services.hedgedoc.settings.port}";
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
