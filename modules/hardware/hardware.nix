{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.hardware;
in {
  options.link.hardware.enable = mkEnableOption "activate hardware";
  config = mkIf cfg.enable {
    link.libvirt.enable = lib.mkDefault true;
    environment.systemPackages = with pkgs; [ nvtop powertop ];
    time.hardwareClockInLocalTime = true;
    services = {
      # for windows dualboot
      # hardware.enableRedistributableFirmware = true;
      fwupd.enable = true;
      thermald.enable = true;
      smartd.enable = true;
      ddccontrol.enable = true; # Control External Monitor Brightness
      udisks2.enable = true;
    };
    hardware = {
      enableAllFirmware = true;
      sensor.hddtemp = {
        enable = true;
        drives = [ "/dev/disk/by-id/*" ];
      };
    };

  };
}
