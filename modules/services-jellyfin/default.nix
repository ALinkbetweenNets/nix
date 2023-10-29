{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.jellyfin;
in {
  options.link.jellyfin.enable = mkEnableOption "activate jellyfin";
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      jellyfin-ffmpeg
    ];
    services = {
      jellyfin = {
        # package = pkgs.cudapkgs.jellyfin;
        enable = true;
        openFirewall = true;
      };
      jellyseerr = {
        enable = true;
        openFirewall = true;
      };
      nginx.virtualHosts = {
        "jellyfin.${config.link.domain}" = {
          enableACME = true;
          forceSSL = true;
          locations."/" = { proxyPass = "http://127.0.0.1:8096/"; };
        };
        "jellyseer.${config.link.domain}" = {
          enableACME = true;
          forceSSL = true;
          locations."/" = { proxyPass = "http://127.0.0.1:5055/"; };
        };
      };
    };
  };
}
