{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.services.dns;
in {
  options.link.services.dns.enable = mkEnableOption "activate services.dns";
  config = mkIf cfg.enable {
    networking.hosts = { "192.168.178.110" = [ "sn.fritz.box" "paperless.sn.fritz.box" ]; };
    services = {
      dnsmasq = {
        enable = true;
        settings.server = [ "9.9.9.9" "1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one" "8.8.8.8" ];
        # extraConfig = ''
        #   DNSOverTLS=yes
        # '';
      };
    };
  };
}
