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
          PHOTOPRISM_ADMIN_PASSWORD = "GzJ&<8C@RD]Cv]Y3DF5VgTAfY543q}M:{S7h?BoIhu[_j#P0B5"; # only initial
          PHOTOPRISM_DEFAULT_LOCALE = "de";
          PHOTOPRISM_SITE_URL = "https://pics.${config.link.domain}";
          PHOTOPRISM_SITE_TITLE = "Pics";
          # PHOTOPRISM_DATABASE_DRIVER = "mysql";
          # PHOTOPRISM_DATABASE_NAME = "photoprism";
          # PHOTOPRISM_DATABASE_SERVER = "/run/mysqld/mysqld.sock";
          # PHOTOPRISM_DATABASE_USER = "photoprism";
        };
        port = 2342;
        passwordFile = "${config.link.secrets}/photoprism";
      };
      # mysql = {
      #   enable = true;
      #   dataDir = "${config.link.storage}/mysql";
      #   package = pkgs.mariadb;
      #   ensureDatabases = [ "photoprism" ];
      #   ensureUsers = [{
      #     name = "photoprism";
      #     ensurePermissions = {
      #       "photoprism.*" = "ALL PRIVILEGES";
      #     };
      #   }];
      # };
      nginx.virtualHosts."pics.${config.link.domain}" = {
        enableACME = true;
        forceSSL = true;
        http2 = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString config.services.photoprism.port}/";
          proxyWebsockets = true;
          extraConfig = ''
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header Host $host;
            proxy_buffering off;
            proxy_http_version 1.1;
          '';
        };
      };
    };
  };
}
