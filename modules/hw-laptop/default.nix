{ config, flake-self, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.laptop;
in
{
  options.link.laptop = {
    enable = mkEnableOption "activate laptop";
  };
  config = mkIf cfg.enable {
    link.desktop.enable = true;
    link.hardware.enable = true;
    #options.type = "laptop";
    networking.wireless.enable = !config.networking.networkmanager.enable;
    services.xserver.libinput.enable = true;
  };
}

