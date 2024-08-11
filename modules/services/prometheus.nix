{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.services.prometheus;
in {
  options.link.services.prometheus = {
    enable = mkEnableOption "activate prometheus";
    expose-port = mkOption {
      type = types.bool;
      default = config.link.service-ports-expose;
      description = "directly expose the port of the application";
    };
    port = mkOption {
      type = types.int;
      default = 9005;
      description = "port to run the application on";
    };
  };
  config = mkIf cfg.enable {
    services = {
      prometheus = {
        enable = true;
        port = cfg.port;
        exporters = {
          zfs = {
            enable = true;
            listenAddress = "0.0.0.0";
          };
          # nextcloud={
          #   enable=true;
          #   username="l";
          #   user="l";
          #   port="443";
          # };
        };
        scrapeConfigs = [{
          job_name = "zfs";
          static_configs =
            [{ targets = [ "127.0.0.1:${toString cfg.port}" ]; }];
        }];
      };
    };

    networking.firewall.interfaces."${config.link.service-interface}".allowedTCPPorts =
      mkIf cfg.expose-port [ cfg.port ];
  };
}
