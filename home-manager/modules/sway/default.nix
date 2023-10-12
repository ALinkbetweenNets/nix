{ lib, pkgs, config, flake-self, system-config, ... }:
with lib;
let
  cfg = config.link.sway;
  start-sway = pkgs.writeShellScriptBin "start-sway" /* sh */
    ''
      export WLR_DRM_NO_MODIFIERS=1
      dbus-launch --sh-syntax --exit-with-session ${pkgs.sway}/bin/sway
    '';
in
{
  options.link.sway.enable = mkEnableOption "activate sway";
  config = mkIf cfg.enable {
    home.packages = [
      start-sway
    ];
    wayland.windowManager.sway = {
      enable = true;
      config = {
        modifier = "Mod4";
        terminal = "konsole";
      };
    };

  };
}
