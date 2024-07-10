{ lib, pkgs, config, ... }:
with lib;
let cfg = config.link.fs.btrfs;
in {
  options.link.fs.btrfs.enable = mkEnableOption "activate btrfs";
  config = mkIf cfg.enable {
    boot.initrd.supportedFilesystems = [ "btrfs" ];
    virtualisation.docker.storageDriver = lib.mkForce "btrfs";
    services.btrfs.autoScrub = {
      enable = true;
      interval = "weekly";
      fileSystems = [ "/" ];
    };
    # fileSystems = { "/".options = [ "compress=zstd" ]; };
  };
}
