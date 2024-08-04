{
  config,
  system-config,
  pkgs,
  lib,
  ...
}:
with lib;
let
  cfg = config.link.arr;
in
{
  options.link.arr.enable = mkEnableOption "activate arr";
  config = mkIf cfg.enable {
    services = {
      transmission = {
        enable = true;
        openFirewall = true;
        openPeerPorts = true;
        openRPCPort = true;
        performanceNetParameters = true;
        downloadDirPermissions = "777";
        settings = {
          incomplete-dir = "${config.link.storage}/torrents/incomplete";
          download-dir = "${config.link.storage}/torrents/";
          umask = 2;
          rpc-bind-address = "0.0.0.0";
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
  };
}
