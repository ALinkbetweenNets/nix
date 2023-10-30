{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.home-assistant;
in {
  options.link.home-assistant.enable = mkEnableOption "activate home-assistant";
  config = mkIf cfg.enable {
    services = {
      home-assistant = {
        enable = true;
        openFirewall = true;
        config = {
          homeassistant = {
            name = "Home";
            latitude = "50.4";
            longitude = " 7.6";
            elevation = "100m";
            unit_system = "metric";
            temperature_unit = "C";
          };
          frontend = { themes = "!include_dir_merge_named themes"; };
          http = { server_port = 8123; };
          feedreader.urls = [ "https://nixos.org/blogs.xml" ];
        };
      };
      nginx.virtualHosts = {
        "home.${config.link.domain}" = {
          enableACME = true;
          forceSSL = true;
          locations = {
            "/" = {
              proxyPass = "http://127.0.0.1:${toString config.services.home-assistant.config.http.server_port}/";
              extraConfig = ''
                proxy_set_header X-Forwarded-Host $http_host;
                proxy_set_header X-Real-IP $remote_addr;
                proxy_set_header X-Forwarded-Proto $scheme;
              '';
            };
          };
        };
      };
    };
  };
}
