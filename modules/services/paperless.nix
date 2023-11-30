{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.paperless;
in {
  options.link.paperless.enable = mkEnableOption "activate paperless";
  config = mkIf cfg.enable {
    services = {
      paperless = {
        enable = true;
        passwordFile = "${config.link.secrets}/paperless";
        dataDir = "${config.link.storage}/paperless";
        # address = "paperless.alinkbetweennets.de";
        extraConfig = {
          PAPERLESS_ADMIN_USER = "l";
          PAPERLESS_OCR_LANGUAGE = "deu+eng";
          PAPERLESS_URL = "https://paperless.${config.link.domain}";
          # PAPERLESS_DBHOST = "/run/postgresql";
          # PAPERLESS_CONSUMER_IGNORE_PATTERN = builtins.toJSON [ ".DS_STORE/*" "desktop.ini" ];
          PAPERLESS_OCR_USER_ARGS = builtins.toJSON {
            optimize = 1;
            pdfa_image_compression = "lossless";
          };
        };
      };
      nginx.virtualHosts."paperless.${config.link.domain}" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = { proxyPass = "http://127.0.0.1:28981/"; };
        sslCertificate = "${config.link.secrets}/cert.crt";
        sslCertificateKey = "${config.link.secrets}/key.key";
      };
    };
  };
}
