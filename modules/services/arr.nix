{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.arr;
in {
  options.link.arr.enable = mkEnableOption "activate arr";
  config = mkIf cfg.enable {
    containers.arr-container = {
      # autoStart = true;
      config = { ... }: {
        system.stateVersion =
          "23.05"; # If you don't add a state version, nix will complain at every rebuild
        # Exposing the nessecary ports in order to interact with i2p from outside the container
        networking.firewall.allowedTCPPorts = [
          7656 # default sam port
          7070 # default web interface port
          4444 # default http proxy port
          4447 # default socks proxy port
        ];
        services = {
          transmission = {

            package=pkgs.transmission_4;
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
    };
  };
}
