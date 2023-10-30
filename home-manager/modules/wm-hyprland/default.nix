{ lib, config, ... }:
with lib;
let cfg = config.link.hyprland;
in {
  options.link.hyprland.enable = mkEnableOption "activate sway";
  config = mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      enableNvidiaPatches = lib.mkIf options.link.nvidia.enable true;
      settings = {
        decoration = {
          shadow_offset = "0 5";
          "col.shadow" = "rgba(00000099)";
        };
        "$mod" = "SUPER";
        bindm = [
          # mouse movements
          "$mod, mouse:272, movewindow"
          "$mod, mouse:273, resizewindow"
          "$mod ALT, mouse:272, resizewindow"
        ];
      };
      systemd.enable = true;
    };
  };
}
