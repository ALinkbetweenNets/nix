{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.home-assistant;
in {
  options.link.home-assistant.enable = mkEnableOption "activate home-assistant";
  config = mkIf cfg.enable {
    virtualisation.oci-containers = {
      containers.homeassistant = {
        volumes = [ "${config.link.containerDir}/home-assistant:/config" ];
        environment.TZ = "Europe/Berlin";
        image =
          "ghcr.io/home-assistant/home-assistant:stable"; # Warning: if the tag does not change, the image will not be updated
        extraOptions = [
          "--network=host"
          # "--cap-add=CAP_NET_RAW,CAP_NET_BIND_SERVICE"
          # "--device=/dev/ttyACM0:/dev/ttyACM0"  # Example, change this to match your own hardware
        ];
      };
    };
    networking.firewall.allowedTCPPorts = [ 8123 1900 ];
    networking.firewall.allowedUDPPorts = [ 1900 ];
  };
}
