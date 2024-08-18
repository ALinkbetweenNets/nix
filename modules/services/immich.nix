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
      default = 2283;
      description = "port to run the application on";
    };
  };
  config = mkIf cfg.enable {
    systemd.services.docker-immich = {
      description = "Immich docker-compose service";
      wantedBy = [ "multi-user.target" ];
      after = [ "docker.service" "docker.socket" "remote-fs.target" ];
      serviceConfig = {
        WorkingDirectory = "${./immich}";
        ExecStart =
          "${pkgs.docker}/bin/docker compose --env-file .env --env-file ${config.sops.secrets.immich.path} up --build";
        ExecStop = "${pkgs.docker}/bin/docker compose down";
        Restart = "on-failure";
      };
    };
    networking.firewall.allowedTCPPorts = mkIf cfg.expose-port [ cfg.port ];
    sops.secrets.immich = { path = "/run/keys/immich.env"; };
  };
}
