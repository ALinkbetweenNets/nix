{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.services.outline;
in {
  options.link.services.outline = {
    enable = mkEnableOption
      "activate outline, a wiki with markdown support, requires nginx, gitea and minio";
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
      default = 3123;
      description = "port to run the application on";
    };
    oidClientId = mkOption {
      type = types.str;
      description = "oidcAuthentication clientID from gitea";
    };
  };
  config = mkIf cfg.enable {
    sops.secrets."outline/minio" = {
      owner = "outline";
      group = "outline";
    };
    sops.secrets."outline/oidc" = {
      owner = "outline";
      group = "outline";
    };
    services = {
      outline = {
        enable = true;
        port = cfg.port;
        publicUrl = "https://outline.${config.link.domain}";
        storage = {
          accessKey = "De2GYKESwHfPfht2U8vK";
          secretKeyFile = config.sops.secrets."outline/minio".path;
          uploadBucketUrl = "https://s3.${config.link.domain}";
          uploadBucketName = "outline";
          region = "eu-central-1";
        };
        oidcAuthentication = {
          # Parts taken from
          # http://dex.localhost/.well-known/openid-configuration
          authUrl = "https://gitlab.${config.link.domain}/oauth/authorize";
          tokenUrl = "https://gitlab.${config.link.domain}/oauth/token";
          userinfoUrl = "https://gitlab.${config.link.domain}/oauth/userinfo";
          usernameClaim = "username";
          clientId = cfg.oidClientId;
          clientSecretFile = config.sops.secrets."outline/oidc".path;
          scopes = [ "openid" "email" ];
          displayName = "GitLab";
        };
      };
      nginx.virtualHosts."outline.${config.link.domain}" = mkIf cfg.nginx {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString cfg.port}";
          proxyWebsockets = true;
        };
        extraConfig = mkIf (!cfg.nginx-expose) ''
          allow ${config.link.service-ip}/24;
            allow 127.0.0.1;
            deny all; # deny all remaining ips
        '';
      };
    };
    networking.firewall.interfaces."${config.link.service-interface}".allowedTCPPorts =
      mkIf cfg.expose-port [ cfg.port ];
  };
}
