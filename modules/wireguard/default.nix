{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.wireguard;
in {
  options.link.wireguard.enable = mkEnableOption "activate wireguard";
  config = mkIf cfg.enable {
    networking.firewall = {
      # if packets are still dropped, they will show up in dmesg
      logReversePathDrops = true;
      # wireguard trips rpfilter up
      extraCommands = ''
        ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --sport 51820 -j RETURN
        ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --dport 51820 -j RETURN
      '';
      extraStopCommands = ''
        ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --sport 51820 -j RETURN || true
        ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --dport 51820 -j RETURN || true
      '';
    };
    networking.wg-quick.interfaces = {
      # "wg0" is the network interface name. You can name the interface arbitrarily.
      wg-deep = {
        # Determines the IP address and subnet of the server's end of the tunnel interface.
        address = [ "10.0.1.4/32" ];
        mtu = 1392;
        # The port that WireGuard listens to. Must be accessible by the client.
        listenPort = 51820;

        # This allows the wireguard server to route your traffic to the internet and hence be like a VPN
        # For this to work you have to set the dnsserver IP of your router (or dnsserver of choice) in your clients
        #postSetup = ''
        #  ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o wlp0s20f3 -j MASQUERADE
        #'';

        # This undoes the above command
        #postShutdown = ''
        #  ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.100.0.0/24 -o wlp0s20f3 -j MASQUERADE
        #'';

        # Path to the private key file.
        #
        # Note: The private key can also be included inline via the privateKey option,
        # but this makes the private key world-readable; thus, using privateKeyFile is
        # recommended.
        privateKeyFile = "/home/l/.wg/private";

        peers = [{
          presharedKey = "IY6H94t+D5kA1QC9CvzJeTlq/9PZgylBkW0kfWScPRA=";
          publicKey = "Bac7UWeg9iM4vpBzUppL427gO5cNaO75fnkS9OtYkgI=";
          allowedIPs = [ "10.0.1.0/24" "10.0.0.0/24" ];

          # Set this to the server IP and port.
          endpoint =
            "65.109.157.99:51820"; # ToDo: route to endpoint not automatically configured https://wiki.archlinux.org/index.php/WireGuard#Loop_routing https://discourse.nixos.org/t/solved-minimal-firewall-setup-for-wireguard-client/7577

          # Send keepalives every 25 seconds. Important to keep NAT tables alive.
          persistentKeepalive = 25;
        }];
      };
      # wg-mullvad = {
      #   # DeviceDevice: Great Tapir
      #   # Determines the IP address and subnet of the server's end of the tunnel interface.
      #   address = [ "10.65.56.178/32" "fc00:bbbb:bbbb:bb01::2:38b1/128" ];
      #   dns = [ "100.64.0.1" ];
      #   # The port that WireGuard listens to. Must be accessible by the client.
      #   listenPort = 51821;

      #   # This allows the wireguard server to route your traffic to the internet and hence be like a VPN
      #   # For this to work you have to set the dnsserver IP of your router (or dnsserver of choice) in your clients
      #   postUp = ''
      #     ${pkgs.iptables}/bin/iptables -I OUTPUT ! -o %i -m mark ! --mark $(wg show %i fwmark) -m addrtype ! --dst-type LOCAL -j REJECT && ip6tables -I OUTPUT ! -o %i -m mark ! --mark $(wg show %i fwmark) -m addrtype ! --dst-type LOCAL -j REJECT
      #   '';

      #   # This undoes the above command
      #   postDown = ''
      #     ${pkgs.iptables}/bin/iptables -D OUTPUT ! -o %i -m mark ! --mark $(wg show %i fwmark) -m addrtype ! --dst-type LOCAL -j REJECT && ip6tables -D OUTPUT ! -o %i -m mark ! --mark $(wg show %i fwmark) -m addrtype ! --dst-type LOCAL -j REJECT
      #   '';

      #   # Path to the private key file.
      #   #
      #   # Note: The private key can also be included inline via the privateKey option,
      #   # but this makes the private key world-readable; thus, using privateKeyFile is
      #   # recommended.
      #   privateKey = "+y17rI4kbSRAn3OvQ32H+NESOU5T922kU+o2JXZrnE4=";

      #   peers = [
      #     # List of allowed peers.
      #     { # Public key of the server (not a file path).

      #       publicKey = "s1c/NsfnqnwQSxao70DY4Co69AFT9e0h88IFuMD5mjs=";
      #       # Forward all the traffic via VPN.
      #       allowedIPs = [ "0.0.0.0/0" "::0/0" ];
      #       # Or forward only particular subnets
      #       #allowedIPs = [ "10.100.0.1" "91.108.12.0/22" ];

      #       # Set this to the server IP and port.
      #       endpoint =
      #         "185.254.75.4:3054"; # ToDo: route to endpoint not automatically configured https://wiki.archlinux.org/index.php/WireGuard#Loop_routing https://discourse.nixos.org/t/solved-minimal-firewall-setup-for-wireguard-client/7577

      #       # Send keepalives every 25 seconds. Important to keep NAT tables alive.
      #       persistentKeepalive = 25;
      #     }
      #   ];
      # };
      # wg-fritz = {
      #   address = [ "192.168.178.205/24" ];
      #   dns = [ "192.168.178.1" "fritz.box" ];
      #   privateKey = "aC7gLKQnG2pU+A78BNAJWf1tJMg30eKvpEt5nn10/Hc=";
      #   peers = [{
      #     publicKey = "MNJPzp13bxiTzT8Z8TvrQEuxU/6ufi1oi8eswoshmC0=";
      #     allowedIPs = [ "192.168.178.0/24" "0.0.0.0/0" ];
      #     endpoint = "ur6qwb3amjjhe15h.myfritz.net:56355";
      #     persistentKeepalive = 25;
      #   }];
      #   # postUp = ''
      #   #   ${pkgs.iptables}/bin/iptables -I OUTPUT ! -o %i -m mark ! --mark $(wg show %i fwmark) -m addrtype ! --dst-type LOCAL -j REJECT && ip6tables -I OUTPUT ! -o %i -m mark ! --mark $(wg show %i fwmark) -m addrtype ! --dst-type LOCAL -j REJECT
      #   # '';

      #   # # This undoes the above command
      #   # postDown = ''
      #   #   ${pkgs.iptables}/bin/iptables -D OUTPUT ! -o %i -m mark ! --mark $(wg show %i fwmark) -m addrtype ! --dst-type LOCAL -j REJECT && ip6tables -D OUTPUT ! -o %i -m mark ! --mark $(wg show %i fwmark) -m addrtype ! --dst-type LOCAL -j REJECT
      #   # '';
      # };
    };
  };
}
