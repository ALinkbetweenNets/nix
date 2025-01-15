{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.services.minio;
in {
  options.link.services.minio = {
    enable = mkEnableOption "activate minio";
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
  };
  config = mkIf cfg.enable {
    sops.secrets."minio" = {
      owner = "minio";
      group = "minio";
    };
    services = {
      minio = {
        enable = true;
        listenAddress =
          if cfg.expose-port then "0.0.0.0:9001" else "127.0.0.1:9001";
        consoleAddress =
          if cfg.expose-port then "0.0.0.0:9002" else "127.0.0.1:9002";
        region = "eu-central-1";
        rootCredentialsFile = config.sops.secrets."minio".path;
        dataDir = [ "${config.link.storage}/minio/data" ];
      };
      nginx.virtualHosts."minio.${config.link.domain}" = mkIf cfg.nginx {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:9002";
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
      nginx.virtualHosts."s3.${config.link.domain}" = mkIf cfg.nginx {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:9001";
          extraConfig = ''
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            # proxy_set_header Host $host;
            proxy_connect_timeout 300;
            # Default is HTTP/1, keepalive is only enabled in HTTP/1.1
            # proxy_http_version 1.1;
            proxy_set_header Connection "";
            chunked_transfer_encoding off;
          '';
          proxyWebsockets = true;
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
        MINIO_BROWSER_REDIRECT_URL = "https://minio.${config.link.domain}";
      };
    };
    networking.firewall = {
      checkReversePath = lib.mkDefault "loose";
      # nameservers = [ "100.100.100.100" "1.1.1.1" ];
    };
    networking.firewall.interfaces."${config.link.service-interface}".allowedTCPPorts =
      mkIf cfg.expose-port [ 9001 9002 ];
  };
}
