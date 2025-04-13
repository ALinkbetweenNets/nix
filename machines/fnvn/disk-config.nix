{ pkgs, lib, config, ... }:
let primaryDisk = "/dev/vda";
in {
  config = {
    # Running fstrim weekly is a good idea for VMs.
    # Empty blocks are returned to the host, which can then be used for other VMs.
    # It also reduces the size of the qcow2 image, which is good for backups.

    # We want to standardize our partitions and bootloaders across all providers.
    # -> BIOS boot partition
    # -> EFI System Partition
    # -> NixOS root partition (ext4)
    # swapDevices = [{
    #   device = "/.swapfile";
    #   size = 8 * 1024;
    # }];
    disko = {
      devices.disk.main = {
        type = "disk";
        device = primaryDisk;
        content = {
          type = "gpt";
          partitions = {
            # boot = {
            #   size = "1M";
            #   type = "EF02"; # for grub MBR
            # };
            ESP = {
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "defaults" ];
              };
            };
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "crypted";
                # disable settings.keyFile if you want to use interactive password entry
                # passwordFile = "/tmp/luks.key"; # Interactive
                settings = {
                  allowDiscards = true;
                  #keyFile = "/tmp/secret.key";
                };
                # additionalKeyFiles = [ "/tmp/additionalSecret.key" ];
                content = {
                  type = "btrfs";
                  extraArgs = [ "-f" ];
                  subvolumes = {
                    "/root" = {
                      mountpoint = "/";
                      mountOptions = [ "compress=zstd" "noatime" ];
                    };
                    "/home" = {
                      mountpoint = "/home";
                      mountOptions = [ "compress=zstd" "noatime" ];
                    };
                    "/nix" = {
                      mountpoint = "/nix";
                      mountOptions = [ "compress=zstd" "noatime" ];
                    };
                    "/swap" = {
                      mountpoint = "/.swapvol";
                      swap.swapfile.size = "8G";
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
    # During boot, resize the root partition to the size of the disk.
    # This makes upgrading the size of the vDisk easier.
    # fileSystems."/".fsType = "ext4";
    # fileSystems."/".autoResize = true;
  };
}
