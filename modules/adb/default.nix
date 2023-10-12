{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.adb;
in {
  options.link.adb.enable = mkEnableOption "activate adb";
  config = mkIf cfg.enable {
    programs.adb.enable = true;
    services.udev.packages = [ pkgs.android-udev-rules ];
    services.udev.enable = true;
  };
}
