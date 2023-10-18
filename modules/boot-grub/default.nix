{ lib, pkgs, config, ... }:
with lib;
let cfg = config.link.grub;
in {
  options.link.grub.enable = mkEnableOption "activate grub";
  config = mkIf cfg.enable {
    boot.loader.grub = {
      enable = true;
      #efiSupport = true;
      # efiInstallAsRemovable = true;
      #useOSProber = true;
      configurationLimit = 50;
      memtest86.enable = true;
      theme = pkgs.nixos-grub2-theme;
      splashMode = "normal";
      #enableCryptodisk = true;
    };
  };
}
