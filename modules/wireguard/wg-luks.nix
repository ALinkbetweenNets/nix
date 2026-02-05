{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.wg-luks;
in {
  options.link.wg-luks.enable = mkEnableOption "activate wg-luks";
  options.link.wg-luks.address = mkOption { type = types.str; };
  config = mkIf cfg.enable {
    sops.secrets."wg-luks-preshared" = { };
    # umask 077
    # mkdir ~/.wg-keys
    # wg genkey > ~/.wg-keys/private
    # wg pubkey < ~/.wg-keys/private > ~/.wg-keys/public

    networking.extraHosts = ''
      10.5.6.1 c
      10.5.6.2 f
      10.5.6.5 s
      10.5.6.6 n
    '';
    networking.wg-quick.interfaces = {
      wg-luks = {
        address = [
          cfg.address
          # "fdc9:281f:04d7:9ee9::2/64"
        ];
        dns = [
          "10.5.6.1"
          # "fdc9:281f:04d7:9ee9::1"
        ];
        privateKeyFile = "/root/.wg-keys/wg-luks-private";
        peers = [{
          publicKey = "hjf54ME7BqSgHIXTPTNu/aZ4uGPR5qc79weJJxJ1qjE=";
          presharedKeyFile = config.sops.secrets."wg-luks-preshared".path;
          allowedIPs = [
            "10.5.6.0/24"
            # "0.0.0.0/0"
            # "::/0"
          ];
          endpoint = "202.61.251.70:51826";
          persistentKeepalive = 25;
        }];
      };
    };
  };
}
