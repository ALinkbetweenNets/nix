{ lib, pkgs, ... }:
with lib;
{
  xdg = {
    enable = true;
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
      "text/plain" = [ "org.kde.kate.desktop" ];
      "text/xml" = [ "org.kde.kate.desktop" ];
      "video/mp4" = [ "vlc.desktop" ];
      "video/mpeg" = [ "vlc.desktop" ];
      "video/webm" = [ "vlc.desktop" ];
      "x-scheme-handler/sgnl" = [ "signal-desktop.desktop" ];
      "x-scheme-handler/signalcaptcha" = [ "signal-desktop.desktop" ];
    };
  };
}
