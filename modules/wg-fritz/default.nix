{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.wg-fritz;
in {
  options.link.wg-fritz.enable = mkEnableOption "activate wg-fritz";
  config = mkIf cfg.enable {
    link.wireguard.enable = lib.mkDefault true;
    networking.wg-quick.interfaces.wg-fritz = {
      address = [ "192.168.178.205/24" ];
      dns = [ "192.168.178.1" "fritz.box" ];
      privateKeyFile = "/home/l/.keys/wg-fritz.private";
      peers = [{
        publicKeyFile = "/home/l/.keys/wg-fritz.public";
        allowedIPs = [ "192.168.178.0/24" "0.0.0.0/0" ];
        endpoint = "ur6qwb3amjjhe15h.myfritz.net:56355";
        persistentKeepalive = 25;
      }];
      postUp = ''
        ${pkgs.iptables}/bin/iptables -I OUTPUT ! -o %i -m mark ! --mark $(wg show %i fwmark) -m addrtype ! --dst-type LOCAL -j REJECT && ip6tables -I OUTPUT ! -o %i -m mark ! --mark $(wg show %i fwmark) -m addrtype ! --dst-type LOCAL -j REJECT
      '';
      postDown = ''
        ${pkgs.iptables}/bin/iptables -D OUTPUT ! -o %i -m mark ! --mark $(wg show %i fwmark) -m addrtype ! --dst-type LOCAL -j REJECT && ip6tables -D OUTPUT ! -o %i -m mark ! --mark $(wg show %i fwmark) -m addrtype ! --dst-type LOCAL -j REJECT
      '';
    };
  };
}
