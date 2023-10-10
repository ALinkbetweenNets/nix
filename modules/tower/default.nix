{ config, flake-self, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.tower;
in
{
  options.link.tower = {
    enable = mkEnableOption "activate tower laptop";
  };
  config = mkIf cfg.enable {
    link.hardware.enable = true;
    link.desktop.enable = true;

  };
}

