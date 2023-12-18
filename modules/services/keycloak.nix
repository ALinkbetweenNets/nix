{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.keycloak;
in {
  options.link.keycloak.enable = mkEnableOption "activate keycloak";
  config = mkIf cfg.enable {
    services = {
      keycloak = {
        enable = true;
        initialAdminPassword = "enreehoWrerashsubNocjacPhilar8";
        database = {
          username = "keycloak";
          passwordFile = "${config.link.secrets}/keycloak";
          createLocally = true;
        };
        settings = {
          hostname = "auth.${config.link.domain}";
          hostname-strict-backchannel = true;
          http-host = "127.0.0.1";
          http-port = 31123;
          http-relative-path = "/";
          proxy = "edge";
        };
      };
      nginx.virtualHosts = {
        "keycloak.${config.link.domain}" = {
          enableACME = true;
          forceSSL = true;
          locations = {
            "/" = {
              proxyPass = "http://localhost:${toString config.services.keycloak.settings.http-port}/";
              extraConfig = ''
                proxy_set_header X-Forwarded-Host $http_host;
                proxy_set_header X-Real-IP $remote_addr;
                proxy_set_header X-Forwarded-Proto $scheme;
              '';
            };
          };
        };
      };
    };
  };
}
