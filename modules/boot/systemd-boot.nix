{ lib, pkgs, config, ... }:
with lib;
let cfg = config.link.systemd-boot;
in {
  options.link.systemd-boot.enable = mkEnableOption "activate systemd-boot";
  config = mkIf cfg.enable {
    boot = {
      tmp.cleanOnBoot = true;
      kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
      loader = {
        efi.canTouchEfiVariables = lib.mkDefault true;
        systemd-boot = {
          enable = true;
          configurationLimit = 64;
          memtest86.enable = true;
          #consoleMode = true;
        };
      };
    };
  };
}
