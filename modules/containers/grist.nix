{ lib, pkgs, config, ... }:
with lib;
let cfg = config.link.containers.grist;
in
{
  options.link.containers.grist = {
    enable = mkEnableOption "activate grist container";
  };
  config = mkIf cfg.enable {
    virtualisation.oci-containers.containers.grist = {
      image = "gristlabs/grist";
      # init = true;
      autoStart = true;
      # container_name = "grist-aio-mastercontainer";
      environment = {
        APP_HOME_URL = "https://grist.${config.link.domain}";
        GRIST_OIDC_SP_HOST = "https://grist.${config.link.domain}";
        GRIST_OIDC_IDP_ISSUER = "https://gitea.${config.link.domain}/.well-known/openid-configuration";
        GRIST_OIDC_IDP_SCOPES = "openid profile email";
        # GRIST_OIDC_IDP_SKIP_END_SESSION_ENDPOINT
      };
      environmentFiles = [
        config.sops.secrets."oid/grist/clientId".path
        config.sops.secrets."oid/grist/secret".path
      ];
      config.sops.secrets."oid/grist/clientId".group = "docker";
      config.sops.secrets."oid/grist/clientId".mode = "0440";
      config.sops.secrets."oid/grist/secret".group = "docker";
      config.sops.secrets."oid/grist/secret".mode = "0440";
      volumes = [ "${config.link.storage}/grist:/persist" ];
      ports = [ "8484:8484" ];
    };
    services.nginx.virtualHosts."grist.${config.link.domain}" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:8484";
      };
      # extraConfig = mkIf (!cfg.expose) ''
      #   allow ${config.link.service-ip}/24;
      #     allow 127.0.0.1;
      #     deny all; # deny all remaining ips
      # '';
    };
  };
}
