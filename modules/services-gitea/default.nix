{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.gitea;
in {
  options.link.gitea = { enable = mkEnableOption "activate gitea"; };
  config = mkIf cfg.enable {
    services = {
      gitea = {
        enable = true;
        stateDir = "${config.link.storage}gitea";
        settings.server = {
          ROOT_URL = "https://gitea.${config.link.domain}";
          COOKIE_SECURE = true;
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
          passwordFile = "${config.link.secrets}gitea-db";
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
      nginx.virtualHosts."https://gitea.${config.link.domain}" = {
        enableACME = true;
        forceSSL = true;
        locations = { "/" = { proxyPass = "http://127.0.0.1:${config.services.gitea.settings.server.HTTP_PORT}"; }; };
      };
    };
  };
}
