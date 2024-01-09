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
    networking.firewall.interfaces."${config.link.service-interface}".allowedTCPPorts = [ 8765 ];
  };
}
