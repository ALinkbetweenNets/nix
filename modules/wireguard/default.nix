{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.wireguard;
in {
  options.link.wireguard.enable = mkEnableOption "activate wireguard";
  config = mkIf cfg.enable {
    networking = {
      wireguard.enable = true;
      firewall = {
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
    };
  };
}
