{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.hedgedoc;
in {
  options.link.hedgedoc.enable = mkEnableOption "activate hedgedoc";
  config = mkIf cfg.enable {
    services = {
      hedgedoc = {
        enable = true;
        workDir = "${config.link.storage}/hedgedoc";
        settings = {
          domain = "hedgedoc.${config.link.domain}";
          port = 3400;
          protocolUseSSL = true;
          useSSL = false;
          db = {
            dialect = "sqlite";
            storage = "${config.link.storage}/hedgedoc/db.hedgedoc.sqlite";
          };
        };
      };
      nginx.virtualHosts."hedgedoc.${config.link.domain}" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          proxyPass = "127.0.0.1:${toString config.services.hedgedoc.settings.port}";
        };
      };
    };

  };
}
