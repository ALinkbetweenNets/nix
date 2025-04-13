{ config, lib, ... }:
with lib; {
  options.link.disko = {
    enable = mkEnableOption "enable Disko";
    disks = mkOption {
      type = types.listOf types.str;
      default = "/dev/vda";
      description = "Disk(s) to use for disko";
    };
  };
  config = mkIf config.link.disko.enable {
    disko.devices = {
      disk = {
        main = {
          type = "disk";
          device = builtins.elemAt disks 0;
          content = {
            type = "gpt";
            partitions = {
              boot = {
                priority = 1;
                size = "1M";
                type = "EF02";
              };
              ESP = {
                size = "1G";
                type = "EF00";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot";
                };
              };
              luks-root = {
                size = "100%";
                content = {
                  type = "luks";
                  name = "root";
                  settings = {
                    allowDiscards = true;
                    #keyFile = "/tmp/secret.key";
                  };
                  content = {
                    type = "btrfs";
                    extraArgs = [ "-f" ]; # Override existing partition
                    subvolumes = if (builtins.length disks == 1) then {
                      "@" = { };
                      "@/root" = {
                        mountpoint = "/";
                        mountOptions = [ "compress=zstd" "noatime" ];
                      };
                      "@/home" = {
                        mountpoint = "/home";
                        mountOptions = [ "compress=zstd" ];
                      };
                      "@/nix" = {
                        mountpoint = "/nix";
                        mountOptions = [ "compress=zstd" "noatime" ];
                      };
                      "@/persist" = {
                        mountpoint = "/persist";
                        mountOptions = [ "compress=zstd" "noatime" ];
                      };
                      "@/var-lib" = {
                        mountpoint = "/var/lib";
                        mountOptions = [ "compress=zstd" "noatime" ];
                      };
                      "@/var-log" = {
                        mountpoint = "/var/log";
                        mountOptions = [ "compress=zstd" "noatime" ];
                      };
                      "@/var-tmp" = {
                        mountpoint = "/var/tmp";
                        mountOptions = [ "compress=zstd" "noatime" ];
                      };
                      "@/.swap" = {
                        mountpoint = "/.swapvol";
                        swap.swapfile.size = "64G";
                      };
                    } else {
                      "@" = { };
                      "@/root" = {
                        mountpoint = "/";
                        mountOptions = [ "compress=zstd" "noatime" ];
                      };
                      "@/home" = {
                        mountpoint = "/home";
                        mountOptions = [ "compress=zstd" ];
                      };
                      "@/nix" = {
                        mountpoint = "/nix";
                        mountOptions = [ "compress=zstd" "noatime" ];
                      };
                      "@/persist" = {
                        mountpoint = "/persist";
                        mountOptions = [ "compress=zstd" "noatime" ];
                      };
                      "@/var-log" = {
                        mountpoint = "/var/log";
                        mountOptions = [ "compress=zstd" "noatime" ];
                      };
                      "@/var-tmp" = {
                        mountpoint = "/var/tmp";
                        mountOptions = [ "compress=zstd" "noatime" ];
                      };
                      "@/.swap" = {
                        mountpoint = "/.swapvol";
                        swap.swapfile.size = "64G";
                      };
                    };
                  };
                };
              };
            };
          };
        };
        data = if (number_of_disks == 1) then
          { }
        else if (number_of_disks == 2) then {
          type = "disk";
          device = builtins.elemAt disks 1;
          content = {
            type = "gpt";
            partitions = {
              luks-data = {
                size = "100%";
                content = {
                  type = "luks";
                  name = "data";
                  settings = {
                    allowDiscards = true;
                    #keyFile = "/tmp/secret.key";
                  };
                  content = {
                    content = {
                      type = "btrfs";
                      extraArgs = [ "-f" ]; # Override existing partition
                      subvolumes = {
                        "@" = {
                          mountpoint = "/var/lib";
                          mountOptions = [ "compress=zstd" "noatime" ];
                        };
                        # "@/home" = {
                        #   mountpoint = "/home";
                        #   mountOptions = [ "compress=zstd" ];
                        # };
                      };
                    };
                  };
                };
              };
            };
          };
        } else {
          type = "disk";
          device = builtins.elemAt disks 1;
          content = {
            type = "gpt";
            partitions = {
              luks-data-p1 = {
                size = "100%";
                content = {
                  type = "luks";
                  name = "data-p1";
                  settings = {
                    allowDiscards = true;
                    #keyFile = "/tmp/secret.key";
                  };
                  # content = {
                  #   type = "btrfs";
                  #   extraArgs = [
                  #     "-d raid1"
                  #     "/dev/mapper/p1" # Use decrypted mapped device, same name as defined in disk1
                  #   ];
                  #   subvolumes = {
                  #     "/root" = {
                  #       mountpoint = "/";
                  #       mountOptions = [ "rw" "relatime" "ssd" ];
                  #     };
                  #   };
                  # };
                };
              };
            };
          };
        };
        datap2 = if (number_of_disks == 3) then {
          type = "disk";
          device = builtins.elemAt disks 2;
          content = {
            type = "gpt";
            partitions = {
              luks-data-p2 = {
                size = "100%";
                content = {
                  type = "luks";
                  name = "data-p2";
                  settings = {
                    allowDiscards = true;
                    #keyFile = "/tmp/secret.key";
                  };
                  content = {
                    type = "btrfs";
                    extraArgs = [
                      "-d raid1"
                      "/dev/mapper/data-p1" # Use decrypted mapped device, same name as defined in disk1
                    ];
                    subvolumes = {
                      "@" = {
                        mountpoint = "/var/lib";
                        mountOptions = [ "compress=zstd" "noatime" ];
                      };
                      # "@/home" = {
                      #   mountpoint = "/home";
                      #   mountOptions = [ "compress=zstd" ];
                      # };
                    };
                  };
                };
              };
            };
          };
        } else
          { };
      };
    };
  };
}
