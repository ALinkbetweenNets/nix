{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.services.tt-rss;
in {
  options.link.services.tt-rss = {
    enable = mkEnableOption "activate tt-rss";
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
      default = 6719;
      description = "port to run the application on";
    };
  };
  config = mkIf cfg.enable {
    services = {
      tt-rss = {
        enable = true;
        pubSubHubbub.enable = true;
        selfUrlPath = "https://rss.${config.link.domain}";
        virtualHost = null;
        logDestination = "syslog";
      };
      services.nginx = {
        enable = lib.mkForce true;
        virtualHosts = {
          "rss.${config.link.domain} " = {
            listen = [{
              port = cfg.port;
              addr = "0.0.0.0";
              ssl = false;
            }];
            root = "${cfg.root}/www";

            locations."/" = { index = "index.php"; };

            locations."^~ /feed-icons" = { root = "${cfg.root}"; };

            locations."~ \\.php$" = {
              extraConfig = ''
                fastcgi_split_path_info ^(.+\.php)(/.+)$;
                fastcgi_pass unix:${
                  config.services.phpfpm.pools.${cfg.pool}.socket
                };
                fastcgi_index index.php;
              '';
            };
          };
        };

      };
    };
  };
}
