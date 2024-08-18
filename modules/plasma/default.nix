{ lib, pkgs, config, ... }:
with lib;
let cfg = config.link.plasma;
in {
  options.link.plasma.enable = mkEnableOption "activate plasma";
  config = mkIf cfg.enable {
    services = {
      displayManager.sddm.enable = true;
      # desktopManager.plasma5.useQtScaling = true;
      desktopManager.plasma6.enable = true;
    };
    environment.systemPackages = with pkgs; [ kdePackages.plasma-nm ];
  };
}
