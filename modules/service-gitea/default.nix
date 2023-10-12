{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.gitea;
in {
  options.link.gitea.enable = mkEnableOption "activate gitea";
  config = mkIf cfg.enable {
    services = {
      gitea = {
        enable = true;
        stateDir = "/rz/srv/gitea";
        settings.server = {
          DOMAIN = "gitea.alinkbetweennets.de";
          ROOT_URL = "https://gitea.alinkbetweennets.de";
          #USE_PROXY_PROTOCOL=true;
          #REDIRECT_OTHER_PORT=true;
          #PORT_TO_REDIRECT=3080;
          #HTTP_PORT = 3000;
          #PROTOCOL="https";
          #ENABLE_ACME=true;
          #ACME_ACCEPTTOS=true;
          #ACME_DIRECTORY="https";
          #ACME_EMAIL="alinkbetweennets+acme@protonmail.com";
        };
        settings.service = {
          DISABLE_REGISTRATION = false;
          ENABLE_AUTO_REGISTRATION = true;
          REQUIRE_SIGNIN_VIEW = true;
          REGISTER_MANUAL_CONFIRM = true;
        };
        settings.oauth2_client = { ENABLE_AUTO_REGISTRATION = false; };
        lfs.enable = true;
        #user = "l";
        database = {
          # enable = true;
          type = "postgres";
          host = "localhost";
          #name = "gitea";
          #user = "l";
          passwordFile = "/pwd/gitea";
        };
      };
      postgresql = {
        enable = true; # Ensure postgresql is enabled
        authentication = ''
          local gitea all ident map=gitea-users
        '';
        identMap = # Map the gitea user to postgresql
          ''
            gitea-users gitea gitea
          '';
        package = pkgs.postgresql_11;
      };
      nginx.virtualHosts."gitea.alinkbetweennets.de" = {
        enableACME = true;
        forceSSL = true;
        locations = { "/" = { proxyPass = "http://127.0.0.1:3000/"; }; };
      };
    };
  };
}
