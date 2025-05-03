{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.arr;
in {
  options.link.arr.enable = mkEnableOption "activate arr";
  config = mkIf cfg.enable {
    networking.nat = {
      enable = true;
      # Use "ve-*" when using nftables instead of iptables
      internalInterfaces = [ "ve-+" ];
      externalInterface = config.link.eth;
      # Lazy IPv6 connectivity for the container
      enableIPv6 = true;
    };
    containers.arr-container = {
      autoStart = true;
      privateNetwork = true;
      hostAddress = "192.168.100.10";
      localAddress = "192.168.100.11";
      hostAddress6 = "fc00::1";
      localAddress6 = "fc00::2";
      # autoStart = true;
      config = { ... }: {
        system.stateVersion = "24.11";
        networking = {
          firewall =
            { # If you don't add a state version, nix will complain at every rebuild
              enable = true;
              # Exposing the nessecary ports in order to interact with i2p from outside the container
              allowedTCPPorts = [
                7656 # default sam port
                7070 # default web interface port
                4444 # default http proxy port
                4447 # default socks proxy port
              ];
            };
          # Use systemd-resolved inside the container
          # Workaround for bug https://github.com/NixOS/nixpkgs/issues/162686
          useHostResolvConf = lib.mkForce false;
        };
        services.resolved.enable = true;
        services.mullvad-vpn.enable = true;
        # services = {
        #   transmission = {
        #     enable = true;
        #     openFirewall = true;
        #     openPeerPorts = true;
        #     openRPCPort = true;
        #     performanceNetParameters = true;
        #     downloadDirPermissions = "777";
        #     settings = {
        #       incomplete-dir = "${config.link.storage}/torrents/incomplete";
        #       download-dir = "${config.link.storage}/torrents/";
        #       umask = 2;
        #       rpc-bind-address = "0.0.0.0";
        #     };
        #   };
        #   radarr = {
        #     enable = true;
        #     openFirewall = true;
        #   };
        #   sonarr = {
        #     enable = true;
        #     openFirewall = true;
        #   };
        #   lidarr = {
        #     enable = true;
        #     openFirewall = true;
        #   };
        #   readarr = {
        #     enable = true;
        #     openFirewall = true;
        #   };
        #   prowlarr = {
        #     enable = true;
        #     openFirewall = true;
        #   };
        #   jellyseerr = {
        #     enable = true;
        #     openFirewall = true;
        #   };
        #   jellyfin = {
        #     enable = true;
        #     openFirewall = true;
        #   };
        # };
      };
    };
  };
}
