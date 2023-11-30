{ lib, pkgs, config, ... }:
with lib;
let cfg = config.link.containers.diagrams;
in
{
  options.link.containers.diagrams = {
    enable = mkEnableOption "activate diagrams container";
  };
  config = mkIf cfg.enable {
    virtualisation.oci-containers.containers.diagrams = {
      image = "jgraph/drawio";
      autoStart = true;
      environment = {
        PUBLIC_DNS = "drawio.${config.link.domain}";
      };
      volumes = [ "${config.link.storage}/diagrams:/persist" ];
      ports = [ "8765:8080" ];
    };
    services.nginx.virtualHosts."diagrams.${config.link.domain}" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:8765";
      };
      # extraConfig = mkIf (!cfg.expose) ''
      #   allow ${config.link.service-ip}/24;
      #     allow 127.0.0.1;
      #     deny all; # deny all remaining ips
      # '';
    };
  };
}
