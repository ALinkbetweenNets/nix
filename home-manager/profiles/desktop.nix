{ lib, pkgs, flake-self, config, system-config, ... }:
with lib; {
  imports = [
    ../colorscheme.nix
    ./common.nix
    flake-self.homeManagerModules.xdg
  ];
  config = {
    dconf = {
      enable = true;
      settings = {
        "org/maliit/keyboard/maliit" = {
          enabled-languages = [ "en" "de" "emoji" ];
          theme = "BreezeDark";
        };
        "org/gnome/desktop/interface".color-scheme = "prefer-dark";
      };
    };
    programs = {
      firefox.enable = true;
      yt-dlp = {
        enable = true;
        extraConfig = "--update";
        settings = { embed-thumbnail = true; };
      };
      mpv = {
        enable = true;
        scripts = with pkgs.mpvScripts; [ sponsorblock thumbfast mpv-webm uosc ];
        config = {
          profile = "gpu-hq";
          force-window = true;
          ytdl-format = "bestvideo+bestaudio";
          cache-default = 4000000;
        };
        defaultProfiles = [
          "gpu-hq"
        ];
        bindings = {
          WHEEL_UP = "seek 10";
          WHEEL_DOWN = "seek -10";
          "Alt+0" = "set window-scale 0.5";
        };
        extraInput = ''
          esc         quit                        #! Quit
          #           script-binding uosc/video   #! Video tracks
          # additional comments
        '';
      };
      #terminator.enable = true; # I prefer konsole
    };
    manual.html.enable = true;
    link = {
      code.enable = true;
      #plasma.enable = true;
    };
    # Packages to install on all desktop systems
    home.packages = with pkgs;
      [
        ## Basics
        nfs-utils
        ## Spelling
        aspell
        hunspell
        hunspellDicts.de_DE
        hunspellDicts.en_US
        ## Audio
        #helvum # Patchbay
        pavucontrol
        ## Multimedia
        vlc
        # cobang # qr codes
        ## Encryption
        #veracrypt
        kleopatra # gpg/ pgp
        ## Misc
        bitwarden
        xdg-utils
        scrcpy # ADB screenshare
        ktailctl # Tailscale GUI
        ## Editor
        kdePackages.kate # kate
        kdiff3
        obsidian
        ## Hex Editor
        hexdino # terminal vimlike hex editor
        okteta # hex editor
        ## File Sync
        #syncthing-tray
        ## Browser
        librewolf
        tor-browser-bundle-bin # compromised
        # vivaldi # nice but proprietary
        floorp # firefox fork, seems promising, needs more research
        #mullvad-vpn # is defined as program
        mullvad-browser
        ## RDP
        remmina # VNC Client
        ## KDE Utils
        kdePackages.krfb # kde connect virtual monitor
        kdePackages.plasma-browser-integration
        libsForQt5.kpurpose # KDE share
        libsForQt5.qt5.qtwebsockets
        kdePackages.calendarsupport
        kdePackages.konsole
        # kdePackages.yakuake
        kdePackages.plasma-vault
        kdePackages.plasma-disks
        kdePackages.kfind
        kdePackages.colord-kde
        # (pkgs.nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
      ] ++ lib.optionals
        (system-config.nixpkgs.hostPlatform.system == "x86_64-linux") [ ];
  };
}
