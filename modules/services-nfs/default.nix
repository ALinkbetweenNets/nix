{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.nextcloud;
in {
  options.link.nextcloud.enable = mkEnableOption "activate nextcloud";
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
