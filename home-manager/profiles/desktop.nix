{ lib, pkgs, flake-self, config, system-config, ... }:
with lib; {
  imports = [ ./common.nix ];
  config = {
    # Packages to install on all desktop systems
    home.packages = with pkgs;
      [
        ## Basics
        wl-clipboard-x11
        wl-clipboard
        hunspell
        # Audio
        helvum # Patchbay
        pavucontrol
        # Encryption
        veracrypt
        kleopatra # gpg/ pgp
        partition-manager
        # Misc
        xdg-utils
        # Editor
        libsForQt5.kate # kate
        kdiff3
        obsidian
        # Hex Editor
        hexdino # terminal vimlike hex editor
        okteta # hex editor
        # File Sync
        #syncthing-tray
        # Multimedia
        cobang # qr codes
        # Privacy
        # tor-browser-bundle-bin # compromised
        #mullvad-vpn
        mullvad-browser
        # RDP
        remmina # VNC Client
        libsForQt5.krfb # kde connect virtual monitor
        libsForQt5.kpurpose # KDE share
        scrcpy # ADB screenshare
        libsForQt5.qt5.qtwebsockets
        libsForQt5.calendarsupport
        libsForQt5.konsole
        libsForQt5.yakuake
        vivaldi
      ] ++ lib.optionals
        (system-config.nixpkgs.hostPlatform.system == "x86_64-linux") [ ];
    programs = {
      firefox.enable = true;
      #terminator.enable = true;
    };
    manual.html.enable = true;
    link = { code.enable = true; };
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
      };
    };
  };
}
