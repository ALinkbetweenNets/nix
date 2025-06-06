{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.services.radicale;
in {
  options.link.services.radicale = {
    enable = mkEnableOption "activate radicale";
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
      default = 5232;
      description = "port to run the application on";
    };
  };
  config = mkIf cfg.enable {
    sops.secrets."radicale" = {
      owner = "radicale";
      group = "radicale";
    };
    services = {
      radicale = {
        enable = true;
        settings = {
          server = {
            hosts = if cfg.expose-port then [
              "0.0.0.0:5232"
              "[::]:5232"
            ] else [
              "127.0.0.1:5232"
              "[::1]:5232"
            ];
            max_connections = 5;
            timeout=30;
          };
          auth = {
            delay=604800; # 7 days
            type = "htpasswd";
            htpasswd_filename = config.sops.secrets."radicale".path;
            htpasswd_encryption = "bcrypt";
          };
          # storage = { filesystem_folder = "/var/lib/radicale/collections"; };
        };
        # rights = {
        #   root = {
        #     user = ".+";
        #     collection = "";
        #     permissions = "R";
        #   };
        #   principal = {
        #     user = ".+";
        #     collection = "{user}";
        #     permissions = "RW";
        #   };
        #   calendars = {
        #     user = ".+";
        #     collection = "{user}/[^/]+";
        #     permissions = "rw";
        #   };
        # };
      };
    };
    networking.firewall.interfaces."${config.link.service-interface}".allowedTCPPorts =
      mkIf cfg.expose-port [ cfg.port ];
  };
}
