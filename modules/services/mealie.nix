{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.services.mealie;
in {
  options.link.services.mealie = {
    enable = mkEnableOption "activate mealie";
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
      default = 4123;
      description = "port to run the application on";
    };
  };
  config = mkIf cfg.enable {
    sops.secrets.mealie = {
      # owner = "mealie";
      # group = "mealie";
    };
    services.mealie = {
      enable = true;
      port = cfg.port;
      listenAddress = if cfg.expose-port then "0.0.0.0" else "127.0.0.1";
      credentialsFile = config.sops.secrets.mealie.path;
      settings={
        ALLOW_SIGNUP = "false";
      };
    };
    networking.firewall.allowedTCPPorts = mkIf cfg.expose-port [ cfg.port ];
  };
}
