{ config, system-config, flake-self, pkgs, lib, ... }:
with lib;
let cfg = config.link.desktop;
in {
  options.link.desktop.enable = mkEnableOption "activate desktop";
  config = mkIf cfg.enable {
    link = {
      common.enable = true;
      wayland.enable = lib.mkDefault true;
      xserver.enable = lib.mkDefault true;
      plasma.enable = lib.mkDefault true;
    };
    programs.dconf.enable = true; # GTK themes are not applied in Wayland applications
    environment.systemPackages = with pkgs; [
      # Multimedia
      vlc
      mpv
      # Virt Manager
        virt-manager
      spice
      spice-vdagent
    ];
    networking = {
      networkmanager.enable = true;
      firewall = {
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
    sound.enable = true;
    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services = {
      pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        #jack.enable = true;
        #media-session.enable = true;
      };
    };
  };
}
