{ config, system-config, flake-self, pkgs, lib, ... }:
with lib;
let cfg = config.link.desktop;
in {
  options.link.desktop.enable = mkEnableOption "activate desktop";
  config = mkIf cfg.enable {
    link.common.enable = true;
    link.wayland.enable = lib.mkDefault true;
    link.xserver.enable = lib.mkDefault true;
    networking.networkmanager.enable = true;
    services.xserver.enable = true;
    services.xserver.displayManager.sddm.enable = true;
    services.xserver.desktopManager.plasma5.enable = true;
    sound.enable = true;
    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      #jack.enable = true;
      #media-session.enable = true;
    };
    networking.firewall = {
      allowedTCPPortRanges = [{
        from = 1714;
        to = 1764;
      } # KDE Connect
        ];
      allowedUDPPortRanges = [{
        from = 1714;
        to = 1764;
      } # KDE Connect
        ];
    };
  };
}
