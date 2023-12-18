{
  disko.devices = {
    disk = {
      vda = {
        type = "disk";
        device = "/dev/disk/by-uuid/E787-2951";
        content = {
          type = "gpt";
          partitions = {
            BOOT = {
              size = "1M";
              type = "EF02"; # for grub MBR
            };
            ESP = {
              type = "EF00";
              size = "500M";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            root = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };
            # plainSwap = {
            #   size = "4G";
            #   content = {
            #     type = "swap";
            #     # resumeDevice = true; # resume from hiberation from this device
            #   };
            # };

          };
        };
        # content = {
        #   type = "gpt";
        #   partitions = {
        #     # BOOT = {
        #     #   size = "1M";
        #     #   type = "EF02"; # for grub MBR
        #     # };
        #     ESP = {
        #       priority = 1;
        #       name = "ESP";
        #       size = "500M";
        #       type = "EF00";
        #       content = {
        #         type = "filesystem";
        #         format = "vfat";
        #         mountpoint = "/boot";
        #       };
        #     };
        #     root = {
        #       size = "100%";
        #       content = {
        #         type = "btrfs";
        #         extraArgs = [ "-f" ]; # Override existing partition
        #         # Subvolumes must set a mountpoint in order to be mounted,
        #         # unless their parent is mounted
        #         subvolumes = {
        #           # Subvolume name is different from mountpoint
        #           "/rootfs" = {
        #             mountpoint = "/";
        #           };
        #           # Subvolume name is the same as the mountpoint
        #           "/home" = {
        #             mountOptions = [ "compress=zstd" ];
        #             mountpoint = "/home";
        #           };
        #           # Parent is not mounted so the mountpoint must be set
        #           "/nix" = {
        #             mountOptions = [ "compress=zstd" "noatime" ];
        #             mountpoint = "/nix";
        #           };
        #           # Subvolume for the swapfile
        #           "/swap" = {
        #             mountpoint = "/.swapvol";
        #             swap = {
        #               swapfile.size = "4G";
        #             };
        #           };
        #         };
        #         mountpoint = "/";
        #         # swap = {
        #         #   swapfile = {
        #         #     size = "4G";
        #         #   };
        #         # };
        #       };
        #     };
        #   };
        # };
      };
    };
  };
}
