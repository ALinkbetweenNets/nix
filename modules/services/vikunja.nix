{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.services.vikunja;
in {
  options.link.services.vikunja = {
    enable = mkEnableOption "activate vikunja";
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
      default = 3456;
      description = "port to run the application on";
    };
  };
  config = mkIf cfg.enable {
    services = {
      vikunja = {
        enable = true;
        database.path = "${config.link.storage}/vikunja/vikunja.db";
        frontendHostname = "vikunja.${config.link.domain}";
        frontendScheme = "https";
        settings = { service.enableregistration = false; };
      };
      nginx.virtualHosts."vikunja.${config.link.domain}" = mkIf cfg.nginx {
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
