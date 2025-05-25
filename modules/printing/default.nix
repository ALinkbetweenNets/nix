{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.printing;
in {
  options.link.printing.enable = mkEnableOption "activate printing";
  config = mkIf cfg.enable {
    services = {
      printing = {
        # CUPS
        enable = true;
        drivers = with pkgs; [ hplip ];
      };
      avahi = {
        enable = true;
        nssmdns4 = true;
        # for a WiFi printer
        openFirewall = true;
      };
      saned.enable = true; # port 6566
      ipp-usb.enable = true;
    };
    hardware.sane = {
      enable = true;
      openFirewall = true;
      extraBackends = with pkgs; [ epkowa sane-airscan ];
    };
    networking.firewall.allowedTCPPorts = [
      139
      443
      445
      515
      53
      631
      631
      6566
      9100
      9101
      9102
    ]; # https://www.cups.org/doc/firewalls.html
    networking.firewall.allowedUDPPorts = [ 53 137 5353 ];
    environment.systemPackages = with pkgs; [ kdePackages.skanpage ]; # Scanner Frontend
  };
}
