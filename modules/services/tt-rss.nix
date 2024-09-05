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
      # tt-rss = {
      #   enable = true;
      #   pubSubHubbub.enable = true;
      #   selfUrlPath = "https://rss.${config.link.domain}";
      #   virtualHost = null;
      #   logDestination = "syslog";
      # };
      # services.nginx = {
      #   enable = lib.mkForce true;
      #   virtualHosts = {
      #     "rss.${config.link.domain} " = {
      #       listen = [{
      #         port = cfg.port;
      #         addr = "0.0.0.0";
      #         ssl = false;
      #       }];
      #       root = "/var/lib/tt-rss/www";

      #       locations."/" = { index = "index.php"; };

      #       locations."^~ /feed-icons" = { root = "/var/lib/tt-rss/"; };

      #       locations."~ \\.php$" = {
      #         extraConfig = ''
      #           fastcgi_split_path_info ^(.+\.php)(/.+)$;
      #           fastcgi_pass unix:${
      #             config.services.phpfpm.pools."tt-rss".socket
      #           };
      #           fastcgi_index index.php;
      #         '';
      #       };
      #     };
      #   };
      # };
      # services.phpfpm.pools."tt-rss" = {
      #   #  inherit (cfg) user;
      #   inherit phpPackage;
      #   settings = mapAttrs (name: mkDefault) {
      #     "listen.owner" = "nginx";
      #     "listen.group" = "nginx";
      #     "listen.mode" = "0600";
      #     "pm" = "dynamic";
      #     "pm.max_children" = 75;
      #     "pm.start_servers" = 10;
      #     "pm.min_spare_servers" = 5;
      #     "pm.max_spare_servers" = 20;
      #     "pm.max_requests" = 500;
      #     "catch_workers_output" = 1;
      #   };
      # };
    };
  };
}
