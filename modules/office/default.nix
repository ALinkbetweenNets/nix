{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.office;
in {
  options.link.office.enable = mkEnableOption "activate office";
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ libreoffice ];
  };
}
