{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.services.wg-link;
in {
  options.link.services.wg-link.enable = mkEnableOption "activate wg-link";
  config = mkIf cfg.enable {
    networking.nat.internalInterfaces = [ "wg-link" ];
    networking.wireguard.interfaces = {
      wg-link = {
        # Determines the IP/IPv6 address and subnet of the client's end of the tunnel interface
        ips = [ "10.0.1.1/24" "fdc9:281f:04d7:9eea::1/64" ];
        # The port that WireGuard listens to - recommended that this be changed from default
        listenPort = 51820;
        # Path to the server's private key
        privateKeyFile = "/home/l/.keys/wg-link.private";
        # This allows the wireguard server to route your traffic to the internet and hence be like a VPN
        # For this to work you have to set the dnsserver IP of your router (or dnsserver of choice) in your clients
        postSetup = ''
          ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o eth0 -j MASQUERADE
        '';
        # This undoes the above command
        postShutdown = ''
          ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.100.0.0/24 -o eth0 -j MASQUERADE
        '';
        peers = [
          {
            # l
            publicKey = "0sORXE+4f3331BRLHFTciX4iurHgOYky3Xrg0DLCnjs=";
            presharedKeyFile = "/home/l/.keys/wg-link-l.preshared";
            allowedIPs = [ "10.0.1.2/32" "fdc9:281f:04d7:9eea::2/128" ];
          }
          {
            # Louis
            publicKey = "p3ZnR7XTY8dO+zmUzMQUjVQHQwWFxIUTu9jvcuuUrQc=";
            presharedKeyFile = "/home/l/.keys/wg-link-louis.preshared";
            allowedIPs = [ "10.0.1.3/32" "fdc9:281f:04d7:9eea::3/128" ];
          }
          # {
          #   # peer2
          #   publicKey = "";
          #   presharedKeyFile = "/home/l/.keys/wg-link-jucknath.preshared";
          #   allowedIPs = [ "10.0.0.4/32" "fdc9:281f:04d7:9ee9::4/128" ];
          # }
          # More peers can be added here.
        ];
      };
    };
  };
}
