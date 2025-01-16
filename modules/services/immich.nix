{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.services.immich;
in {
  options.link.services.immich = {
    enable = mkEnableOption "activate immich";
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
      default = 3001;
      description = "port to run the application on";
    };
  };
  config = mkIf cfg.enable {
    sops.secrets.immich = {
      owner = "immich";
      group = "immich";
    };
    services.immich = {
      environment = {
        IMMICH_MACHINE_LEARNING_URL = "http://localhost:3003";
        IMMICH_LOG_LEVEL = "verbose";
      };
      mediaLocation = "${config.link.storage}/immich";
      enable = true;
      port = cfg.port;
      host = if cfg.expose-port then "0.0.0.0" else "localhost";
      secretsFile = config.sops.secrets.immich.path;
    };
    networking.firewall.allowedTCPPorts = mkIf cfg.expose-port [ cfg.port ];
    sops.secrets.immich = { path = "/run/keys/immich.env"; };
  };
}
