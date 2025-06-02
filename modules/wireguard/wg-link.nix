{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.wg-link;
in {
  options.link.wg-link.enable = mkEnableOption "activate wg-link";
  options.link.wg-link.address = mkOption { type = types.str; };
  config = mkIf cfg.enable {
    sops.secrets."wireguard-preshared" = { };
    # umask 077
    # mkdir ~/.wg-keys
    # wg genkey > ~/.wg-keys/private
    # wg pubkey < ~/.wg-keys/private > ~/.wg-keys/public

    # networking.extraHosts =
    #   ''
    #     10.0.1.1 linkserver.org
    #     10.0.1.1 jitsi.linkserver.org
    #     10.0.1.1 jellyfin.linkserver.org
    #     10.0.1.1 jellyseerr.linkserver.org
    #     10.0.1.1 gitea.linkserver.org
    #     10.0.1.1 paperless.linkserver.org
    #     10.0.1.1 hedgedoc.linkserver.org
    #     10.0.1.1 alinkbetweennets
    #     10.0.1.1 nextcloud.linkserver.org
    #     10.0.1.1 matrix.linkserver.org
    #     10.0.1.1 onlyoffice.linkserver.org
    #     10.0.1.1 vaultwarden.linkserver.org
    #     10.0.1.1 element.linkserver.org
    #     10.0.1.1 outline.linkserver.org
    #   '';
    networking.wg-quick.interfaces = {
      wg0 = {
        address = [
          cfg.address
          # "fdc9:281f:04d7:9ee9::2/64"
        ];
        dns = [
          "10.5.5.1"
          # "fdc9:281f:04d7:9ee9::1"
        ];
        privateKeyFile = "/root/.wg-keys/private";
        peers = [{
          publicKey = "gN/PG4h9+iuiVdv/J5XxX+PXghee9+FxfJP9M7lB9wU=";
          presharedKeyFile = config.sops.secrets."wireguard-preshared".path;
          allowedIPs = [
            "10.5.5.0/24"
            # "::/0"
          ];
          endpoint = "alinkbetweennets.de:51825";
          persistentKeepalive = 25;
        }];
      };
    };
  };
}
