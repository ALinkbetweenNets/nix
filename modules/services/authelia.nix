{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.authelia;
in {
  options.link.authelia.enable = mkEnableOption "activate authelia";
  config = mkIf cfg.enable {
    #     systemd.services.authelia-main.preStart = ''
    #   [ -f /var/lib/authelia-main/jwt-secret ] || {
    #     "${pkgs.openssl}/bin/openssl" rand -base64 32 > /var/lib/authelia-main/jwt-secret
    #   }
    #   [ -f /var/lib/authelia-main/storage-encryption-file ] || {
    #     "${pkgs.openssl}/bin/openssl" rand -base64 32 > /var/lib/authelia-main/storage-encryption-file
    #   }
    #   [ -f /var/lib/authelia-main/session-secret-file ] || {
    #     "${pkgs.openssl}/bin/openssl" rand -base64 32 > /var/lib/authelia-main/session-secret-file
    #   }
    # '';
    # services = {
    #   authelia.instances.main = {
    #     enable = true;
    #     secrets = {
    #       jwtSecretFile = "/var/lib/authelia-main/jwt-secret";
    #       storageEncryptionKeyFile = "/var/lib/authelia-main/storage-encryption-file";
    #       sessionSecretFile = "/var/lib/authelia-main/session-secret-file";
    #     };
    sops.secrets = {
      "authelia/main/jwtSecret" = {
        owner = "authelia-main";
        group = "authelia-main";
      };
      "authelia/main/storageEncryptionKey" = {
        owner = "authelia-main";
        group = "authelia-main";
      };
      "authelia/main/sessionSecret" = {
        owner = "authelia-main";
        group = "authelia-main";
      };
    };
    services = {
      authelia.instances.main = {
        enable = true;
        secrets = {
          jwtSecretFile = config.sops.secrets."authelia/main/jwtSecret".path;
          storageEncryptionKeyFile =
            config.sops.secrets."authelia/main/storageEncryptionKey".path;
          sessionSecretFile =
            config.sops.secrets."authelia/main/sessionSecret".path;
        };
        settings = {
          theme = "dark";
          default_redirection_url = "https://auth.${config.link.domain}";
          server = {
            host = "127.0.0.1";
            port = 9091;
          };
          log = {
            level = "debug";
            format = "text";
          };
          authentication_backend = {
            file = { path = "/var/lib/authelia-main/users_database.yml"; };
          };
          access_control = {
            default_policy = "deny";
            rules = [
              {
                domain = [ "auth.${config.link.domain}" ];
                policy = "bypass";
              }
              {
                domain = [ "*.${config.link.domain}" ];
                policy = "one_factor";
              }
            ];
          };
          session = {
            name = "authelia_session";
            expiration = "12h";
            inactivity = "45m";
            remember_me_duration = "1M";
            domain = "${config.link.domain}";
            redis.host = "/run/redis-authelia-main/redis.sock";
          };
          regulation = {
            max_retries = 3;
            find_time = "5m";
            ban_time = "15m";
          };
          storage = {
            local = { path = "/var/lib/authelia-main/db.sqlite3"; };
          };
          notifier = {
            disable_startup_check = false;
            filesystem = {
              filename = "/var/lib/authelia-main/notification.txt";
            };
          };
        };
      };
      redis.servers.authelia-main = {
        enable = true;
        user = "authelia-main";
        port = 0;
        unixSocket = "/run/redis-authelia-main/redis.sock";
        unixSocketPerm = 600;
      };
      nginx.virtualHosts = {
        "auth.${config.link.domain}" = {
          enableACME = true;
          forceSSL = true;
          locations = {
            "/" = {
              proxyPass = "http://localhost:${
                  toString
                  config.services.authelia.instances.main.settings.server.port
                }/";
              extraConfig = ''
                proxy_set_header X-Forwarded-Host $http_host;
                proxy_set_header X-Real-IP $remote_addr;
                proxy_set_header X-Forwarded-Proto $scheme;
              '';
              proxyWebsockets = true;
            };
          };
        };
      };
    };
  };
}
