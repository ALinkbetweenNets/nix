{ lib, pkgs, config, ... }:
with lib;
let cfg = config.link.plasma;
in {
  options.link.plasma.enable = mkEnableOption "activate plasma";
  config = mkIf cfg.enable {
    services = {
      displayManager.sddm = {
        enable = true;
        # wayland.enable = true;
        # theme = "/home/l/aerial-sddm-theme/";
        # theme= "breeze";
      };
      desktopManager.plasma6.enable = true;
    };
    environment.systemPackages = with pkgs; [
      kdePackages.sddm-kcm # sddm config module
      kdePackages.plasma-nm
      kdePackages.qtmultimedia
    ];
  };
}
