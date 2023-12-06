{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.services.restic-server;
in {
  options.link.services.restic-server = {
    enable = mkEnableOption "activate restic-server";
    expose = mkOption {
      type = types.bool;
      default = config.link.expose;
      description = "expose restic-server to the internet with NGINX and ACME";
    };
  };
  config = mkIf cfg.enable {
    services = {
      restic.server = {
        enable = true;
        dataDir = "${config.link.storage}/restic";
        prometheus = true;
        privateRepos = true;
        listenAddress = "127.0.0.1:2500";
        appendOnly = true;
      };
      nginx.virtualHosts."restic.${config.link.domain}" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:2500";
        };
        extraConfig = mkIf (!cfg.expose) ''
          allow ${config.link.service-ip}/24;
          allow 127.0.0.1;
          deny all; # deny all remaining ips
        '';
      };
    };
  };
}
