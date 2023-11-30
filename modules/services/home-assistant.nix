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
        image = "ghcr.io/home-assistant/home-assistant:stable"; # Warning: if the tag does not change, the image will not be updated
        extraOptions = [
          "--network=host"
          # "--device=/dev/ttyACM0:/dev/ttyACM0"  # Example, change this to match your own hardware
        ];
      };
    };
    services.  nginx.virtualHosts."home.${config.link.domain}" = {
      enableACME = true;
      forceSSL = true;
      locations = { "/" = { proxyPass = "http://127.0.0.1:8123"; }; };
    };
  };
}
