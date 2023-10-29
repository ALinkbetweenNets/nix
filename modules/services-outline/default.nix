{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.outline;
in {
  options.link.outline.enable = mkEnableOption "activate outline";
  config = mkIf cfg.enable {
    services = {
      outline = {
        enable = true;
        port = 3123;
        publicUrl = "http://127.0.0.1:3123";
        storage = {
          accessKey = "outline";
          secretKeyFile = "${config.link.secrets}minio-outline";
          uploadBucketUrl = "https://minio.s3.${config.link.domain}";
          uploadBucketName = "outline";
          region = "eu-central-1";
        };
        oidcAuthentication = {
          # Parts taken from
          # http://dex.localhost/.well-known/openid-configuration
          authUrl = "http://dex.localhost/auth";
          tokenUrl = "http://dex.localhost/token";
          userinfoUrl = "http://dex.localhost/userinfo";
          clientId = "outline";
          clientSecretFile = (builtins.elemAt config.services.dex.settings.staticClients 0).secretFile;
          scopes = [ "openid" "email" "profile" ];
          usernameClaim = "preferred_username";
          displayName = "Dex";
        };
      };

      dex = {
        enable = true;
        settings = {
          issuer = "https://dex.${config.link.domain}";
          storage = {
            type = "sqlite3";
            config.file = "${config.link.storage}dex/db.sqlite3";
          };
          web.http = "127.0.0.1:5556";
          enablePasswordDB = true;
          staticClients = [
            {
              id = "outline";
              name = "Outline Client";
              redirectURIs = [ "http://localhost:3000/auth/oidc.callback" ];
              secretFile = "${config.link.secrets}outline-client-secret";
            }
          ];
        };
      };

      nginx.virtualHosts."outline.${config.link.domain}" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          proxyPass = "${config.services.outline.publicUrl}";
        };
      };
      nginx.virtualHosts."dex.${config.link.domain}" = {
        locations."/" = {
          proxyPass = "http://${config.services.dex.settings.web.http}";
        };
      };
    };
    systemd.services.dex = {
      serviceConfig.StateDirectory = "dex";
    };
  };
}
