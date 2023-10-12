{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.nextcloud;
in {
  options.link.nextcloud.enable = mkEnableOption "activate nextcloud";
  config = mkIf cfg.enable {
    services = {
      photoprism = {
        enable = true;
        originalsPath = "/rz/srv/photoprism/data";
        storagePath = "/rz/srv/photoprism/storage";
        settings = {
          PHOTOPRISM_ADMIN_USER = "l";
          PHOTOPRISM_ADMIN_PASSWORD = "S25!photoprism";
          PHOTOPRISM_DEFAULT_LOCALE = "de";
          PHOTOPRISM_SITE_URL = "https://photoprism.alinkbetweennets.de";
        };
        port = 2342;
        passwordFile = "/pwd/photoprism";
        address = "0.0.0.0";
      };
      nginx.virtualHosts."photoprism.alinkbetweennets.de" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = { proxyPass = "http://127.0.0.1:2342/"; };
      };
    };
  };
}
