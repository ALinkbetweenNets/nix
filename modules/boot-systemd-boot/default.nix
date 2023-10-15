{ lib, pkgs, config, ... }:
with lib;
let cfg = config.link.systemd-boot;
in {
  options.link.systemd-boot.enable = mkEnableOption "activate systemd-boot";
  config = mkIf cfg.enable {
    boot.loader.systemd-boot = {
      enable = true;
      configurationLimit = 50;
      memtest86.enable = true;
      #consoleMode = true;
    };
  };
}
