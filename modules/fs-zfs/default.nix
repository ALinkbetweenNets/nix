{ lib, pkgs, config, ... }:
with lib;
let cfg = config.link.zfs;
in {
  options.link.zfs.enable = mkEnableOption "activate zfs";
  config = mkIf cfg.enable {
    boot.loader.grub.zfsSupport = true;
    services.zfs.autoScrub.enable = true;
    services.zfs.trim.enable = true;
    boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
    boot.supportedFilesystems = [ "zfs" ];
    #virtualisation.docker.storageDriver = "zfs";
    boot.zfs.forceImportRoot = true;
    boot.zfs.forceImportAll = true;
  };

}
