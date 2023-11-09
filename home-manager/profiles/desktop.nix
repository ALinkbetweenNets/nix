{ lib, pkgs, flake-self, config, system-config, ... }:
with lib; {
  imports = [ ./common.nix flake-self.homeManagerModules.xdg ];
  config = {
    # Packages to install on all desktop systems
    home.packages = with pkgs;
      [
        ## Basics
        wl-clipboard-x11
        wl-clipboard
        hunspell
        hunspellDicts.de_DE
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

  };
}
