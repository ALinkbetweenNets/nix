{ lib, pkgs, flake-self, config, system-config, ... }:
with lib; {
  imports = [
    ../colorscheme.nix
    ./common.nix
    flake-self.homeManagerModules.xdg
  ];
  config = {
    dconf.settings = {
      "org/maliit/keyboard/maliit" = {
        enabled-languages = [ "en" "de" "emoji" ];
        theme = "BreezeDark";

      };
    };
    programs = {
      firefox.enable = true;
      yt-dlp = {
        enable = true;
        extraConfig = "--update";
        settings = { embed-thumbnail = true; };
      };
      #terminator.enable = true; # I prefer konsole
    };
    manual.html.enable = true;
    link = { code.enable = true; };
    # Packages to install on all desktop systems
    home.packages = with pkgs;
      [
        ## Basics
        nfs-utils
        ## Spelling
        hunspell
        hunspellDicts.de_DE
        ## Audio
        helvum # Patchbay
        pavucontrol
        ## Multimedia
        vlc
        mpv
        cobang # qr codes
        ## Encryption
        veracrypt
        kleopatra # gpg/ pgp
        ## Misc
        bitwarden
        xdg-utils
        scrcpy # ADB screenshare
        ktailctl # Tailscale GUI
        ## Editor
        libsForQt5.kate # kate
        kdiff3
        obsidian
        ## Hex Editor
        hexdino # terminal vimlike hex editor
        okteta # hex editor
        ## File Sync
        #syncthing-tray
        ## Browser
        # tor-browser-bundle-bin # compromised
        # vivaldi # nice but proprietary
        floorp # firefox fork, seems promising, needs more research
        #mullvad-vpn # is defined as program
        mullvad-browser
        ## RDP
        remmina # VNC Client
        ## KDE Utils
        libsForQt5.krfb # kde connect virtual monitor
        libsForQt5.kpurpose # KDE share
        libsForQt5.qt5.qtwebsockets
        libsForQt5.calendarsupport
        libsForQt5.konsole
        libsForQt5.yakuake
        libsForQt5.plasma-vault
        libsForQt5.plasma-disks
        libsForQt5.kfind
        (pkgs.nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
      ] ++ lib.optionals
        (system-config.nixpkgs.hostPlatform.system == "x86_64-linux") [ ];
  };
}
