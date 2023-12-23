{ config, system-config, pkgs, lib, adblock-unbound, ... }:
with lib;
let
  cfg = config.link.unbound;
  adlist = adblock-unbound.packages.${pkgs.system};
  dns-overwrites-config = builtins.toFile "dns-overwrites.conf" (''
    # DNS overwrites
  '' + concatStringsSep "\n"
    (mapAttrsToList (n: v: "local-data: \"${n} A ${toString v}\"") cfg.A-records));
in
{
  options.link.unbound = {
    enable = mkEnableOption "activate unbound";
    A-records = mkOption {
      type = types.attrs;
      default = {
        "iceportal.de" = "172.18.1.110";
        "nas.mh0.eu" = "192.168.42.10";
        "pass.telekom.de" = "109.237.176.33";
        "smokeping.lounge.rocks" = "192.168.5.21";
        "status.nik-ste.de" = "10.88.88.1";
      };
      description = ''
        Custom DNS A records
      '';
    };
  };
  config = mkIf cfg.enable {
    services.unbound = {
      enable = true;
      settings = {
        server = {
          include = [
            "\"${dns-overwrites-config}\""
            "\"${adlist.unbound-adblockStevenBlack}\""
          ];
          interface = [
            "127.0.0.1"
            "10.0.0.2"
            "10.0.1.2"
          ];
          access-control = [
            "127.0.0.0/8 allow"
            "192.168.0.0/16 allow"
            "10.0.0.0/24 allow"
            "10.0.1.0/24 allow"
          ];
        };

        # forward local DNS requests via Wireguard
        # domain-insecure = [ "haus" ];
        # stub-zone = [
        #   {
        #     name = "haus";
        #     stub-addr = "10.88.88.4";
        #   }
        # ];

        forward-zone = [
          # {
          #   name = "too-many-tb.de.";
          #   forward-addr = [
          #     "10.88.88.2"
          #   ];
          #   forward-tls-upstream = "no";
          # }
          {
            name = "google.*.";
            forward-addr = [
              "8.8.8.8@853#dns.google"
              "8.8.8.4@853#dns.google"
            ];
            forward-tls-upstream = "yes";
          }
          {
            name = ".";
            forward-addr = [
              "1.0.0.1@853#cloudflare-dns.com"
              "1.1.1.1@853#cloudflare-dns.com"
            ];
            forward-tls-upstream = "yes";
          }
        ];

      };
    };
  };
}
