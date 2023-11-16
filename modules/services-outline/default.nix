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
        publicUrl = "https://outline.${config.link.domain}";
        storage = {
          accessKey = "outline";
          secretKeyFile = "${config.link.secrets}/minio-outline";
          uploadBucketUrl = "https://minio.s3.${config.link.domain}";
          uploadBucketName = "outline";
          region = "eu-central-1";
        };
        oidcAuthentication = {
          # Parts taken from
          # http://dex.localhost/.well-known/openid-configuration
          authUrl = "https://gitea.alinkbetweennets.de/login/oauth/authorize";
          tokenUrl = "https://gitea.alinkbetweennets.de/login/oauth/access_token";
          userinfoUrl = "https://gitea.alinkbetweennets.de/login/oauth/userinfo";
          clientId = "outline";
          clientSecretFile = "${config.link.secrets}/outline";
          scopes = [ "openid" "email" "profile" ];
          usernameClaim = "l";
          displayName = "Gitea";
        };
      };
      nginx.virtualHosts."outline.${config.link.domain}" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          proxyPass = "127.0.0.1:${config.services.outline.port}";
        };
      };
    };
  };
}
