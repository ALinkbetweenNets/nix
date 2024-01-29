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
    fonts = {
      packages = with pkgs;
        [
          glib
          gsettings-desktop-schemas
          gsettings-qt
          kde-gtk-config
          font-awesome
          fira
          fira-code
          fira-code-symbols
          league-of-moveable-type
          inter
          source-sans-pro
          source-serif-pro
          noto-fonts-emoji
          corefonts
          recursive
          iosevka-bin
          font-awesome
          line-awesome
          (nerdfonts.override { fonts = [ "FiraCode" ]; })
        ];
      fontDir.enable = true;
      fontconfig = {
        defaultFonts = {
          serif =
            [ "Berkeley Mono" "Inconsolata Nerd Font Mono" ];
          sansSerif =
            [ "Berkeley Mono" "Inconsolata Nerd Font Mono" ];
          monospace =
            [ "Berkeley Mono" "Inconsolata Nerd Font Mono" ];
          emoji = [ "Noto Color Emoji" ];
        };
      };
    };
    programs = {
      dconf.enable = true; # GTK themes are not applied in Wayland applications
      # dconf.packages = with pkgs;[ maliit-keyboard ];
      light.enable = true; # backlight control command and udev rules granting access to members of the “video” group.
    };
    environment.systemPackages = with pkgs; [
      glib
      gsettings-qt
      gsettings-desktop-schemas
      gnome.dconf-editor
      # Virt Manager
      virt-manager
      spice
      spice-vdagent
    ];
    networking = {
      networkmanager = {
        enable = true;
        # dns = lib.mkDefault "systemd-resolved";
      };
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
    nixpkgs.config.permittedInsecurePackages = [
      "electron-25.9.0" # Temporary fix for Obsidian
    ];
    sound.enable = true;
    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services = {
      dbus.enable = true;
      pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        #jack.enable = true;
        #media-session.enable = true;
      };
    };
    # xdg = {
    #   icons.enable = true;
    #   portal = {
    #     wlr.enable = config.link.wayland.enable;
    #   };
    # };
  };
}
