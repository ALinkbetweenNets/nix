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
      environment.APP_HOME_URL="https://grist.${config.link.domain}";
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
