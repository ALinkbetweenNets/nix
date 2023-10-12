{ lib, pkgs, config, flake-self, system-config, ... }:
with lib;
let
  cfg = config.link.i3status-rust;

in
{

  options.link.i3status-rust.enable = mkEnableOption "activate i3status-rust";

  config = mkIf cfg.enable { };
}
