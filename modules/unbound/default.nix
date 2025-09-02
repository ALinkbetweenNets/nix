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
in
{
  options.link.unbound = {
    enable = mkEnableOption "activate unbound";
    A-records = mkOption {
      type = types.attrs;
      default = {
        "iceportal.de" = "172.18.1.110";
        "pass.telekom.de" = "109.237.176.33";
        "smokeping.lounge.rocks" = "192.168.5.21";
        "c" = "10.5.5.1";
        "f" = "10.5.5.2";
        "n" = "10.5.5.6";
        "s" = "10.5.5.5";
      };
      description = ''
        Custom DNS A records
      '';
    };
  };
  config = mkIf cfg.enable {
    # link.dns.enable = lib.mkDefault true;
    services.unbound = {
      enable = true;
      localControlSocketPath = "/run/unbound/unbound.ctl";
      resolveLocalQueries = false;
      settings = {
        server = {
          include = [
            ''"${dns-overwrites-config}"''
            ''"${adlist.unbound-adblockStevenBlack}"''
          ];
          interface = [ "::1" "127.0.0.2" ];
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
              # "192.168.1.1"
              # "192.168.178.1"
              "194.242.2.4" # mullvad base
              "2a07:e340::4" # mullvad base
              # "192.168.188.3" # npo
              "100.100.100.100" # tailscale
              "185.222.222.222" # dns.sb
              "45.11.45.11" # dns.sb
              "2a09::" # dns.sb
              "2a11::" # dns.sb
              "9.9.9.9" # quad9
              "8.8.8.8" # google
              "1.0.0.1" # cloudflare
              "194.242.2.2" # mullvad
            ];
            forward-first = "yes";
            forward-tls-upstream = "no";
          }
        ];
      };
    };
  };
}
