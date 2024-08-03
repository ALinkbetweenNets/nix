{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.syncthing;
in {
  options.link.syncthing.enable = mkEnableOption "activate syncthing";
  config = mkIf cfg.enable {
    systemd.tmpfiles.rules = [ "d /var/lib/syncthing 1700 l wheel -" ];
    networking.firewall = {
      allowedTCPPorts = [ 8384 22000 ];
      allowedUDPPorts = [
        22000 # syncthing
        21027 # syncthing
      ];
    };
    environment.systemPackages = with pkgs; [ syncthing ];
    services.syncthing = {
      enable = true;
      user = "l";
      systemService = true;
      openDefaultPorts = true;
      settings = {
        extraOptions.gui = {
          theme = "black";
          user = "l";
        };
        # overrides any devices added or deleted through the WebUI
        overrideDevices = true;
        # overrides any folders added or deleted through the WebUI
        overrideFolders = true;
        devices = {
          "dn".id = "2UZCLBR-LR5DMFA-HWXNELR-3GF6BVU-RZEBCWZ-P72JF4N-ZV7H6MF-SEQX4QK";
          "xn".id = "RTBEC4G-MYEMYIB-E5LLFXW-XO5WISG-G7NH5IM-ZMXWSOQ-ENW3FPA-SB2G4QI";
          "fn".id = "Z3YB7BR-O6OBQN7-HPPZ5N5-SVYLBAN-REOGNBX-5KDWGVF-2WJKFC4-MMIZTQT";
          "s22".id = "DOQGIQ6-WIAAZBV-EUQ6HWX-D6G2XYK-SAE6AGX-X3D4OLX-PGKELKL-RR6PSAE";
          "in".id = "IYOMGJ7-NZADKG2-L2PMGIH-VSTMTJ4-KLA7VF4-3CUONC2-BQMMWTW-I6KHDAY";
          "sn".id = "SSSFCB5-W4CIMVK-L33WJ4F-VBH4FZW-SZIRMMN-IGHQ7MA-BBTFKYM-V2NSDQS";
          "hn".id = "YU4MCML-QWAYIDE-FSHCDWA-C2FGKTG-ERS6I36-SMCFI2J-RKLVOPN-PS3IFQD";
          "pppn".id = "JCOKRQ5-67ARNA3-VOO4EOZ-5GUPCU6-63FSAID-EI4MVHH-T5ORT3Y-OFAGAAY";
        };
        folders = {
          "v" = {
            path = lib.mkDefault "${config.link.syncthingDir}/v";
            devices = [
              "dn"
              "fn"
              "hn"
              "in"
              "s22"
              "sn"
              "xn"
            ];
          };
          "camera" = {
            path = lib.mkDefault "${config.link.syncthingDir}/camera";
            devices = [
              "s22"
              "sn"
            ];
            versioning = {
              type = "trashcan";
              params.cleanoutDays = "1000";
            };
          };
          "uni" = {
            path = lib.mkDefault "${config.link.syncthingDir}/uni";
            devices = [
              "dn"
              "hn"
              "fn"
              "in"
              "s22"
              "sn"
              "xn"
            ];
            versioning = {
              type = "simple";
              params.keep = "3";
            };
          };
          "w" = {
            path = lib.mkDefault "${config.link.syncthingDir}/w";
            devices = [
              "dn"
              "fn"
              "hn"
              "sn"
              "xn"
            ];
            versioning = {
              type = "simple";
              params.keep = "3";
            };
          };
          "github" = {
            path = lib.mkDefault "${config.link.syncthingDir}/github";
            devices = [
              "dn"
              "fn"
              "hn"
              "xn"
            ];
          };
          "mirror" = {
            path = lib.mkDefault "${config.link.syncthingDir}/.data-mirror";
            devices = [
              "dn"
              "fn"
              "xn"
              "sn"
            ];
          };
          "archive" = {
            path = lib.mkDefault "${config.link.syncthingDir}/archive";
            devices = [
              "dn"
              "fn"
              "xn"
              "sn"
            ];
          };
          "doc" = {
            path = lib.mkDefault "${config.link.syncthingDir}/doc";
            devices = [
              "dn"
              "fn"
              "hn"
              "in"
              "s22"
              "sn"
              "xn"

            ];
            versioning = {
              type = "simple";
              params.keep = "10";
            };
          };
          "music" = {
            path = lib.mkDefault "${config.link.syncthingDir}/Music";
            devices = [
              "dn"
              "fn"
              "hn"
              "in"
              "s22"
              "sn"
              "xn"
            ];
            versioning = {
              type = "trashcan";
              params.cleanoutDays = "1000";
            };
          };
          "crypt" = {
            path = lib.mkDefault "${config.link.syncthingDir}/crypt";
            devices = [
              "dn"
              "fn"
              "hn"
              "in"
              "sn"
              "xn"
            ];
          };
          "sec" = {
            path = lib.mkDefault "${config.link.syncthingDir}/sec";
            devices = [
              "dn"
              "fn"
              "hn"
              "in"
              "sn"
              "xn"
              "pppn"
            ];
            versioning = {
              type = "simple";
              params.keep = "10";
            };
          };
          "keys" = {
            path = lib.mkDefault "${config.link.syncthingDir}/.keys";
            devices = [
              "dn"
              "fn"
              "hn"
              "in"
              "sn"
              "xn"
            ];
            versioning = {
              type = "simple";
              params.keep = "10";
            };
          };
        };
      };
    };
  };
}
