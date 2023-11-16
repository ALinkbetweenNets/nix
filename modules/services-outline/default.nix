{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.services.outline;
in {
  options.link.services.outline = {
    enable = mkEnableOption "activate outline, a wiki with markdown support, requires nginx, gitea and minio";
    expose = mkOption {
      type = types.bool;
      default = config.link.expose;
      description = "expose outline to the internet with NGINX and ACME";
    };
    oidClientId = mkOption {
      type = types.str;
      description = "oidcAuthentication clientID from gitea";
    };
  };
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
          authUrl = "https://gitea.${config.link.domain}/login/oauth/authorize";
          tokenUrl = "https://gitea.${config.link.domain}/login/oauth/access_token";
          userinfoUrl = "https://gitea.${config.link.domain}/login/oauth/userinfo";
          clientId = cfg.oidClientId;
          clientSecretFile = "${config.link.secrets}/outline";
          scopes = [ "openid" "profile" "email" "groups" ];
          displayName = "Gitea";
        };
      };
      nginx.virtualHosts."outline.${config.link.domain}" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString config.services.outline.port}";
        };
        extraConfig = mkIf (!cfg.expose) ''
          allow ${config.link.service-ip}/24;
            allow 127.0.0.1;
            deny all; # deny all remaining ips
        '';
      };
    };
  };
}
