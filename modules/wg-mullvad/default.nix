{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.wg-mullvad;
in {
  options.link.wg-mullvad.enable = mkEnableOption "activate wg-mullvad";
  config = mkIf cfg.enable {
    link.wireguard.enable = lib.mkDefault true;
    networking.wg-quick.interfaces.wg-mullvad = {
      wg-mullvad = {
        address = [ "10.64.253.12/32" "fc00:bbbb:bbbb:bb01::1:fd0b/128" ];
        dns = [ "100.64.0.1" ];
        listenPort = 51821;
        postUp = ''
          ${pkgs.iptables}/bin/iptables -I OUTPUT ! -o %i -m mark ! --mark $(wg show %i fwmark) -m addrtype ! --dst-type LOCAL -j REJECT && ip6tables -I OUTPUT ! -o %i -m mark ! --mark $(wg show %i fwmark) -m addrtype ! --dst-type LOCAL -j REJECT
        '';
        postDown = ''
          ${pkgs.iptables}/bin/iptables -D OUTPUT ! -o %i -m mark ! --mark $(wg show %i fwmark) -m addrtype ! --dst-type LOCAL -j REJECT && ip6tables -D OUTPUT ! -o %i -m mark ! --mark $(wg show %i fwmark) -m addrtype ! --dst-type LOCAL -j REJECT
        '';
        privateKeyFile = "/home/l/.keys/wg-mullvad.private";

        peers = [{
          publicKeyFile = "/home/l/.keys/wg-mullvad.public";
          allowedIPs = [ "0.0.0.0/0" "::0/0" ];
          endpoint =
            "185.254.75.5:3124";
          persistentKeepalive = 25;
        }];
      };
    };
  };
}
