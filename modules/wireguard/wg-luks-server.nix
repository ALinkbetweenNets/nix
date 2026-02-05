{
  config,
  system-config,
  pkgs,
  lib,
  ...
}:
with lib;
let
  cfg = config.link.wg-luks-server;
in
{
  options.link.wg-luks-server.enable = mkEnableOption "activate wg-luks-server";
  config = mkIf cfg.enable {
    sops.secrets."wg-luks-preshared" = { };
    link.unbound.enable = true;
    services.unbound.settings.server = {
      interface = [ "10.5.6.1" ];
      access-control = [ "10.5.6.0/24 allow" ];
    };
    networking = {
      nat = {
        enable = true;
        enableIPv6 = true;
        externalInterface = config.link.eth;
        internalInterfaces = [ "wg-luks" ];
      };
      firewall = {
        allowedTCPPorts = [ 53 ];
        allowedUDPPorts = [
          53
          51826
        ];
        checkReversePath = mkForce false;
        logReversePathDrops = true;
      };
      wg-quick.interfaces = {
        # "wg-luks" is the network interface name. You can name the interface arbitrarily.
        wg-luks = {
          # Determines the IP/IPv6 address and subnet of the client's end of the tunnel interface
          address = [
            "10.5.6.1/24"
            "fdc9:281f:04d7:9eea::1/64"
          ];
          # The port that WireGuard listens to - recommended that this be changed from default
          listenPort = 51826;
          # Path to the server's private key
          privateKeyFile = "/root/.wg-keys/wg-luks-private";

          # This allows the wireguard server to route your traffic to the internet and hence be like a VPN
          postUp = ''
            ${pkgs.iptables}/bin/iptables -A FORWARD -i wg-luks -j ACCEPT
            ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.5.6.1/24 -o ${config.link.eth} -j MASQUERADE
          '';
            # ${pkgs.iptables}/bin/ip6tables -A FORWARD -i wg-luks -j ACCEPT
            # ${pkgs.iptables}/bin/ip6tables -t nat -A POSTROUTING -s fdc9:281f:04d7:9ee9::1/64 -o eth0 -j MASQUERADE
          # Undo the above
          preDown = ''
            ${pkgs.iptables}/bin/iptables -D FORWARD -i wg-luks -j ACCEPT
            ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.5.6.1/24 -o ${config.link.eth} -j MASQUERADE
          '';
            # ${pkgs.iptables}/bin/ip6tables -D FORWARD -i wg-luks -j ACCEPTy81f:04d7:9ee9::1/64 -o eth0 -j MASQUERADE
          peers = [
            {
              # npnt
              publicKey = "I2f/+kZ2Sg+C0mW34hSXzlD9EAB9OQ04w1byRJMkJBI=";
              presharedKeyFile = config.sops.secrets."wg-luks-preshared".path;
              allowedIPs = [
                "10.5.6.2/32"
                # "fdc9:281f:04d7:9eea::2/128"
              ];
            }
            # {
            #   # sn
            #   publicKey = "CHTfO3TqbfUSwTT4rq3jGSSby4m6DAJX9qtX9HweURg=";
            #   presharedKeyFile = config.sops.secrets."wireguard-preshared".path;
            #   allowedIPs = [ "10.5.5.5/32" "fdc9:281f:04d7:9ee9::5/128" ];
            # }
            # {
            #   # npn
            #   publicKey = "ajtRqtdZqffMrgANKQQ2VzWTDDKuAJyvS3naSFkXrD0=";
            #   presharedKeyFile = config.sops.secrets."wireguard-preshared".path;
            #   allowedIPs = [ "10.5.5.6/32" "fdc9:281f:04d7:9ee9::6/128" ];
            # }
          ];
        };
      };
    };
  };
}
