{ lib, pkgs, ... }:
with lib;
{
  xdg = {
    enable = true;
    configFile."mimeapps.list".force = true;
    userDirs.enable = true;
    userDirs.createDirectories = true;
    mimeApps.enable = true;
    mimeApps.defaultApplications = {
      "application/gzip" = [ "org.kde.ark.desktop" ];
      "application/pdf" = [ "org.gnome.Evince.desktop" ];
      "application/vnd.rar" = [ "org.kde.ark.desktop" ];
      "application/x-7z-compressed" = [ "org.kde.ark.desktop" ];
      "application/x-bzip" = [ "org.kde.ark.desktop" ];
      "application/x-bzip2" = [ "org.kde.ark.desktop" ];
      "application/x-sh" = [ "codium.desktop" ];
      "application/x-tar" = [ "org.kde.ark.desktop" ];
      "application/xml" = [ "org.kde.kate.desktop" ];
      "application/zip" = [ "org.kde.ark.desktop" ];
      "audio/flac" = [ "mpv.desktop" ];
      "audio/mpeg" = [ "mpv.desktop" ];
      "audio/ogg" = [ "mpv.desktop" ];
      "audio/opus" = [ "mpv.desktop" ];
      "audio/webm" = [ "mpv.desktop" ];
      "image/bmp" = [ "org.kde.gwenview.desktop" ];
      "image/gif" = [ "org.kde.gwenview.desktop" ];
      "image/jpeg" = [ "org.kde.gwenview.desktop" ];
      "image/jpg" = [ "org.kde.gwenview.desktop" ];
      "image/png" = [ "org.kde.gwenview.desktop" ];
      "image/svg+xml" = [ "org.kde.gwenview.desktop" ];
      "image/webp" = [ "org.kde.gwenview.desktop" ];
      "text/calendar" = [ "thunderbird.desktop" ];
      "text/javascript" = [ "codium.desktop" ];
      "text/plain" = [ "org.kde.kate.desktop" ];
      "text/xml" = [ "org.kde.kate.desktop" ];
      "video/mp4" = [ "mpv.desktop" ];
      "video/mpeg" = [ "mpv.desktop" ];
      "video/webm" = [ "mpv.desktop" ];
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
