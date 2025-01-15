{ lib, pkgs, config, ... }:
with lib;
let cfg = config.link.services.containers.grist;
in {
  options.link.services.containers.grist = {
    enable = mkEnableOption "activate grist container";
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
  };
  config = mkIf cfg.enable {
    virtualisation.oci-containers.containers.grist = {
      image = "gristlabs/grist-oss";
      # init = true;
      autoStart = true;
      # container_name = "grist-aio-mastercontainer";
      environment = {
        # APP_HOME_URL = "https://grist.${config.link.domain}";
        APP_HOME_URL="http://sn:8484";
        GRIST_SANDBOX_FLAVOR = "gvisor";
        GRIST_WIDGET_LIST_URL =
          "https://github.com/gristlabs/grist-widget/releases/download/latest/manifest.json";
        # GRIST_OIDC_SP_HOST = "https://grist.${config.link.domain}";
        # GRIST_OIDC_IDP_ISSUER =
        #   "https://gitea.${config.link.domain}/.well-known/openid-configuration";
        # GRIST_OIDC_IDP_SCOPES = "openid profile email";
        # GRIST_OIDC_IDP_SKIP_END_SESSION_ENDPOINT = "true";
      };
      environmentFiles = [
        # config.sops.secrets."oid/grist/clientId".path
        # config.sops.secrets."oid/grist/secret".path
        config.sops.secrets."grist".path
      ];
      volumes = [ "${config.link.storage}/grist:/persist" ];
      ports = [ "8484:8484" ];
    };
    sops.secrets."grist" = { };
    # sops.secrets = {
    #   "oid/grist/clientId" = {
    #     group = "docker";
    #     mode = "0440";
    #   };
    #   "oid/grist/secret" = {
    #     group = "docker";
    #     mode = "0440";
    #   };
    # };
    services.nginx.virtualHosts."grist.${config.link.domain}" = mkIf cfg.nginx {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:8484";
        proxyWebsockets = true;
      };
    };
    # extraConfig = mkIf (!cfg.expose) ''
    # extraConfig = mkIf (!cfg.expose) ''
    #   allow ${config.link.service-ip}/24;
    #   allow ${config.link.service-ip}/24;
    #     allow 127.0.0.1;
    #     allow 127.0.0.1;
    #     deny all; # deny all remaining ips
    #     deny all; # deny all remaining ips
    # '';
    # '';
    networking.firewall.interfaces."${config.link.service-interface}".allowedTCPPorts =
      mkIf cfg.expose-port [ 8484 ];
  };
}
