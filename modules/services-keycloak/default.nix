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
          passwordFile = "/pwd/keycloak";
        };
        settings = {
          hostname = "auth.alinkbetweennets.de";
          http-relative-path = "";
          hostname-strict-backchannel = true;
          http-port = 31123;
          http-host = "127.0.0.1";
          proxy = "edge";
        };
      };

      nginx.virtualHosts = {
        "auth.alinkbetweennets.de" = {
          enableACME = true;
          forceSSL = true;
          locations = {
            "/" = {
              proxyPass = "http://127.0.0.1:31123";
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
