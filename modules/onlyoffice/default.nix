{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.onlyoffice;
in {
  options.link.onlyoffice.enable = mkEnableOption "activate onlyoffice";
  config = mkIf cfg.enable {
    services = {
      onlyoffice = {
        enable = true;
        hostname = "office.${config.link.domain}";
        port = 8000;

      };
    };
  };
}
