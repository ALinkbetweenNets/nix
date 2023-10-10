{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.printing;
in {
  options.link.printing.enable = mkEnableOption "activate printing";
  config = mkIf cfg.enable {
    # CUPS
    services.printing.enable = true;
  };
}
