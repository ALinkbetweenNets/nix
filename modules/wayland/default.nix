{ lib, pkgs, config, ... }:
with lib;
let cfg = config.link.wayland;
in {

  options.link.wayland.enable = mkEnableOption "activate wayland";

  config = mkIf cfg.enable {

    security = {
      polkit.enable = true;
      rtkit.enable = true;
    };

    hardware = {
      # fixes'ÈGL_EXT_platform_base not supported'
      opengl.enable = true;
      # nvidia-drm.modeset=1 is required for some wayland compositors, e.g. sway
      nvidia.modesetting.enable = mkIf config.link.nvidia.enable true;
    };

  };
}
