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
          secretKeyFile = "/home/l/.keys/minio-outline";
          uploadBucketUrl = "https://minio.s3.alinkbetweennets.de";
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
          clientSecretFile = ".keys/";
          scopes = [ "openid" "email" "profile" ];
          usernameClaim = "l";
          displayName = "Gitea";
        };
      };
      nginx.virtualHosts."outline.alinkbetweennets.de" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = { proxyPass = "http://127.0.0.1:3123"; };
      };
      minio = {
        enable = true;
        listenAddress = "127.0.0.1:9000";
        consoleAddress = "127.0.0.1:9001";
        region = "eu-central-1";

        rootCredentialsFile = "/home/l/.keys/minio-outline";

        dataDir = [ "/rz/srv/minio/data" ];
        # configDir = "/mnt/data/minio/config";
      };
    };
    systemd.services.minio = {
      environment = {
        MINIO_SERVER_URL = "https://s3.alinkbetweennets.de";
        MINIO_BROWSER_REDIRECT_URL = "https://minio.s3.alinkbetweennets.de";
      };
    };
  };
}
