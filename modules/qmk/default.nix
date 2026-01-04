{ lib, pkgs, config, ... }:
with lib;
let cfg = config.link.qmk;
in {
  options.link.qmk.enable = mkEnableOption "activate qmk containers";
  config = mkIf cfg.enable {
    hardware.keyboard.qmk.enable = true;
    services.udev.packages = with pkgs; [
      vial
      # via
      qmk-udev-rules
    ];
    environment.systemPackages = with pkgs; [
      # via
      vial
      qmk
      dos2unix # qmk dependency
    ];
  };
}
