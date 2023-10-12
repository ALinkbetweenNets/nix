{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.hardware;
in {
  options.link.hardware.enable = mkEnableOption "activate hardware";
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ nvtop powertop ];

    boot = {
      plymouth = {
        enable = true;
        theme = "breeze";
      };
      initrd.systemd.enable = true;
      loader = {
        systemd-boot = {
          enable = true;
          memtest86.enable = true;
        };
        efi.canTouchEfiVariables = true;
      };
      tmp.cleanOnBoot = true;
      kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
    };
    time.hardwareClockInLocalTime = true; # for windows dualboot
    # hardware.enableRedistributableFirmware = true;
    services = {
      fwupd.enable = true;
      thermald.enable = true;
      smartd.enable = true;
      ddccontrol.enable = true;
      udisks2.enable = true;
    };
    hardware = {
      enableAllFirmware = true;
      sensor.hddtemp = {
        enable = true;
        drives = [ "/dev/disk/by-id/*" ];
      };
    };
    powerManagement = {
      enable = true;
      powertop.enable = true;
    }; # Control External Monitor Brightness
  };
}
