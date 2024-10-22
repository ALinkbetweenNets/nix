{ config, pkgs, lib, ... }:
with lib;
let cfg = config.link.services.jellyfin;
in {
  options.link.services.jellyfin = {
    enable = mkEnableOption "activate jellyfin";
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
      default = 8096;
      description = "port to run the application on";
    };
  };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ jellyfin-ffmpeg ];
    services = {
      jellyfin = {
        # package = pkgs.cudapkgs.jellyfin;
        enable = true;
        dataDir = "${config.link.storage}/jellyfin";
      };
      nginx.virtualHosts."jellyfin.${config.link.domain}" = mkIf cfg.nginx {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString cfg.port}/";
        };
      };
    };
    networking.firewall.interfaces."${config.link.service-interface}".allowedTCPPorts =
      mkIf cfg.expose-port [ cfg.port ];
  };
}
