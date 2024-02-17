{ lib, pkgs, config, ... }:
with lib;
let cfg = config.link.qmk;
in {
  options.link.qmk.enable = mkEnableOption "activate qmk containers";
  config = mkIf cfg.enable {
    services.udev.packages = with pkgs; [
      vial
      via
    ];
    environment.systemPackages = with pkgs; [
      via
      vial
      qmk
    ];
  };
}
