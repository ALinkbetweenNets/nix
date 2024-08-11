{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.fs.ntfs;
in {
  options.link.fs.ntfs.enable = mkEnableOption "activate ntfs";
  config = mkIf cfg.enable { boot.supportedFilesystems = [ "ntfs" ]; };
}
