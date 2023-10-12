{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.nextcloud;
in {
  options.link.nextcloud.enable = mkEnableOption "activate nextcloud";
  config = mkIf cfg.enable {
    services = {
      paperless = {
        enable = true;
        passwordFile = "/pwd/paperless";
        dataDir = "/rz/srq/paperless";
        # address = "paperless.alinkbetweennets.de";
        extraConfig = {
          PAPERLESS_ADMIN_USER = "l";
          PAPERLESS_OCR_LANGUAGE = "deu+eng";
          # PAPERLESS_DBHOST = "/run/postgresql";
          # PAPERLESS_CONSUMER_IGNORE_PATTERN = builtins.toJSON [ ".DS_STORE/*" "desktop.ini" ];
          PAPERLESS_OCR_USER_ARGS = builtins.toJSON {
            optimize = 1;
            pdfa_image_compression = "lossless";
          };
        };
      };
      nginx.virtualHosts."paperless.alinkbetweennets.de" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = { proxyPass = "http://127.0.0.1:28981/"; };
      };
    };
  };
}
