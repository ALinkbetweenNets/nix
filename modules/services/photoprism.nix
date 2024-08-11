{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.services.photoprism;
in {
  options.link.services.photoprism = {
    enable = mkEnableOption "activate photoprism";
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
      default = 2342;
      description = "port to run the application on";
    };
  };
  config = mkIf cfg.enable {
    services = {
      photoprism = {
        enable = true;
        originalsPath = "${config.link.storage}/photoprism/data";
        storagePath = "${config.link.storage}/photoprism/storage";
        settings = {
          PHOTOPRISM_ADMIN_USER = "l";
          PHOTOPRISM_ADMIN_PASSWORD =
            "GzJ&<8C@RD]Cv]Y3DF5VgTAfY543q}M:{S7h?BoIhu[_j#P0B5"; # initial
          PHOTOPRISM_DEFAULT_LOCALE = "de";
          PHOTOPRISM_SITE_URL = "https://photoprism.${config.link.domain}";
          PHOTOPRISM_SITE_TITLE = "Pics";
          # PHOTOPRISM_DATABASE_DRIVER = "mysql";
          # PHOTOPRISM_DATABASE_NAME = "photoprism";
          # PHOTOPRISM_DATABASE_SERVER = "/run/mysqld/mysqld.sock";
          # PHOTOPRISM_DATABASE_USER = "photoprism";
        };
        port = cfg.port;
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
      nginx.virtualHosts."photoprism.${config.link.domain}" = mkIf cfg.nginx {
        enableACME = true;
        forceSSL = true;
        http2 = true;
        locations."/" = {
          proxyPass =
            "http://127.0.0.1:${toString config.services.photoprism.port}/";
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
    networking.firewall.interfaces."${config.link.service-interface}".allowedTCPPorts =
      mkIf cfg.expose-port [ cfg.port ];
  };
}
