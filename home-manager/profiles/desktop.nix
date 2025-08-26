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
      wezterm = {
        enable = true;
        enableZshIntegration = true;
        extraConfig = ''
          return {
            font = wezterm.font("FiraCode Nerd Font"),
            hide_tab_bar_if_only_one_tab = true,
          }
        '';
      };
      kitty = {
        enable = true;
        enableGitIntegration = true;
        settings = {
          # themeFile = "LiquidCarbonTransparent";
          background_opacity = 0.2;
          dynamic_background_opacity = "yes";
          transparent_background_colors = "#000000@1";
        };

      };
      firefox = { enable = true; };
      yt-dlp = {
        enable = true;
        extraConfig = "--no-update";
        settings = { embed-thumbnail = true; };
      };
      mpv = {
        # package = pkgs.mpv-unwrapped.wrapper {
        #   mpv = pkgs.mpv-unwrapped.override { vapoursynthSupport = true; };
        #   youtubeSupport = true;
        # };
        enable = true;
        scripts = with pkgs.mpvScripts; [
          # uosc
          dynamic-crop
          eisa01.smartskip
          manga-reader
          mpris
          mpv-cheatsheet
          mpv-image-viewer.image-positioning
          mpv-image-viewer.ruler
          mpv-notify-send
          mpv-osc-tethys
          mpv-playlistmanager
          mpv-webm
          occivink.seekTo
          quality-menu
          skipsilence
          sponsorblock
          thumbfast
          visualizer
          webtorrent-mpv-hook
          youtube-upnext
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
          # profiles = { fast = { vo = "vdpau"; }; };
          force-window = true;
          ytdl-format = "bestvideo+bestaudio";
          cache-default = 4000000;
          scriptOpts = "ytdl_hook-ytdl_path=${pkgs.yt-dlp}/bin/yt-dlp";
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
        cobang # qr codes
        ## Encryption
        #veracrypt
        kdePackages.kleopatra # gpg/ pgp
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
        plasma5Packages.kpurpose # KDE share
        kdePackages.qtwebsockets
        kdePackages.calendarsupport
        kdePackages.konsole
        # kdePackages.yakuake
        kdePackages.plasma-vault
        kdePackages.plasma-disks
        kdePackages.kfind
        kdePackages.colord-kde
        flake-self.inputs.zen-browser.packages.${system}.default
        # (pkgs.nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
      ] ++ lib.optionals
      (system-config.nixpkgs.hostPlatform.system == "x86_64-linux") [
        bitwarden
        tor-browser-bundle-bin # compromisednix
        mullvad-browser
      ];
  };
}
