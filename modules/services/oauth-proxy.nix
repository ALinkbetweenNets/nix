{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.services.oauth-proxy;
in {
  options.link.services.oauth-proxy = {
    enable = mkEnableOption "activate matrix";
    expose = mkOption {
      type = types.bool;
      default = config.link.expose;
      description = "expose matrix to the internet with NGINX and ACME";
    };
    nginx = mkOption {
      type = types.bool;
      default = config.link.nginx.enable;
      description = "Use service with NGINX";
    };
  };
  config = mkIf cfg.enable {
    services = {
      oauth2_proxy = {
        enable = true;
        provider = "keycloak";
        keyFile = config.sops.secrets."oauth-proxy/key".path;
        validateURL = "https://keycloak.alinkbetweennets.de/";
        redeemURL = "https://keycloak.alinkbetweennets.de/oauth/token";
        loginURL = "https://keycloak.alinkbetweennets.de/oauth/authorize";
        reverseProxy = true;
        setXauthrequest = true;
        passAccessToken = true;
      };
      nginx.virtualHosts."oauth-proxy.${config.link.domain}" = mkIf cfg.nginx {
        enableACME = true;
        forceSSL = true;
        extraConfig = mkIf (!cfg.expose) ''
          allow ${config.link.service-ip}/24;
          allow 127.0.0.1;
          deny all; # deny all remaining ips
        '';
        #locations."/" = {
        #  proxyPass = "http://127.0.0.1:80/";
        # extraConfig = ''
        #   proxy_set_header Front-End-Https on;
        #   proxy_set_header Strict-Transport-Security "max-age=2592000; includeSubdomains";
        #   proxy_set_header X-Real-IP $remote_addr;
        #   proxy_set_header Host $host;
        #   proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        #   proxy_set_header X-Forwarded-Proto $scheme;
        # '';
        #};
      };
    };
  };
}
