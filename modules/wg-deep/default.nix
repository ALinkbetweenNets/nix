{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.wg-deep;
in {
  options.link.wg-deep.enable = mkEnableOption "activate wg-deep";
  config = mkIf cfg.enable {
    link.wireguard.enable = lib.mkDefault true;
    networking.wg-quick.interfaces.wg-deep = {
      address = [ "10.0.1.4/32" ];
      mtu = 1392;
      listenPort = 51820;
      privateKeyFile = "/home/l/.keys/wg-deep.private";

      peers = [{
        presharedKeyFile = "/home/l/.keys/wg-deep.preshared";
        publicKey = "8nalsPno9P+SDoHQRcb7T27LXCM9191XgJyszKSWPkg=";
        allowedIPs = [ "10.0.1.0/24" "10.0.0.0/24" ];
        endpoint =
          "65.109.157.99:51820";
        persistentKeepalive = 25;
      }];
    };
  };
}
