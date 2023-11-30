{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.service.nfs;
in {
  options.link.service.nfs.enable = mkEnableOption "activate nfs service";
  config = mkIf cfg.enable {
    services = {
      nfs.server = {
        enable = true;
        # hostName = "sn";
        # createMountPoints = true;
        # statdPort = 4000;
        # lockdPort = 4001;
        # mountdPort = 4002;
        exports = ''
          /export *(rw,no_subtree_check,nohide)
        '';
      };
      rpcbind.enable = true;
      # For user-space mounting things like smb:// and ssh:// in thunar etc. Dbus
      # is required.
      gvfs = {
        enable = true;
        # Default package does not support all protocols. Use the full-featured
        # gnome version
        package = lib.mkForce pkgs.gnome3.gvfs;
      };
    };
  };
}
