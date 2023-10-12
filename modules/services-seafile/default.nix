{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.nextcloud;
in {
  options.link.nextcloud.enable = mkEnableOption "activate nextcloud";
  config = mkIf cfg.enable {
    services = {
      seafile = {
        enable = true;
        adminEmail = "alinkbetweennets@protonmail.com";
        seafileSettings.fileserver.host = "0.0.0.0";
        seafileSettings.fileserver.port = 8082;
        ccnetSettings.General.SERVICE_URL = "http://localhost:8000";
        initialAdminPassword = "re9zy2aYMJjZXCvLgleBKUCATis1Qlfv";
      };
      nginx.virtualHosts."seafile.alinkbetweennets.de" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = { proxyPass = "http://127.0.0.1:8000/"; };
      };
    };
  };
}
