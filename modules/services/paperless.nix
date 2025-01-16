{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.services.paperless;
in {
  options.link.services.paperless = {
    enable = mkEnableOption "activate paperless";
    expose-port = mkOption {
      type = types.bool;
      default = config.link.service-ports-expose;
      description = "directly expose the port of the application";
    };
    nginx = mkOption {
      type = types.bool;
      default = config.link.nginx.enable;
      description =
        "expose the application to the internet with NGINX and ACME";
    };
    nginx-expose = mkOption {
      type = types.bool;
      default = config.link.nginx-expose;
      description = "expose the application to the internet";
    };
    port = mkOption {
      type = types.int;
      default = 28981;
      description = "port to run the application on";
    };
  };
  config = mkIf cfg.enable {
    sops.secrets."paperless" = { };
    services = {
      paperless = {
        enable = true;
        address = if cfg.expose-port then "0.0.0.0" else "127.0.0.1";
        passwordFile = config.sops.secrets."paperless".path;
        dataDir = "${config.link.storage}/paperless";
        port = cfg.port;
        settings = {
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
      #auth2_proxy.nginx.virtualHosts = [ "paperless.${config.link.domain}" ];
      nginx.virtualHosts."paperless.${config.link.domain}" =
        mkIf cfg.nginx-expose {
          enableACME = true;
          forceSSL = true;
          sslCertificate = "${config.link.secrets}/cert.crt";
          sslCertificateKey = "${config.link.secrets}/key.key";
          locations."/" = {
            proxyPass = "http://127.0.0.1:${toString cfg.port}/";
          };
          extraConfig = mkIf (!cfg.nginx-expose) ''
            allow ${config.link.service-ip}/24;
            allow 127.0.0.1;
            deny all; # deny all remaining ips
          '';
        };
    };
    networking.firewall.allowedTCPPorts = mkIf cfg.expose-port [ cfg.port ];
  };
}
