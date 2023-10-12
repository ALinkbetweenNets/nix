{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.jellyfin;
in {
  options.link.jellyfin.enable = mkEnableOption "activate jellyfin";
  config = mkIf cfg.enable {
    fileSystems."/export" = {
      device = "/rz";
      options = [ "bind" ];
    };
    services = {
      jellyseerr = {
        enable = true;
        openFirewall = true;
      };
      jellyfin = {
        enable = true;
        openFirewall = true;
      };
      nginx.virtualHosts = {
        "jellyfin.alinkbetweennets.de" = {
          enableACME = true;
          forceSSL = true;
          locations."/" = { proxyPass = "http://127.0.0.1:8096/"; };
        };
        "jellyseer.alinkbetweennets.de" = {
          enableACME = true;
          forceSSL = true;
          locations."/" = { proxyPass = "http://127.0.0.1:5055/"; };
        };
      };
    };
  };
}
