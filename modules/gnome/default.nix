{ lib, pkgs, config, ... }:
with lib;
let cfg = config.link.gnome;
in {
  options.link.gnome.enable = mkEnableOption "activate gnome";
  config = mkIf cfg.enable {
    services.xserver = {
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };
  };
}
