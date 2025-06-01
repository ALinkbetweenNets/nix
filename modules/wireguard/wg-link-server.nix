{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.wg-link-server;
in {
  options.link.wg-link-server.enable = mkEnableOption "activate wg-link";
  config = mkIf cfg.enable {
    sops.secrets."wireguard-preshared" = { };
    link.unbound.enable = true;
    services.unbound.settings.server = {
      interface = [ "10.5.5.1" ];
      access-control = [ "10.5.5.0/24 allow" ];
    };
    networking = {
      nat = {
        enable = true;
        enableIPv6 = true;
        externalInterface = config.link.eth;
        internalInterfaces = [ "wg0" ];
      };
      firewall = {
        allowedTCPPorts = [ 53 ];
        allowedUDPPorts = [ 53 51825 ];
        checkReversePath = mkForce false;
        logReversePathDrops = true;
      };
      wg-quick.interfaces = {
        # "wg0" is the network interface name. You can name the interface arbitrarily.
        wg0 = {
          # Determines the IP/IPv6 address and subnet of the client's end of the tunnel interface
          address = [ "10.5.5.1/24" "fdc9:281f:04d7:9ee9::1/64" ];
          # The port that WireGuard listens to - recommended that this be changed from default
          listenPort = 51825;
          # Path to the server's private key
          privateKeyFile = "/root/.wg-keys/private";

          # This allows the wireguard server to route your traffic to the internet and hence be like a VPN
          postUp = ''
            ${pkgs.iptables}/bin/iptables -A FORWARD -i wg0 -j ACCEPT
            ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.5.5.1/24 -o eth0 -j MASQUERADE
            ${pkgs.iptables}/bin/ip6tables -A FORWARD -i wg0 -j ACCEPT
            ${pkgs.iptables}/bin/ip6tables -t nat -A POSTROUTING -s fdc9:281f:04d7:9ee9::1/64 -o eth0 -j MASQUERADE
          '';
          # Undo the above
          preDown = ''
            ${pkgs.iptables}/bin/iptables -D FORWARD -i wg0 -j ACCEPT
            ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.5.5.1/24 -o eth0 -j MASQUERADE
            ${pkgs.iptables}/bin/ip6tables -D FORWARD -i wg0 -j ACCEPT
            ${pkgs.iptables}/bin/ip6tables -t nat -D POSTROUTING -s fdc9:281f:04d7:9ee9::1/64 -o eth0 -j MASQUERADE
          '';
          peers = [{ # fn
            publicKey = "VoWSuobtJ1FfmEQ6VSHygKGQDe1S9WcrGM2zs1Z6H20=";
            presharedKeyFile = config.sops.secrets."wireguard-preshared".path;
            allowedIPs = [ "10.5.5.2/32" "fdc9:281f:04d7:9ee9::2/128" ];
          }
          # More peers can be added here.
            ];
        };
      };
    };
  };
}
