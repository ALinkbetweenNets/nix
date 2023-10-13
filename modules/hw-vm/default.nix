{ config, flake-self, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.vm;
in {
  options.link.vm = { enable = mkEnableOption "activate vm"; };
  config = mkIf cfg.enable {
    link.common.enable = true;
    environment.systemPackages = with pkgs; [
      virtiofsd
    ];
  };
}
