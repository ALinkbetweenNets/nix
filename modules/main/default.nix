{ config, pkgs, lib, ... }:
with lib;
let cfg = config.link.main;
in {
  options.link.main = { enable = mkEnableOption "activate main"; };
  config = mkIf cfg.enable {
    link = {
      desktop.enable = true;
      printing.enable = lib.mkIf config.link.office.enable true;
      syncthing.enable = true;
      git-sync.enable = true;
      fs.ntfs.enable = true;
      oneko.enable = true;
    };
    services = {
      mullvad-vpn = {
        enable = true;
        package = pkgs.mullvad-vpn;
      };
      udev = {
        # packages = [ pkgs.android-udev-rules ];
        enable = true;
      };
    }; # gui version
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
    services.tailscale = {
      enable = true;
      useRoutingFeatures = "client";
    };
    networking.networkmanager.appendNameservers = [
      "1.1.1.1"
      "192.168.178.1"
      "9.9.9.9"
      "216.146.35.35"
      "2620:fe::fe"
      "2606:4700:4700::1111"
    ];

  };
}
