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
        nssmdns = true;
        # for a WiFi printer
        openFirewall = true;
      };
      saned.enable = true;
      ipp-usb.enable = true;
    };
    hardware.sane = {
      enable = true;
      openFirewall = true;
      extraBackends = with pkgs; [ epkowa sane-airscan ];
    };
    users.users.l.extraGroups = [ "scanner" "lp" ];
    environment.systemPackages = with pkgs; [ skanpage ]; # Scanner Frontend
  };
}
