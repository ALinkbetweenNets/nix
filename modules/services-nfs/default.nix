{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.nfs;
in {
  options.link.nfs.enable = mkEnableOption "activate nfs";
  config = mkIf cfg.enable {
    services.  nfs.server = {
      enable = true;
      # hostName = "sn";
      createMountPoints = true;
      statdPort = 4000;
      lockdPort = 4001;
      mountdPort = 4002;
      exports = ''
        /export *(rw,no_subtree_check,insecure)
      '';
    };
    rpcbind.enable = true;
  };
}
