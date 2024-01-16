{ config, pkgs, lib, ... }:
with lib;
let cfg = config.link.main;
in {
  options.link.main = { enable = mkEnableOption "activate main"; };
  config = mkIf cfg.enable {
    link = {
      desktop.enable = true;
      syncthing.enable = true;
      git-sync.enable = true;
      fs.ntfs.enable = true;
      unbound.enable = true;
      tailscale.enable = true;
    };
    services = {
      mullvad-vpn = {
        enable = true;
        package = pkgs.mullvad-vpn; # gui version
      };
      udev = {
        # packages = [ pkgs.android-udev-rules ];
        enable = true;
      };
    };
    environment.systemPackages = with pkgs; [
      #wine
      (wine.override { wineBuild = "wine64"; })
      wineWowPackages.staging
      winetricks
      #wineWowPackages.waylandFull
    ];
    programs = {
      noisetorch.enable = true;
      adb.enable = true;
      steam.enable = true;
      steam.gamescopeSession.enable = true;
    };
    networking.networkmanager.appendNameservers = [
      "1.1.1.1"
      "192.168.178.1"
      "9.9.9.9"
      "216.146.35.35"
      "2620:fe::fe"
      "2606:4700:4700::1111"
    ];
    services.udev.extraRules = ''
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{serial}=="*vial:f64c2b3c*", MODE="0660", GROUP="$USER_GID", TAG+="uaccess", TAG+="udev-acl"
      KERNEL==\"hidraw*\", SUBSYSTEM==\"hidraw\", MODE=\"0660\", GROUP=\"$USER_GID\", TAG+=\"uaccess\", TAG+=\"udev-acl\"
    '';
  };
}
