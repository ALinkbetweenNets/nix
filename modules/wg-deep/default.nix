{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.wg-deep;
in {
  options.link.wg-deep.enable = mkEnableOption "activate wg-deep";
  config = mkIf cfg.enable {
    # networking.extraHosts =
    #   ''
    #     10.0.0.1 deepserver.org
    #     10.0.0.1 jitsi.deepserver.org
    #   '';
    services.dnsmasq.extraConfig = ''
      interface=wg-deep
    '';
    networking = {
      extraHosts =
        ''
          10.0.0.1 nextcloud.deepserver.org
          10.0.0.1 matrix.deepserver.org
          10.0.0.1 hedgedoc.deepserver.org
          10.0.0.1 onlyoffice.deepserver.org
          10.0.0.1 vaultwarden.deepserver.org
          10.0.0.1 element.deepserver.org
        '';
      firewall = {
        allowedUDPPorts = [ 51820 ];
        checkReversePath = mkForce false;
      };
      wireguard.interfaces = {
        wg-deep = {
          ips = [ "10.0.0.2/24" "fdc9:281f:04d7:9ee9::2/64" ];
          listenPort = 51820;
          # dns = [ "10.0.0.1" "fdc9:281f:04d7:9ee9::1" ];
          privateKeyFile = "${config.link.secrets}/wg-deep-l.private";
          peers = [
            {
              publicKey = "ooLa+0mcWwO4yEFwpKotfTiBei5+aTW1Xxfk4Ye0kzs=";
              presharedKeyFile = "${config.link.secrets}/wg-deep-l.preshared";
              allowedIPs = [ "10.0.0.0/24" "fdc9:281f:04d7:9ee9::1/64" ];
              endpoint = "deepserver.org:51820";
              persistentKeepalive = 25;
            }
          ];
        };
      };
    };
  };
}
