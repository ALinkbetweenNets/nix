{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.hardware;
in {
  options.link.hardware.enable = mkEnableOption "activate hardware";
  config = mkIf cfg.enable {
    link.libvirt.enable = lib.mkDefault true;
    environment.systemPackages = with pkgs;
      [
        # powertop
        lm_sensors
        cpufrequtils
      ] ++ lib.optionals (config.link.desktop.enable) [ cpupower-gui ];
    time.hardwareClockInLocalTime = true;
    services = {
      # for windows dualboot
      # hardware.enableRedistributableFirmware = true;
      fwupd.enable =
        config.link.systemd-boot.enable; # fwupd does not work in BIOS mode
      thermald.enable = true;
      smartd.enable = lib.mkDefault true;
      ddccontrol.enable = true; # broken # Control External Monitor Brightness
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
