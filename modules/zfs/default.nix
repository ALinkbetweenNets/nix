{ lib, pkgs, config, ... }:
with lib;
let cfg = config.link.zfs;
in {
  options.link.zfs.enable = mkEnableOption "activate zfs";
  config = mkIf cfg.enable { boot.loader.grub.zfsSupport = true; };
}
