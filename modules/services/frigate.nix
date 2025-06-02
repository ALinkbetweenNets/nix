{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.services.frigate;
in {
  options.link.services.frigate = {
    enable = mkEnableOption "activate frigate";
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
      default = 1880;
      description = "port to run the application on";
    };
  };
  config = mkIf cfg.enable {
    services.frigate = {
      enable = true;
      hostname = config.networking.hostName;
      settings = {
        cameras = {
          "pizero1" = {
            detect={
              width = 640;
              height = 480;
              fps = 5;
            };
            ffmpeg.inputs = [{
              path = "/dev/video0";
              roles = [ "detect" ];
            }];
          };
        };
      };
    };
    networking.firewall.allowedTCPPorts = mkIf cfg.expose-port [ cfg.port ];
  };
}
