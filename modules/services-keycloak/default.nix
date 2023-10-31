{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.keycloak;
in {
  options.link.keycloak.enable = mkEnableOption "activate keycloak";
  config = mkIf cfg.enable {
    services = {
      keycloak = {
        enable = true;
        database = {
          username = "keycloak";
          passwordFile = "${config.link.secrets}/keycloak";
          createLocally = true;
        };
        settings = {
          hostname = "${config.link.domain}";
          # hostname-strict-backchannel = true;
          http-enabled = true;
          http-host = "127.0.0.1";
          http-port = 31123;
          http-relative-path = "/cloak";
          proxy = "passthrough";
        };
      };
      nginx.virtualHosts = {
        "${config.link.domain}" = {
          enableACME = true;
          forceSSL = true;
          locations = {
            "/cloak/" = {
              proxyPass = "http://localhost:${toString config.services.keycloak.settings.http-port}/cloak/";
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
