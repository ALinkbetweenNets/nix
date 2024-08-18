{ config, system-config, pkgs, lib, adblock-unbound, ... }:
with lib;
let
  cfg = config.link.unbound;
  adlist = adblock-unbound.packages.${pkgs.system};
  dns-overwrites-config = builtins.toFile "dns-overwrites.conf" (''
    # DNS overwrites
  '' + concatStringsSep "\n"
    (mapAttrsToList (n: v: ''local-data: "${n} A ${toString v}"'')
      cfg.A-records));
in {
  options.link.unbound = {
    enable = mkEnableOption "activate unbound";
    A-records = mkOption {
      type = types.attrs;
      default = {
        "iceportal.de" = "172.18.1.110";
        "pass.telekom.de" = "109.237.176.33";
        "smokeping.lounge.rocks" = "192.168.5.21";
        # "sn.link" = "10.0.1.1";
      };
      description = ''
        Custom DNS A records
      '';
    };
  };
  config = mkIf cfg.enable {
    networking.resolvconf.useLocalResolver = true;
    # networking.nameservers = [
    #   "127.0.0.1"
    #   "192.168.150.1"
    #   "::1"
    #   "100.100.100.100"
    #   "194.242.2.2"
    #   "9.9.9.9"
    #   "1.0.0.1"
    # ];
    services.resolved = {
      # enable = true;
      fallbackDns = [
        "127.0.0.1"
        # "192.168.150.1"
        "194.242.2.2"
        "100.100.100.100"
        # "192.168.178.1"
        "9.9.9.9"
        "1.0.0.1"
      ];
      domains = [ "monitor-banfish.ts.net" ];
    };
    networking.networkmanager.dns = lib.mkForce "systemd-resolved";
    services.unbound = {
      enable = true;
      localControlSocketPath = "/run/unbound/unbound.ctl";
      settings = {
        server = {
          include = [
            ''"${dns-overwrites-config}"''
            ''"${adlist.unbound-adblockStevenBlack}"''
          ];
          interface = [ "::1" "127.0.0.1" ];
          access-control = [ "127.0.0.0/8 allow" ];
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
          {
            name = "monitor-banfish.ts.net.";
            forward-addr = [ "100.100.100.100" ];
            forward-tls-upstream = "no";
          }
          {
            name = "mullvad.net.";
            forward-addr = [ "194.242.2.2@853#dns.mullvad.net" ];
            forward-tls-upstream = "yes";
          }
          {
            name = "google.*.";
            forward-addr =
              [ "8.8.8.8@853#dns.google" "8.8.8.4@853#dns.google" ];
            forward-tls-upstream = "yes";
          }
          {
            name = ".";
            forward-addr = [
              "100.100.100.100"
              "194.242.2.2"
              "9.9.9.9"
              "1.0.0.1@853#cloudflare-dns.com"
              "1.1.1.1@853#cloudflare-dns.com"
              "1.0.0.1"
            ];
            forward-first = "yes";
            forward-tls-upstream = "no";
          }
        ];
      };
    };
  };
}
