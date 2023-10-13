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
        extraPackages =
          [ "Label" "Toggle" "Stats" "Blocklist" "Extractor" "Scheduler" ];
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
    networking.wg-quick.interfaces.wg-mullvad = {
      # Device: Simple Whale
      # Determines the IP address and subnet of the server's end of the tunnel interface.
      address = [ "10.64.253.12/32" "fc00:bbbb:bbbb:bb01::1:fd0b/128" ];
      dns = [ "100.64.0.1" ];
      # The port that WireGuard listens to. Must be accessible by the client.
      listenPort = 51821;

      # This allows the wireguard server to route your traffic to the internet and hence be like a VPN
      # For this to work you have to set the dnsserver IP of your router (or dnsserver of choice) in your clients
      # postUp = ''
      #   ${pkgs.iptables}/bin/iptables -I OUTPUT ! -o %i -m mark ! --mark $(wg show %i fwmark) -m addrtype ! --dst-type LOCAL -j REJECT && ip6tables -I OUTPUT ! -o %i -m mark ! --mark $(wg show %i fwmark) -m addrtype ! --dst-type LOCAL -j REJECT
      # '';

      # # This undoes the above command
      # postDown = ''
      #   ${pkgs.iptables}/bin/iptables -D OUTPUT ! -o %i -m mark ! --mark $(wg show %i fwmark) -m addrtype ! --dst-type LOCAL -j REJECT && ip6tables -D OUTPUT ! -o %i -m mark ! --mark $(wg show %i fwmark) -m addrtype ! --dst-type LOCAL -j REJECT
      # '';

      # Path to the private key file.
      #
      # Note: The private key can also be included inline via the privateKey option,
      # but this makes the private key world-readable; thus, using privateKeyFile is
      # recommended.
      privateKey = "SDcthu8IWAfh4ovkLAH7kMMZzyMnJruSPMVJIgyLmFo=";

      peers = [
        # List of allowed peers.
        {
          # Public key of the server (not a file path).

          publicKey = "C3jAgPirUZG6sNYe4VuAgDEYunENUyG34X42y+SBngQ=";
          # Forward all the traffic via VPN.
          allowedIPs = [ "0.0.0.0/0" "::0/0" ];
          # Or forward only particular subnets
          #allowedIPs = [ "10.100.0.1" "91.108.12.0/22" ];

          # Set this to the server IP and port.
          endpoint =
            "185.254.75.5:3124"; # ToDo: route to endpoint not automatically configured https://wiki.archlinux.org/index.php/WireGuard#Loop_routing https://discourse.nixos.org/t/solved-minimal-firewall-setup-for-wireguard-client/7577

          # Send keepalives every 25 seconds. Important to keep NAT tables alive.
          persistentKeepalive = 25;
        }
      ];
    };
  };
}
