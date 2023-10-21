{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.nfs;
in {
  options.link.nfs.enable = mkEnableOption "activate nfs";
  config = mkIf cfg.enable {
  };
}
