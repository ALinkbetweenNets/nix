{ lib, pkgs, flake-self, config, system-config, ... }:
with lib; {
  imports =
    [ ../colorscheme.nix ./common.nix flake-self.homeManagerModules.xdg ];
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
        scripts = with pkgs.mpvScripts; [
          sponsorblock
          thumbfast
          mpv-webm
          uosc
        ];
        bindings = {
          WHEEL_UP = "seek 10";
          WHEEL_DOWN = "seek -10";
          "Alt+0" = "set window-scale 0.5";
          "CTRL+1" = ''
            no-osd change-list glsl-shaders set "~~/shaders/Anime4K_Clamp_Highlights.glsl:~~/shaders/Anime4K_Restore_CNN_VL.glsl:~~/shaders/Anime4K_Upscale_CNN_x2_VL.glsl:~~/shaders/Anime4K_AutoDownscalePre_x2.glsl:~~/shaders/Anime4K_AutoDownscalePre_x4.glsl:~~/shaders/Anime4K_Upscale_CNN_x2_M.glsl"; show-text "Anime4K: Mode A (HQ)"'';
          "CTRL+2" = ''
            no-osd change-list glsl-shaders set "~~/shaders/Anime4K_Clamp_Highlights.glsl:~~/shaders/Anime4K_Restore_CNN_Soft_VL.glsl:~~/shaders/Anime4K_Upscale_CNN_x2_VL.glsl:~~/shaders/Anime4K_AutoDownscalePre_x2.glsl:~~/shaders/Anime4K_AutoDownscalePre_x4.glsl:~~/shaders/Anime4K_Upscale_CNN_x2_M.glsl"; show-text "Anime4K: Mode B (HQ)"'';
          "CTRL+3" = ''
            no-osd change-list glsl-shaders set "~~/shaders/Anime4K_Clamp_Highlights.glsl:~~/shaders/Anime4K_Upscale_Denoise_CNN_x2_VL.glsl:~~/shaders/Anime4K_AutoDownscalePre_x2.glsl:~~/shaders/Anime4K_AutoDownscalePre_x4.glsl:~~/shaders/Anime4K_Upscale_CNN_x2_M.glsl"; show-text "Anime4K: Mode C (HQ)"'';
          "CTRL+4" = ''
            no-osd change-list glsl-shaders set "~~/shaders/Anime4K_Clamp_Highlights.glsl:~~/shaders/Anime4K_Restore_CNN_VL.glsl:~~/shaders/Anime4K_Upscale_CNN_x2_VL.glsl:~~/shaders/Anime4K_Restore_CNN_M.glsl:~~/shaders/Anime4K_AutoDownscalePre_x2.glsl:~~/shaders/Anime4K_AutoDownscalePre_x4.glsl:~~/shaders/Anime4K_Upscale_CNN_x2_M.glsl"; show-text "Anime4K: Mode A+A (HQ)"'';
          "CTRL+5" = ''
            no-osd change-list glsl-shaders set "~~/shaders/Anime4K_Clamp_Highlights.glsl:~~/shaders/Anime4K_Restore_CNN_Soft_VL.glsl:~~/shaders/Anime4K_Upscale_CNN_x2_VL.glsl:~~/shaders/Anime4K_AutoDownscalePre_x2.glsl:~~/shaders/Anime4K_AutoDownscalePre_x4.glsl:~~/shaders/Anime4K_Restore_CNN_Soft_M.glsl:~~/shaders/Anime4K_Upscale_CNN_x2_M.glsl"; show-text "Anime4K: Mode B+B (HQ)"'';
          "CTRL+6" = ''
            no-osd change-list glsl-shaders set "~~/shaders/Anime4K_Clamp_Highlights.glsl:~~/shaders/Anime4K_Upscale_Denoise_CNN_x2_VL.glsl:~~/shaders/Anime4K_AutoDownscalePre_x2.glsl:~~/shaders/Anime4K_AutoDownscalePre_x4.glsl:~~/shaders/Anime4K_Restore_CNN_M.glsl:~~/shaders/Anime4K_Upscale_CNN_x2_M.glsl"; show-text "Anime4K: Mode C+A (HQ)"'';
          "CTRL+0" = ''
            no-osd change-list glsl-shaders clr ""; show-text "GLSL shaders cleared"'';
        };
        config = {
          profile = "gpu-hq";
          force-window = true;
          ytdl-format = "bestvideo+bestaudio";
          cache-default = 4000000;
          # Optimized shaders for higher-end GPU: Mode A (HQ)
          glsl-shaders =
            "~~/shaders/Anime4K_Clamp_Highlights.glsl:~~/shaders/Anime4K_Restore_CNN_VL.glsl:~~/shaders/Anime4K_Upscale_CNN_x2_VL.glsl:~~/shaders/Anime4K_AutoDownscalePre_x2.glsl:~~/shaders/Anime4K_AutoDownscalePre_x4.glsl:~~/shaders/Anime4K_Upscale_CNN_x2_M.glsl";
        };
        defaultProfiles = [ "gpu-hq" ];
        extraInput = ''
          esc         quit                        #! Quit
          #           script-binding uosc/video   #! Video tracks
          # additional comments
        '';
      };
      #terminator.enable = true; # I prefer konsole
    };
    manual.html.enable = true;
    # Packages to install on all desktop systems
    home.packages = with pkgs;
      [
        neovide # neovim frontend
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
        imhex
        ## File Sync
        #syncthing-tray
        ## Browser
        librewolf
        # vivaldi # nice but proprietary
        # floorp # firefox fork, seems promising, needs more research
        #mullvad-vpn # is defined as program
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
      (system-config.nixpkgs.hostPlatform.system == "x86_64-linux") [
        bitwarden
        tor-browser-bundle-bin # compromisednix
        mullvad-browser
      ];
  };
}
