{ lib, pkgs, config, ... }:
with lib;
let cfg = config.link.xrdp;
in {
  options.link.xrdp.enable = mkEnableOption "activate xrdp";
  config = mkIf cfg.enable {
    services.xrdp.enable = true;
    services.xrdp.defaultWindowManager =
      if config.link.wayland.enable then
        "startplasma-wayland"
      else
        "startplasma-x11";
    services.xrdp.openFirewall = true;
  };
}
