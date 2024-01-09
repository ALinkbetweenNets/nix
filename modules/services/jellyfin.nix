{ config, pkgs, lib, ... }:
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
      };
      jellyseerr = {
        enable = true;
      };
    };
    networking.firewall.interfaces."${config.link.service-interface}".allowedTCPPorts = [ 5055 8096 ];
  };
}
