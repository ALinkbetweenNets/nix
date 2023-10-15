{ config, flake-self, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.main;
in {
  options.link.main = { enable = mkEnableOption "activate main"; };
  config = mkIf cfg.enable {
    link.desktop.enable = true;
    link.adb.enable = true;
    link.printing.enable = lib.mkIf config.link.office.enable true;
    link.syncthing.enable = true;
    link.git-sync.enable = true;
    services.mullvad-vpn.enable = true;
    services.mullvad-vpn.package = pkgs.mullvad-vpn; # gui version
  };
}
