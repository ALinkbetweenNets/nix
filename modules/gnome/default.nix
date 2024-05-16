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
      xserver = {
        displayManager.gdm.enable = true;
        desktopManager.gnome.enable = true;
      };
    };
    services.gnome = {
      gnome-keyring.enable = true;
      gnome-user-share.enable = true;
      gnome-online-miners.enable = true;
      core-utilities.enable = true;
      gnome-settings-daemon.enable = true;
      core-shell.enable = true;
      core-os-services.enable = true;
      sushi.enable = true;
    };
    environment.systemPackages = with pkgs; [
      gnomeExtensions.gtile
      gnomeExtensions.zen
      gnomeExtensions.yks-timer
      gnomeExtensions.window-on-top
      gnomeExtensions.wifi-qrcode
      gnomeExtensions.weeks-start-on-monday-again
      gnomeExtensions.gsconnect
    ];
    qt.platformTheme = "gnome";
  };
}
