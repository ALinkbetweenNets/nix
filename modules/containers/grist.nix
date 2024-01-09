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
        GRIST_OIDC_IDP_SKIP_END_SESSION_ENDPOINT = "true";
      };
      environmentFiles = [
        config.sops.secrets."oid/grist/clientId".path
        config.sops.secrets."oid/grist/secret".path
      ];
      volumes = [ "${config.link.storage}/grist:/persist" ];
      ports = [ "8484:8484" ];
    };
    sops.secrets = {
      "oid/grist/clientId" = {
        group = "docker";
        mode = "0440";
      };
      "oid/grist/secret" = {
        group = "docker";
        mode = "0440";
      };
    };
    networking.firewall.interfaces."${config.link.service-interface}".allowedTCPPorts = [ 8484 ];
  };
}
