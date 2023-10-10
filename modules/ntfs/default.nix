{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.ntfs;
in {
  options.link.ntfs.enable = mkEnableOption "activate ntfs";
  config = mkIf cfg.enable { boot.supportedFilesystems = [ "ntfs" ]; };
}
