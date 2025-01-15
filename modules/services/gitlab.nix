{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.services.gitlab;
in {
  options.link.services.gitlab = {
    enable = mkEnableOption "activate gitlab";
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
      default = 5500;
      description = "port to run the application on";
    };
  };
  config = mkIf cfg.enable {
    sops.secrets = {
      "gitlab/db" = {
        owner = "gitlab";
        group = "gitlab";
      };
      "gitlab/dbPass" = {
        owner = "gitlab";
        group = "gitlab";
      };
      "gitlab/otp" = {
        owner = "gitlab";
        group = "gitlab";
      };
      "gitlab/initial-root" = {
        owner = "gitlab";
        group = "gitlab";
      };
      "gitlab/secret" = {
        owner = "gitlab";
        group = "gitlab";
      };
    };
    services = {
      nginx = {
        enable = true;
        recommendedProxySettings = true;
        virtualHosts = {
          "gitlab.alinkbetweennets.de" = {
            locations."/".proxyPass =
              "http://unix:/run/gitlab/gitlab-workhorse.socket";
          };
        };
      };
      gitlab = {
        enable = true;
        port = cfg.port;
        statePath = "${config.link.storage}/gitlab/state";
        # https = true;
        host = "gitlab.alinkbetweennets.de";
        pages.settings.pages-domain = "pages.alinkbetweennets.de";
        databaseCreateLocally = true;
        databasePasswordFile = config.sops.secrets."gitlab/dbPass".path;
        initialRootPasswordFile =
          config.sops.secrets."gitlab/initial-root".path;
        secrets = {
          secretFile = config.sops.secrets."gitlab/secret".path;
          otpFile = config.sops.secrets."gitlab/otp".path;
          dbFile = config.sops.secrets."gitlab/db".path;
          jwsFile = pkgs.runCommand "oidcKeyBase" { }
            "${pkgs.openssl}/bin/openssl genrsa 2048 > $out";
        };
      };
    };
    networking.firewall.interfaces."${config.link.service-interface}".allowedTCPPorts =
      mkIf cfg.expose-port [ cfg.port ];
    systemd.services.gitlab-backup.environment.BACKUP = "dump";
  };
}
