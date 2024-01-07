{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.services.nextcloud;
in {
  options.link.services.nextcloud = {
    enable = mkEnableOption "activate matrix";
    expose = mkOption {
      type = types.bool;
      default = config.link.expose;
      description = "expose matrix to the internet with NGINX and ACME";
    };
    nginx = mkOption {
      type = types.bool;
      default = config.link.nginx.enable;
      description = "Use service with NGINX";
    };
  };
  config = mkIf cfg.enable {
    services = {
      nextcloud = {
        enable = true;
        hostName = if cfg.nginx then "nextcloud.${config.link.domain}" else config.link.service-ip;
        config = {
          adminuser = "l";
          adminpassFile = "${config.link.secrets}/nextcloud";
        };
        #secretFile = "${config.link.secrets}/nextcloud-secrets.json";
        package = pkgs.nextcloud27;
        extraApps = with config.services.nextcloud.package.packages.apps; {
          inherit bookmarks calendar contacts deck keeweb mail news notes onlyoffice polls tasks twofactor_webauthn;
        };
        #extraOptions = {
        #  mail_smtpmode = "sendmail";
        #  mail_sendmailmode = "pipe";
        #};
        extraAppsEnable = true;
        autoUpdateApps.enable = true;
        appstoreEnable = true;
        https = true;
        configureRedis = true;
        database.createLocally = true;
        home = "${config.link.storage}/nextcloud";
      };
      nginx.virtualHosts."nextcloud.${config.link.domain}" = mkIf cfg.nginx {
        enableACME = true;
        forceSSL = true;
        extraConfig = mkIf (!cfg.expose) ''
          allow ${config.link.service-ip}/24;
          allow 127.0.0.1;
          deny all; # deny all remaining ips
        '';
        #locations."/" = {
        #  proxyPass = "http://127.0.0.1:80/";
        # extraConfig = ''
        #   proxy_set_header Front-End-Https on;
        #   proxy_set_header Strict-Transport-Security "max-age=2592000; includeSubdomains";
        #   proxy_set_header X-Real-IP $remote_addr;
        #   proxy_set_header Host $host;
        #   proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        #   proxy_set_header X-Forwarded-Proto $scheme;
        # '';
        #};
      };
    };
  };
}
