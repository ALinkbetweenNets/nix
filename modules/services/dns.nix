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
        "127.0.0.2"
        "127.0.0.1"
        "8.8.8.8"
        "1.0.0.1"
        "100.100.100.100"
        "194.242.2.2"
        "9.9.9.9"
        "192.168.150.1" # sudo systemd-resolve --interface tun0 --set-dns 192.168.150.1
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
