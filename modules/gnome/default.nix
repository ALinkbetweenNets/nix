{ lib, pkgs, config, ... }:
with lib;
let cfg = config.link.gnome;
in {
  options.link.gnome.enable = mkEnableOption "activate gnome";
  config = mkIf cfg.enable {
    programs = {
      gnome-terminal.enable = true;
      gnome-disks.enable = true;
      file-roller.enable = true;
      calls.enable = true;
    };
    services = {
      udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];
      xserver = {
        displayManager.gdm.enable = true;
        desktopManager.gnome.enable = true;
      };
      gnome = {
        gnome-keyring.enable = true;
        gnome-user-share.enable = true;
        core-utilities.enable = true;
        gnome-settings-daemon.enable = true;
        core-shell.enable = true;
        core-os-services.enable = true;
        sushi.enable = true;
      };
    };
    environment.systemPackages = with pkgs; [
      gnomeExtensions.appindicator
      gnomeExtensions.gsconnect
      gnomeExtensions.gtile
      gnomeExtensions.weeks-start-on-monday-again
      gnomeExtensions.wifi-qrcode
      gnomeExtensions.window-gestures
      gnomeExtensions.window-on-top
      gnomeExtensions.yks-timer
      gnomeExtensions.zen
    ];
    qt.platformTheme = "gnome";
  };
}
