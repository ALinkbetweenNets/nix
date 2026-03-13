{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.link.fs.zfs;
in
{
  options.link.fs.zfs.enable = mkEnableOption "activate zfs";
  config = mkIf cfg.enable {
    services.zfs = {
      autoScrub.enable = true;
      trim.enable = true;
      expandOnBoot = "all";
      # autoReplication.enable = true;
      # zed.enableMail = true;
      # zed.settings = {
      #   ZED_DEBUG_LOG = "/tmp/zed.debug.log";

      #   ZED_EMAIL_ADDR = [ "root" ];
      #   ZED_EMAIL_PROG = "mail";
      #   ZED_EMAIL_OPTS = "-s '@SUBJECT@' @ADDRESS@";

      #   ZED_NOTIFY_INTERVAL_SECS = 3600;
      #   ZED_NOTIFY_VERBOSE = false;
      #   ZED_SCRUB_AFTER_RESILVER = false;
      # };
    };
    security.pam.zfs.enable = true;
    boot = {
      loader.grub.zfsSupport = true;
      # kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
      supportedFilesystems.zfs = true;
      zfs = {
        #virtualisation.docker.storageDriver = "zfs";
        forceImportRoot = false;
        # forceImportAll = true;
        # package.enableMail = true;
      };
    };
  };
}
