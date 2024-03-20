{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.services.dns;
in {
  options.link.services.dns.enable = mkEnableOption "activate services.dns";
  config = mkIf cfg.enable {
    services = {
      dnsmasq = {
        enable = true;
        settings.server = [ "9.9.9.9" "1.1.1.1" "1.0.0.1" "8.8.8.8" ];
        # extraConfig = ''
        #   DNSOverTLS=yes
        # '';
      };
    };
  };
}
