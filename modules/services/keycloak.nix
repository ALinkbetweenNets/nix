{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.services.keycloak;
in {
  options.link.services.keycloak = {
    enable = mkEnableOption "activate keycloak";
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
      default = 31123;
      description = "port to run the application on";
    };
  };
  config = mkIf cfg.enable {
    sops.secrets."keycloak" = {
      owner = "postgres";
      group = "postgres";
    };
    services = {
      keycloak = {
        enable = true;
        initialAdminPassword = "enreehoWrerashsubNocjacPhilar8";
        database = {
          username = "keycloak";
          passwordFile = config.sops.secrets."keycloak".path;
          createLocally = true;
        };
        settings = {
          hostname = "keycloak.${config.link.domain}";
          http-host = if cfg.expose-port then "0.0.0.0" else "127.0.0.1";
          http-port = cfg.port;
          http-relative-path = "/";
          proxy-headers = "forwarded";
        };
      };
      nginx.virtualHosts."keycloak.${config.link.domain}" = mkIf cfg.nginx {
        enableACME = true;
        forceSSL = true;
        locations = {
          "/" = {
            proxyPass = "http://localhost:${toString cfg.port}";
            extraConfig = ''
              proxy_set_header X-Forwarded-Host $http_host;
              proxy_set_header X-Real-IP $remote_addr;
              proxy_set_header X-Forwarded-Proto $scheme;
            '';
          };
        };
        # extraConfig = toString (
        #   optional config.link.nginx.geoIP ''
        #     if ($allowed_country = no) {
        #         return 444;
        #     }
        #   ''
        # );
      };

    };
  };
}
