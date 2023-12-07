{ lib, pkgs, config, ... }:
with lib;
let cfg = config.link.plasma;
in {
  options.link.plasma.enable = mkEnableOption "activate plasma";
  config = mkIf cfg.enable {
    services.xserver = {
      displayManager.sddm.enable = true;
      desktopManager.plasma5.enable = true;
    };
    environment.systemPackages = with pkgs;[ libsForQt5.plasma-nm ];
  };
}
