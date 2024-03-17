{ lib, pkgs, config, ... }:
with lib;
let cfg = config.link.plasma;
in {
  options.link.plasma.enable = mkEnableOption "activate plasma";
  config = mkIf cfg.enable {
    services.xserver = {
      displayManager.sddm.enable = true;
      desktopManager.plasma6.enable = true;
      # desktopManager.plasma5.useQtScaling = true;
    };
    environment.systemPackages = with pkgs;[ kdePackages.plasma-nm ];
  };
}
