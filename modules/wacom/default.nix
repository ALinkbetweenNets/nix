{ lib, pkgs, config, ... }:
with lib;
let cfg = config.link.wacom;
in {
  options.link.wacom.enable = mkEnableOption "activate wacom";
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ wacomtablet xf86_input_wacom ];
    services.xserver.wacom.enable = !options.link.wayland;
  };
}
