{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.arr;
in {
  options.link.arr.enable = mkEnableOption "activate arr";
  config = mkIf cfg.enable {
    services = {
      deluge = {
        enable = true;
        authFile = "/home/l/.deluge-auth";
        web = {
          port = 8112;
          enable = true;
          openFirewall = true;
        };
        # extraPackages = [ "Label" "Toggle" "Stats" "Blocklist" "Extractor" "Scheduler" ];
        user = "l";
        openFirewall = true;
        declarative = true;
        config = {
          download_location = "/arr/torrents/";
          max_upload_speed = "1000.0";
          max_connections_global = 300;
          max_upload_slots_global = 10;
          max_connections_per_second = 40;
          max_half_open_connections = 200;
          max_active_downloading = 20;
          max_active_seeding = 20;
          max_active_limit = 40;
          dont_count_slow_torrents = true;
          share_ratio_limit = "3.0";
          allow_remote = true;
          daemon_port = 58846;
          # listen_ports = [ 6881 6889 ];
        };

      };
      radarr = {
        enable = true;
        openFirewall = true;
      };
      sonarr = {
        enable = true;
        openFirewall = true;
      };
      lidarr = {
        enable = true;
        openFirewall = true;
      };
      readarr = {
        enable = true;
        openFirewall = true;
      };
      prowlarr = {
        enable = true;
        openFirewall = true;
      };
      jellyseerr = {
        enable = true;
        openFirewall = true;
      };
      jellyfin = {
        enable = true;
        openFirewall = true;
      };
    };
    fileSystems."arra" = {
      device = "arra"; # Replace with the correct device or path
      fsType = "9p"; # Replace with the filesystem type
      mountPoint = "/arr";
      options = [ "trans=virtio" ];
    };
  };
}
