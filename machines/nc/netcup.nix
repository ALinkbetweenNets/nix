{ pkgs, lib, config, ... }:
let
  primaryDisk = "/dev/vda";
in
{
  config = {
    # Running fstrim weekly is a good idea for VMs.
    # Empty blocks are returned to the host, which can then be used for other VMs.
    # It also reduces the size of the qcow2 image, which is good for backups.
    services.fstrim = {
      enable = true;
      interval = "weekly";
    };
    # We want to standardize our partitions and bootloaders across all providers.
    # -> BIOS boot partition
    # -> EFI System Partition
    # -> NixOS root partition (ext4)
    disko.devices.disk.main = {
      type = "disk";
      device = primaryDisk;
      content = {
        type = "gpt";
        partitions = {
          boot = {
            start = "0";
            end = "1M";
          };
          ESP = {
            start = "1M";
            end = "512M";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };
          root = {
            start = "512M";
            end = "100%";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
            };
          };
        };
      };
    };
    # During boot, resize the root partition to the size of the disk.
    # This makes upgrading the size of the vDisk easier.
    fileSystems."/".autoResize = true;
    boot.growPartition = true;
    boot = {
      loader = {
        timeout = 10;
        grub = {
          devices = [ primaryDisk ];
          efiSupport = true;
          efiInstallAsRemovable = true;
        };
      };
      initrd = {
        availableKernelModules = [ "virtio_net" "virtio_pci" "virtio_mmio" "virtio_blk" "virtio_scsi" "9p" "9pnet_virtio" ];
        kernelModules = [ "virtio_balloon" "virtio_console" "virtio_rng" ];
      };
      kernelParams = [ "console=ttyS0" ];
    };
    # Currently all our providers use KVM / QEMU
    services.qemuGuest.enable = true;
  };
}
