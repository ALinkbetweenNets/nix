{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.syncthing;
in {
  options.link.syncthing.enable = mkEnableOption "activate syncthing";
  config = mkIf cfg.enable {

    environment.systemPackages = with pkgs; [ syncthing ];
    services.syncthing = {
      enable = true;
      user = "l";
      systemService = true;
      openDefaultPorts = true;
      extraOptions.gui = {
        theme = "black";
        user = "l";
      };
      overrideDevices =
        true; # overrides any devices added or deleted through the WebUI
      overrideFolders =
        true; # overrides any folders added or deleted through the WebUI
      devices = {
        "dn" = {
          id = "2UZCLBR-LR5DMFA-HWXNELR-3GF6BVU-RZEBCWZ-P72JF4N-ZV7H6MF-SEQX4QK";
        };
        "xn" = {
          id = "RVWAO67-2ZIIOUO-UFMXJL5-FZMMRNU-I6PQOOJ-RUQ7TKQ-HEKIIW3-AINSBQB";
        };
        "s22" = {
          id = "DOQGIQ6-WIAAZBV-EUQ6HWX-D6G2XYK-SAE6AGX-X3D4OLX-PGKELKL-RR6PSAE";
        };
        "in" = {
          id = "IYOMGJ7-NZADKG2-L2PMGIH-VSTMTJ4-KLA7VF4-3CUONC2-BQMMWTW-I6KHDAY";
        };
        "sn" = {
          id = "QAZMWCF-N4MACEK-IFISGXL-QPX7YDP-AHD7CXC-WYUCVZJ-D35X5J2-4C6IQAQ";
        };
        "hn" = {
          id = "YU4MCML-QWAYIDE-FSHCDWA-C2FGKTG-ERS6I36-SMCFI2J-RKLVOPN-PS3IFQD";
        };
      };
      settings.folders = {
        "v" = {
          path = lib.mkDefault "/home/l/v";
          devices = [ "dn" "xn" "s22" "in" "sn" "hn" ];
        };
        "camera" = {
          path = lib.mkDefault "/home/l/camera";
          devices = [ "dn" "xn" "s22" "sn" "hn" ];
          versioning = {
            type = "trashcan";
            params.cleanoutDays = "1000";
          };
        };
        "uni" = {
          path = lib.mkDefault "/home/l/uni";
          devices = [ "dn" "xn" "s22" "in" "sn" "hn" ];
          versioning = {
            type = "simple";
            params.keep = "3";
          };

        };
        "doc" = {
          path = lib.mkDefault "/home/l/doc";
          devices = [ "dn" "xn" "s22" "in" "sn" "hn" ];
          versioning = {
            type = "simple";
            params.keep = "10";
          };
        };
        "music" = {
          path = lib.mkDefault "/home/l/Music";
          devices = [ "dn" "xn" "s22" "in" "sn" "hn" ];
          versioning = {
            type = "trashcan";
            params.cleanoutDays = "1000";
          };
        };
        "crypt" = {
          path = lib.mkDefault "/home/l/crypt";
          devices = [ "dn" "xn" "in" "sn" "hn" ];
        };
        "sec" = {
          path = lib.mkDefault "/home/l/sec";
          devices = [ "dn" "xn" "in" "sn" "hn" ];
          versioning = {
            type = "simple";
            params.keep = "10";
          };
        };
        "keys" = {
          path = lib.mkDefault "/home/l/.keys";
          devices = [ "dn" "xn" "in" "sn" "hn" ];
          versioning = {
            type = "simple";
            params.keep = "10";
          };
        };
      };
    };
  };
}
