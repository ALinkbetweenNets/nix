{ config, lib, ... }:
with lib;
let cfg = config.link.disko;
in {
  options.link.disko = {
    enable = mkEnableOption "enable Disko";
    disks = mkOption {
      type = types.listOf types.str;
      default = "/dev/vda";
      description = "Disk(s) to use for disko";
    };
    swapSize = mkOption {
      type = types.str;
      default = "8G";
      description = "Size of swap volume";
    };
  };
  config = mkIf config.link.disko.enable {
    disko.devices = {
      disk = {
        main = {
          type = "disk";
          device = builtins.elemAt cfg.disks 0;
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
                    subvolumes =
                      if (builtins.length cfg.disks == 1) then {
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
                        "@/swap" = {
                          mountpoint = "/.swapvol";
                          swap.swapfile.size = cfg.swapSize;
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
                        "@/swap" = {
                          mountpoint = "/.swapvol";
                          swap.swapfile.size = cfg.swapSize;
                        };
                      };
                  };
                };
              };
            };
          };
        };
        data = mkIf (builtins.length cfg.disks > 1) {
          type = "disk";
          device =
            mkIf (builtins.length cfg.disks > 1) builtins.elemAt cfg.disks 1;
          content = {
            type = "gpt";
            partitions = {
              luks-data = {
                size = "100%";
                content = {
                  type = "luks";
                  name =
                    if (builtins.length cfg.disks == 2) then
                      "data"
                    else
                      "data-p1";
                  settings = {
                    allowDiscards = true;
                    #keyFile = "/tmp/secret.key";
                  };
                  content = {
                    type = "btrfs";
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
                    extraArgs =
                      if (builtins.length cfg.disks == 2) then
                        [
                          "-f" # Override existing partition
                        ]
                      else [
                        "-f"
                        "-d raid1"
                        "/dev/mapper/data-p2" # Use decrypted mapped device, same name as defined in disk1
                      ];
                  };
                };
              };
            };
          };
        };
        datap2 = mkIf (builtins.length cfg.disks == 3) {
          type = "disk";
          device =
            mkIf (builtins.length cfg.disks == 3) builtins.elemAt cfg.disks 2;
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

                };
              };
            };
          };
        };
      };
    };
  };
}
