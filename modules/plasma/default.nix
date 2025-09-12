{ lib, pkgs, config, ... }:
with lib;
let cfg = config.link.plasma;
in {
  options.link.plasma.enable = mkEnableOption "activate plasma";
  config = mkIf cfg.enable {
    services = {
      displayManager.sddm = {
        enable = true;
        wayland.enable = true;
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
    i18n.inputMethod = {
      type = "fcitx5";
      enable = true;
      fcitx5.waylandFrontend= true;
      fcitx5.addons = with pkgs; [ fcitx5-mozc fcitx5-gtk ];
    };
  };
}
