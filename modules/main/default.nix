{ config, flake-self, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.main;
in {
  options.link.main = { enable = mkEnableOption "activate main"; };
  config = mkIf cfg.enable {
    link = {
      desktop.enable = true;
      adb.enable = true;
      printing.enable = lib.mkIf config.link.office.enable true;
      syncthing.enable = true;
      git-sync.enable = true;
      ntfs.enable = true;
    };
    services.mullvad-vpn.enable = true;
    services.mullvad-vpn.package = pkgs.mullvad-vpn; # gui version
    environment.systemPackages = with pkgs; [
      #wine
      (wine.override { wineBuild = "wine64"; })
      wineWowPackages.staging
      winetricks
      #wineWowPackages.waylandFull
    ];

  };
}
