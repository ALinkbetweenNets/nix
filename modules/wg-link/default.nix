{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.wg-link;
in {
  options.link.wg-link.enable = mkEnableOption "activate wg-link";
  config = mkIf cfg.enable {
    networking.extraHosts =
      ''
        10.0.1.1 linkserver.org
        10.0.1.1 jitsi.linkserver.org
        10.0.1.1 jellyfin.alinkbetweennets.de
        10.0.1.1 jellyseer.alinkbetweennets.de
        10.0.1.1 gitea.alinkbetweennets.de
        10.0.1.1 paperless.alinkbetweennets.de
        10.0.1.1 hedgedoc.alinkbetweennets.de
        10.0.1.1 alinkbetweennets
        10.0.1.1 nextcloud.alinkbetweennets.de
        10.0.1.1 matrix.alinkbetweennets.de
        10.0.1.1 onlyoffice.alinkbetweennets.de
        10.0.1.1 vaultwarden.alinkbetweennets.de
        10.0.1.1 element.alinkbetweennets.de
        10.0.1.1 outline.alinkbetweennets.de
      '';
    services.dnsmasq.extraConfig = ''
      interface = wg-deep
    '';
    networking = {
      firewall = {
        allowedUDPPorts = [ 51821 ];
        checkReversePath = mkForce false;
      };
      wireguard.interfaces = {
        wg-link = {
          ips = [ "10.0.1.2/24" "fdc9:281f:04d7:9eea::2/64" ];
          # listenPort = 51821;
          # dns = [ "10.0.0.1" "fdc9:281f:04d7:9ee9::1" ];
          privateKeyFile = "${config.link.secrets}/wg-link-l.private";
          peers = [
            {
              publicKey = "9Hn/0/npzyZ+afzk0ux5oDvqjsbgLrrU9UC7qij13yE=";
              presharedKeyFile = "${config.link.secrets}/wg-link-l.preshared";
              allowedIPs = [ "10.0.1.0/24" "fdc9:281f:04d7:9eea::1/64" ];
              endpoint = "alinkbetweennets.de:51820";
              persistentKeepalive = 25;
            }
          ];
        };
      };
    };
  };
}
