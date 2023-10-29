{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.photoprism;
in {
  options.link.photoprism.enable = mkEnableOption "activate photoprism";
  config = mkIf cfg.enable {
    services = {
      photoprism = {
        enable = true;
        originalsPath = "${config.link.storage}/photoprism/data";
        storagePath = "${config.link.storage}/photoprism/storage";
        settings = {
          PHOTOPRISM_ADMIN_USER = "l";
          PHOTOPRISM_DEFAULT_LOCALE = "de";
          PHOTOPRISM_SITE_URL = "https://photoprism.${config.link.domain}";
        };
        port = 2342;
        passwordFile = "${config.link.secrets}/photoprism";
        address = "0.0.0.0";
      };
      nginx.virtualHosts."photoprism.${config.link.domain}" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = { proxyPass = "http://127.0.0.1:2342/"; };
      };
    };
  };
}
