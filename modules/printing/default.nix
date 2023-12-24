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
    environment.systemPackages = with pkgs; [ skanpage ]; # Scanner Frontend
  };
}
