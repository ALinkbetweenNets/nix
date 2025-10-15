{ config, flake-self, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.convertible;
in {
  options.link.convertible = {
    enable = mkEnableOption "activate convertible laptop";
  };
  config = mkIf cfg.enable {
    link.laptop.enable = true;
    hardware.sensor.iio.enable = true;
    services.xserver.wacom.enable = mkIf config.link.xserver.enable true;
    environment.systemPackages = with pkgs; [
      kdePackages.wacomtablet
      xf86_input_wacom
      maliit-keyboard
    ];
  };
}
