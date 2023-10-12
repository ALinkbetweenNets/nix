{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.mullvad;
in {
  options.link.mullvad.enable = mkEnableOption "activate mullvad";
  config = mkIf cfg.enable {
    services.mullvad-vpn.enable = true;
  };
}
