{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.services.gitea;
in {
  options.link.services.gitea = {
    enable = mkEnableOption "activate gitea";
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
      default = 3000;
      description = "port to run the application on";
    };
  };
  config = mkIf cfg.enable {
    sops.secrets."gitea" = {
      owner = "gitea";
      group = "gitea";
    };
    services = {
      gitea = {
        enable = true;
        #stateDir = "${config.link.storage}/gitea";
        settings.server = {
          ROOT_URL = "https://gitea.${config.link.domain}";
          COOKIE_SECURE = true;
          HTTP_PORT = cfg.port;
        };
        settings.service = {
          DISABLE_REGISTRATION = false;
          ENABLE_AUTO_REGISTRATION = true;
          REQUIRE_SIGNIN_VIEW = true;
          REGISTER_MANUAL_CONFIRM = true;
        };
        settings.oauth2_client = { ENABLE_AUTO_REGISTRATION = false; };
        lfs.enable = true;
        database = {
          type = "postgres";
          passwordFile = config.sops.secrets."gitea".path;
        };
      };
      postgresql = {
        enable = true;
        authentication = ''
          local gitea all ident map=gitea-users
        '';
        identMap = # Map the gitea user to postgresql
          ''
            gitea-users gitea gitea
          '';
      };
      nginx.virtualHosts."gitea.${config.link.domain}" = mkIf cfg.nginx {
        enableACME = true;
        forceSSL = true;
        locations."/".proxyPass =
          "http://127.0.0.1:${toString cfg.port}"; # default 3000
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
