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

    networking.extraHosts = ''
      10.5.5.1 c
      10.5.5.2 f
      10.5.5.5 s
      10.5.5.6 n
    '';
    networking.wg-quick.interfaces = {
      wg-link = {
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
