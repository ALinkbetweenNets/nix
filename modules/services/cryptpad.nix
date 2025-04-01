{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.services.cryptpad;
in {
  options.link.services.cryptpad = {
    enable = mkEnableOption "activate cryptpad";
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
      default = 5000;
      description = "port to run the application on";
    };
  };
  config = mkIf cfg.enable {
    services = {
      cryptpad = {
        enable = true;
        settings = {
          httpPort = cfg.port;
          websocketPort = cfg.port + 1;
          httpAddress = if cfg.expose-port then "0.0.0.0" else "127.0.0.1";
          httpSafeOrigin = "https://cryptui.${config.link.domain}";
          httpUnsafeOrigin = "https://crypt.${config.link.domain}";
          adminKeys = [
            "[alinkbetweennets@crypt.alinkbetweennets.de/3ZgaliPddqU4QpSkK6I1xwWV8dgQirqqH0VqZJIEXog=]"
          ];
        };
      };
      nginx.virtualHosts."cryptpad.${config.link.domain}" = mkIf cfg.nginx {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString cfg.port}";
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
