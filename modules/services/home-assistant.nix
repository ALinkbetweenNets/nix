{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.services.home-assistant;
in {
  options.link.services.home-assistant = {
    enable = mkEnableOption "activate home-assistant";
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
    nginx-expose = mkOption {
      type = types.bool;
      default = config.link.nginx-expose;
      description = "expose the application to the internet";
    };
    port = mkOption {
      type = types.int;
      default = 8123;
      description = "port to run the application on";
    };
  };
  config = mkIf cfg.enable {
    services = {
      home-assistant = {
        enable = true;
        openFirewall = true;
        lovelaceConfigWritable = true;
        configWritable = true;
        extraComponents = [
          "default_config"
          "esphome"
          "jellyfin"
          "met"
          "my"
          "ollama"
          "pushover"
          "radio_browser"
          "shopping_list"
          "tts"
          "tuya"
          "unifi"
          "wled"
          "zoneminder"
        ];
        config = {
          http.server_port = cfg.port;
          # homeassistant = {
          #   unit_system = "metric";
          #   temperature_unit = "C";
          #   # name = "Home";
          # };
        };
      };
    };
    # networking.firewall.interfaces."${config.link.service-interface}".allowedTCPPorts =
    # mkIf cfg.expose-port [ cfg.port ];
  };
}
