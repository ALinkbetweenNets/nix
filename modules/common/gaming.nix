{ config, pkgs, lib, ... }:
with lib;
let cfg = config.link.gaming;
in {
  options.link.gaming = { enable = mkEnableOption "activate gaming"; };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs;
      [
        looking-glass-client # KVM relay
        # (wine.override { wineBuild = "wine64"; })
        # wineWowPackages.staging
        # winetricks
        #wine
        #wineWowPackages.waylandFull
      ];
    programs = {
      steam.enable = true;
      steam.gamescopeSession.enable = true;
      gamescope.capSysNice = true;
      gamescope.enable= true;
    };
  };
}
