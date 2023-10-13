{ config, flake-self, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.main;
in {
  options.link.main = { enable = mkEnableOption "activate main"; };
  config = mkIf cfg.enable {
    link.desktop.enable = true;
    link.adb.enable = true;
    services.mullvad-vpn.enable = true;
    services.mullvad-vpn.package = pkgs.mullvad-vpn; # gui version
  };
}
