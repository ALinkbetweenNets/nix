{ lib, pkgs, system-config, ... }:
with lib; {
  xdg = mkIf system-config.link.desktop.enable {
    portal = {
      enable = true;
      xdgOpenUsePortal = true;
      configPackages = with pkgs;
        [ ] ++ lib.optionals (system-config.link.plasma.enable)
        [ kdePackages.xdg-desktop-portal-kde ]
        ++ lib.optionals (system-config.link.gnome.enable)
        [ xdg-desktop-portal-gnome ] ++ lib.optionals
        (system-config.services.xserver.desktopManager.phosh.enable)
        [ xdg-desktop-portal-gnome ]
        ++ lib.optionals (system-config.link.sway.enable)
        [ xdg-desktop-portal-wlr ]
        ++ lib.optionals (system-config.link.hyprland.enable)
        [ xdg-desktop-portal-hyprland ];
      extraPortals = with pkgs;
        [ ] ++ lib.optionals (system-config.link.plasma.enable)
        [ kdePackages.xdg-desktop-portal-kde ]
        ++ lib.optionals (system-config.link.gnome.enable)
        [ xdg-desktop-portal-gnome ] ++ lib.optionals
        (system-config.services.xserver.desktopManager.phosh.enable)
        [ xdg-desktop-portal-gnome ]
        ++ lib.optionals (system-config.link.sway.enable)
        [ xdg-desktop-portal-wlr ]
        ++ lib.optionals (system-config.link.hyprland.enable)
        [ xdg-desktop-portal-hyprland ];
    };
    userDirs = {
      enable = true;
      createDirectories = true;
    };
    enable = true;
    configFile."mimeapps.list".force = true;
    mimeApps.enable = true;
    mimeApps.defaultApplications = {
      "application/gzip" = [ "org.kde.ark.desktop" ];
      "application/vnd.rar" = [ "org.kde.ark.desktop" ];
      "application/x-7z-compressed" = [ "org.kde.ark.desktop" ];
      "application/x-bzip" = [ "org.kde.ark.desktop" ];
      "application/x-bzip2" = [ "org.kde.ark.desktop" ];
      "application/x-sh" = [ "codium.desktop" ];
      "application/x-tar" = [ "org.kde.ark.desktop" ];
      "application/zip" = [ "org.kde.ark.desktop" ];
      "application/pdf" = [ "org.kde.okular.desktop" ];
      "application/xml" = [ "org.kde.kate.desktop" ];
      "audio/flac" = [ "vlc.desktop" ];
      "audio/mpeg" = [ "vlc.desktop" ];
      "audio/ogg" = [ "vlc.desktop" ];
      "audio/opus" = [ "vlc.desktop" ];
      "audio/webm" = [ "vlc.desktop" ];
      "image/bmp" = [ "org.kde.gwenview.desktop" ];
      "image/gif" = [ "org.kde.gwenview.desktop" ];
      "image/jpeg" = [ "org.kde.gwenview.desktop" ];
      "image/jpg" = [ "org.kde.gwenview.desktop" ];
      "image/png" = [ "org.kde.gwenview.desktop" ];
      "image/svg+xml" = [ "org.kde.gwenview.desktop" ];
      "image/webp" = [ "org.kde.gwenview.desktop" ];
      "text/calendar" = [ "thunderbird.desktop" ];
      "text/javascript" = [ "codium.desktop" ];
      "text/markdown" = [ "neovide.desktop" ];
      "text/plain" = [ "org.kde.kate.desktop" ];
      "text/xml" = [ "org.kde.kate.desktop" ];
      "video/mp4" = [ "vlc.desktop" ];
      "video/mpeg" = [ "vlc.desktop" ];
      "video/webm" = [ "vlc.desktop" ];
      "x-scheme-handler/sgnl" = [ "signal-desktop.desktop" ];
      "x-scheme-handler/signalcaptcha" = [ "signal-desktop.desktop" ];
      "x-scheme-handler/http" = [ "firefox.desktop" ];
      "x-scheme-handler/https" = [ "firefox.desktop" ];
      "text/html" = [ "firefox.desktop" ];
      "x-scheme-handler/chrome" = [ "firefox.desktop" ];
      "application/x-extension-htm" = [ "firefox.desktop" ];
      "application/x-extension-html" = [ "firefox.desktop" ];
      "application/x-extension-shtml" = [ "firefox.desktop" ];
      "application/x-extension-xhtml" = [ "firefox.desktop" ];
      "application/x-extension-xht" = [ "firefox.desktop" ];
      "application/xhtml+xml" = [ "firefox.desktop" ];
    };
  };
}
