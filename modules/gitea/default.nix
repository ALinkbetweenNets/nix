{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.gitea;
in {
  options.link.gitea.enable = mkEnableOption "activate gitea";
  config = mkIf cfg.enable {

  };
}
