{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.services.restic-server;
in {
  options.link.services.restic-server = {
    enable = mkEnableOption "activate restic-server";
    expose = mkOption {
      type = types.bool;
      default = config.link.nginx-expose;
      description = "expose restic-server to the internet with NGINX and ACME";
    };
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
    port = mkOption {
      type = types.int;
      default = 2500;
      description = "port to run the application on";
    };
  };
  config = mkIf cfg.enable {
    services = {
      restic.server = {
        enable = true;
        dataDir = "${config.link.storage}/restic";
        prometheus = true;
        privateRepos = true;
        listenAddress =
          if cfg.expose-port then
            "0.0.0.0:${toString cfg.port}"
          else
            "127.0.0.1:${toString cfg.port}";
        appendOnly = false;
      };
      nginx.virtualHosts."restic.${config.link.domain}" = mkIf cfg.nginx {
        enableACME = true;
        forceSSL = true;
        locations."/" = { proxyPass = "http://127.0.0.1:2500"; };
        extraConfig = mkIf (!cfg.expose) ''
          allow ${config.link.service-ip}/24;
          allow 127.0.0.1;
          deny all; # deny all remaining ips
        '';
      };
    };
  };
}
