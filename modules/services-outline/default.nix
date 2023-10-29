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
      nginx.virtualHosts."s3.alinkbetweennets.de" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:9000";
          extraConfig = ''
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            # proxy_set_header Host $host;
            proxy_connect_timeout 300;
            # Default is HTTP/1, keepalive is only enabled in HTTP/1.1
            proxy_http_version 1.1;
            proxy_set_header Connection "";
            chunked_transfer_encoding off;
          '';
        };
        extraConfig = ''
          # To allow special characters in headers
          ignore_invalid_headers off;
          # Allow any size file to be uploaded.
          # Set to a value such as 1000m; to restrict file size to a specific value
          client_max_body_size 0;
          # To disable buffering
          proxy_buffering off;
        '';
      };
      nginx.virtualHosts."minio.s3.alinkbetweennets.de" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:9000";
          extraConfig = ''
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            # proxy_set_header Host $host;
            proxy_connect_timeout 300;
            # Default is HTTP/1, keepalive is only enabled in HTTP/1.1
            proxy_http_version 1.1;
            proxy_set_header Connection "";
            chunked_transfer_encoding off;
          '';
        };
        extraConfig = ''
          # To allow special characters in headers
          ignore_invalid_headers off;
          # Allow any size file to be uploaded.
          # Set to a value such as 1000m; to restrict file size to a specific value
          client_max_body_size 0;
          # To disable buffering
          proxy_buffering off;
        '';
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
    networking = {
      firewall.checkReversePath = "loose";
      nameservers = [ "100.100.100.100" "1.1.1.1" ];
      firewall = {
        # minio load ballancer should have ports 80 & 443 open
        allowedTCPPorts = [ 80 443 ];
      };
    };
  };
}
