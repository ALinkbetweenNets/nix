{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.services.nfs;
in {
  options.link.services.nfs.enable = mkEnableOption "activate nfs service";
  config = mkIf cfg.enable {
    services = {
      nfs.server = {
        enable = true;
        hostName = "sn";
        # createMountPoints = true;
        statdPort = 4000;
        lockdPort = 4001;
        mountdPort = 4002;
        exports = ''
          /rz xn.monitor-banfish.ts.net(rw,no_subtree_check,nohide,insecure,sync,crossmnt,fsid=0)
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
    networking.firewall.interfaces."tailscale0".allowedTCPPorts =
      [ 111 2049 4000 4001 4002 20048 ];
    networking.firewall.interfaces."tailscale0".allowedUDPPorts =
      [ 111 2049 4000 4001 4002 20048 ];
  };
}
