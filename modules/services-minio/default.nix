{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.services.minio;
in {
  options.link.services.minio.enable = mkEnableOption "activate minio";
  config = mkIf cfg.enable {
    services = {
      minio = {
        enable = true;
        listenAddress = "127.0.0.1:9000";
        consoleAddress = "127.0.0.1:9001";
        region = "eu-central-1";
        rootCredentialsFile = "${config.link.secrets}/minio";
        dataDir = [ "${config.link.storage}/minio/data" ];
      };
      nginx.virtualHosts."minio.s3.${config.link.domain}" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:9001";
          proxyWebsockets = true;
          extraConfig = ''
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            # proxy_set_header Host $host;
            proxy_connect_timeout 300;
            # Default is HTTP/1, keepalive is only enabled in HTTP/1.1
            #proxy_http_version 1.1;
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
      nginx.virtualHosts."s3.${config.link.domain}" = {
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
    };
    systemd.services.minio = {
      environment = {
        MINIO_SERVER_URL = "https://s3.${config.link.domain}";
        MINIO_BROWSER_REDIRECT_URL = "https://minio.s3.${config.link.domain}";
      };
    };
    networking = {
      firewall.checkReversePath = "loose";
      # nameservers = [ "100.100.100.100" "1.1.1.1" ];
    };
  };
}
