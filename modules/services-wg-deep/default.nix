{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.services.wg-deep;
in {
  options.link.services.wg-deep.enable = mkEnableOption "activate wg-deep";
  config = mkIf cfg.enable {
    networking.nat.internalInterfaces = [ "wg-deep" ];
    networking.wireguard.interfaces = {
      wg-deep = {
        # Determines the IP/IPv6 address and subnet of the client's end of the tunnel interface
        ips = [ "10.0.0.1/24" "fdc9:281f:04d7:9ee9::1/64" ];
        # The port that WireGuard listens to - recommended that this be changed from default
        listenPort = 51820;
        # Path to the server's private key
        privateKeyFile = "/home/l/.keys/wg-deep.private";

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
            publicKey = "kkdbV6j4kNA2xofP5XSKIlSl/1uwLkvijJ2I6YFiWiA=";
            presharedKeyFile = "/home/l/.keys/wg-deep-l.preshared";
            allowedIPs = [ "10.0.0.2/32" "fdc9:281f:04d7:9ee9::2/128" ];
          }
          {
            # Paul
            publicKey = "8D54qfl2TQQhzLq0e0rjQvsoU7BhJSdgpmOhumH1ghA=";
            presharedKeyFile = "/home/l/.keys/wg-deep-paul.preshared";
            allowedIPs = [ "10.0.0.3/32" "fdc9:281f:04d7:9ee9::3/128" ];
          }
          # {
          #   # peer2
          #   publicKey = "";
          #   presharedKeyFile = "/home/l/.keys/wg-deep-jucknath.preshared";
          #   allowedIPs = [ "10.0.0.4/32" "fdc9:281f:04d7:9ee9::4/128" ];
          # }
          # More peers can be added here.
        ];
      };
    };
  };
}
