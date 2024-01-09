{ lib, pkgs, config, ... }:
with lib;
let cfg = config.link.wayland;
in {
  options.link.wayland.enable = mkEnableOption "activate wayland";
  config = mkIf cfg.enable {
    programs.xwayland.enable = true;
    environment.systemPackages = with pkgs;
      [
        shotman
        wl-clipboard-x11
        wl-clipboard
        xwayland
        xwaylandvideobridge
        wayland-utils
        wtype # xdotool
        wev # key codes
      ] ++ lib.optionals
        (config.link.plasma.enable) [ libsForQt5.plasma-wayland-protocols ];
    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      MOZ_ENABLE_WAYLAND = "1";
    };
    hardware = {
      # fixes'ÈGL_EXT_platform_base not supported'
      opengl.enable = true;
      # nvidia-drm.modeset=1 is required for some wayland compositors, e.g. sway
      nvidia.modesetting.enable = mkIf config.link.nvidia.enable true;
    };
  };
}
