{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.dns;
in {
  options.link.dns.enable = mkEnableOption "activate dns";
  config = mkIf cfg.enable {
    link.unbound.enable = true;
    networking = {
      resolvconf.useLocalResolver = true;
      networkmanager.enable = true;
      networkmanager.dns = "systemd-resolved";
      search = [ "local" "monitor-banfish.ts.net" ];
    };
    # networking.nameservers = [
    #   # "127.0.0.1"
    #   "9.9.9.9"
    #   "192.168.250.1"
    #   "192.168.150.1"
    #   "100.100.100.100"
    #   "194.242.2.2"
    #   "1.0.0.1"
    # ];
    services.resolved = {
      enable = true;
      fallbackDns = [
        "127.0.0.2" # local unbound
        "194.242.2.4" # mullvad base
        "2a07:e340::4" # mullvad base
        "192.168.188.3" # npo
        "100.100.100.100" # tailscale
        "185.222.222.222" # dns.sb
        "45.11.45.11" # dns.sb
        "2a09::" # dns.sb
        "2a11::" # dns.sb
        "8.8.8.8" # google
        "1.0.0.1" # cloudflare
        "194.242.2.2" # mullvad
        "9.9.9.9" # quad9
        #"192.168.150.1" # sudo systemd-resolve --interface tun0 --set-dns 192.168.150.1
        "127.0.0.1"
      ];
      domains = [ "monitor-banfish.ts.net" ];
      dnssec = "false";
      dnsovertls = "false";
    };
    # services.dnsmasq = {
    #   enable = true;
    #   settings.server = [
    #     "9.9.9.9"
    #     "100.100.100.100"
    #     "192.168.250.1"
    #     "194.242.2.2"
    #     "192.168.150.1"
    #     "1.0.0.1"
    #   ];
    #   # extraConfig = ''
    #   #   DNSOverTLS=yes
    #   # '';
    # };

  };
}
