{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.nftables;
in {
  options.link.nftables.enable = mkEnableOption "activate nftables";
  config = mkIf cfg.enable {
    networking.nftables = {
      enable = true;
      tables = {
        # shaping = {
        #   enable = true;
        #   family = "inet";
        #   name = "shaping";
        #   content = ''
        #     chain postrouting {
        #         type route hook output priority -150; policy accept;
        #         ip daddr != 192.168.0.0/16 jump wan                               # non LAN traffic: chain wan
        #         ip daddr 192.168.0.0/16 meta length 1-64 meta priority set 1:11   # small packets in LAN: priority
        #       }
        #       chain wan {
        #         tcp dport 22 meta priority set 1:21 return                       # SSH traffic -> Internet: priority
        #         tcp dport { 27015, 27036 } meta priority set 1:21 return         # CS traffic -> Internet: priority
        #         udp dport { 27015, 27031-27036 } meta priority set 1:21 return   # CS traffic -> Internet: priority
        #         meta length 1-64 meta priority set 1:21 return                   # small packets -> Internet: priority
        #         meta priority set 1:20 counter                                   # default -> Internet: normal
        #       }
        #   '';
        # };
      };
    };
  };
}
