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
      QT_QPA_PLATFORM = "wayland"; # Might not be necessary
      QT_AUTO_SCREEN_SCALE_FACTOR = "1"; # Might not be necessary
      WAYLAND_DISPLAY = ""; # Fixes obsidian and VSCode crashing
    };
    services.dbus.enable = true;
    programs.light.enable = true;

    security = {
      # Allow swaylock to unlock the computer for us
      pam.services.swaylock.text = "auth include login";
      polkit.enable = true;
      rtkit.enable = true;
    };

    users.users."l".extraGroups = [ "video" "audio" ];

    hardware = {
      # fixes'ÈGL_EXT_platform_base not supported'
      opengl.enable = true;
      # nvidia-drm.modeset=1 is required for some wayland compositors, e.g. sway
      nvidia.modesetting.enable = mkIf config.link.nvidia.enable true;
    };
  };
}
