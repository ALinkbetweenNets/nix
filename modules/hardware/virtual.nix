{ config, flake-self, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.vm;
in {
  options.link.vm = { enable = mkEnableOption "activate vm"; };
  config = mkIf cfg.enable {
    link.common.enable = true;
    environment.systemPackages = with pkgs; [ virtiofsd ];
    services.qemuGuest.enable = true;
    fileSystems."/".autoResize = true;
    boot.growPartition = true;
    services.fstrim = {
      enable = true;
      interval = "weekly";
    };
    boot.initrd = {
      availableKernelModules = [
        "virtio_net"
        "virtio_pci"
        "virtio_mmio"
        "virtio_blk"
        "virtio_scsi"
        "9p"
        "9pnet_virtio"
      ];
      kernelModules = [ "virtio_balloon" "virtio_console" "virtio_rng" ];
    };
  };
}
