{ lib, pkgs, config, ... }:
with lib;
let cfg = config.link.containers.diagrams;
in {
  options.link.containers.diagrams = {
    enable = mkEnableOption "activate diagrams container";
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
    virtualisation.oci-containers.containers.diagrams = {
      image = "jgraph/drawio";
      autoStart = true;
      environment = { PUBLIC_DNS = "drawio.${config.link.domain}"; };
      volumes = [ "${config.link.storage}/diagrams:/persist" ];
      ports = [ "8765:8080" ];
    };
    networking.firewall.interfaces."${config.link.service-interface}".allowedTCPPorts =
      mkIf cfg.expose-port [ 8765 ];
    services.nginx.virtualHosts."diagrams.${config.link.domain}" =
      mkIf cfg.nginx {
        enableACME = true;
        forceSSL = true;
        locations."/" = { proxyPass = "http://127.0.0.1:8765"; };
        # extraConfig = mkIf (!cfg.expose) ''
        #   allow ${config.link.service-ip}/24;
        #     allow 127.0.0.1;
        #     deny all; # deny all remaining ips
        # '';
      };
  };
}
