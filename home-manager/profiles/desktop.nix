{ lib, pkgs, flake-self, config, system-config, ... }:
with lib; {

  imports = [ ./common.nix ];
  config = {

    # Packages to install on all desktop systems
    home.packages = with pkgs;
      [
        alacritty
        beauty-line-icon-theme
        discord
        dracula-theme
        # fira-code-nerdfont
        kate
        obsidian
        signal-desktop
        xclip
        virt-manager
        spice
        spice-vdagent

        wl-clipboard-x11
        wl-clipboard
        hunspell
        kleopatra # gpg/ pgp
        popsicle # USB Flasher
        ventoy-full
        pavucontrol
        helvum # Patchbay
        gsettings-desktop-schemas # required for some apps like jami
        texlive.combined.scheme-full
        # Editor
        obsidian
        logseq
        libsForQt5.kate # kate
        kdiff3
        semantik # mind mapping
        # Hex Editor
        hexdino # terminal vimlike hex editor
        okteta # hex editor
        # File Sync
        syncthing-tray
        nextcloud-client
        seafile-client
        # Messenger
        signal-desktop
        telegram-desktop
        discord
        qtox
        # Utils
        pomodoro
        # Multimedia
        vlc
        mpv
        obs-studio
        obs-studio-plugins.obs-backgroundremoval
        cobang # qr codes
        brave # backup browser
        # Privacy
        # tor-browser-bundle-bin # compromised
        mullvad-vpn
        mullvad-browser
        monero-gui
        # RDP
        remmina # VNC Client
        libsForQt5.krfb # kde connect virtual monitor
        libsForQt5.kpurpose # KDE share
        libsForQt5.qt5.qtwebsockets
        libsForQt5.calendarsupport
        scrcpy # ADB screenshare

        xdg-utils
        # Desktop monitor settings change
        ddcui
        ddcutil
        veracrypt

      ] ++ lib.optionals
      (system-config.nixpkgs.hostPlatform.system == "x86_64-linux") [ ];

    # Programs to install on all desktop systems
    programs = {
      firefox.enable = true;
      terminator.enable = true;
      yt-dlp = {
        enable = true;
        extraConfig = "--update";
        settings = { embed-thumbnail = true; };

      };

    };

    # Services to enable on all systems
    services = {
      flameshot.enable = true;
      syncthing.enable = true;
    };

    link = {
      code.enable = true;
      #latex.enable=true;
      #i3.enable = true;

      #rust.enable = true;
      #sway.enable = true;
    };
    xdg = {
      enable = true;
      mimeApps.enable = true;
      userDirs.enable = true;
      userDirs.createDirectories = true;
    };
  };

}
