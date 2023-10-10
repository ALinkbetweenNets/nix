{ lib, pkgs, config, ... }:
with lib;
let cfg = config.link.btrfs;
in {
  options.link.btrfs.enable = mkEnableOption "activate btrfs";
  config = mkIf cfg.enable {
    boot.initrd.supportedFilesystems=["btrfs"];

  };
}
