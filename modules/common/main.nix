{ config, pkgs, lib, flake-self, ... }:
with lib;
let cfg = config.link.main;
in {
  options.link.main = { enable = mkEnableOption "activate main"; };
  config = mkIf cfg.enable {
    link = {
      desktop.enable = true;
      syncthing.enable = true;
      git-sync.enable = true;
      fs.ntfs.enable = true;
      tailscale.enable = true;
      qmk.enable = true;
    };
    boot = {
      extraModulePackages = with config.boot.kernelPackages;
      [ v4l2loopback ];
      kernelModules = [ "v4l2loopback" ];
    };
    services.rpcbind.enable = true; # for NFS
    # services.pcscd.enable = true; # smart card support
    services = {
      mullvad-vpn = {
        enable = true;
        package = pkgs.mullvad-vpn; # gui version
      };
      udev = {
        # packages = [ pkgs.android-udev-rules ];
        enable = true;
      };
    };
    environment.systemPackages = with pkgs; [
      flake-self.inputs.nsearch.packages.${pkgs.system}.default
      plasma5Packages.plasma-thunderbolt
      aha # for kde settings
      glxinfo
      clinfo
      vulkan-tools
      # ondsel # Better FreeCAD
      sshfs
      rclone
      ddcui
      ddcutil
    ];
    hardware.i2c.enable = true;
    users.groups.i2c = { };
    services.udev.packages = with pkgs; [ ddcutil ];
    hardware.hackrf.enable = true;
    programs = {
      noisetorch.enable = true;
      adb.enable = true;
      ausweisapp = {
        enable = true;
        openFirewall = true;
      };
    };
    # virtualisation.waydroid.enable = true;
    networking.firewall.allowedTCPPorts = [ 24800 ];
    # networking.networkmanager.appendNameservers = [
    #   "1.1.1.1"
    #   "192.168.178.1"
    #   "9.9.9.9"
    #   "216.146.35.35"
    #   "2620:fe::fe"
    #   "2606:4700:4700::1111"
    # ];
    # services.udev.extraRules = ''
    #   KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{serial}=="*vial:f64c2b3c*", MODE="0660", GROUP="$USER_GID", TAG+="uaccess", TAG+="udev-acl"
    #   KERNEL==\"hidraw*\", SUBSYSTEM==\"hidraw\", MODE=\"0660\", GROUP=\"$USER_GID\", TAG+=\"uaccess\", TAG+=\"udev-acl\"
    # '';
  };
}
