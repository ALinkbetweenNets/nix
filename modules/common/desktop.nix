{ config, system-config, flake-self, pkgs, lib, ... }:
with lib;
let cfg = config.link.desktop;
in {
  options.link.desktop.enable = mkEnableOption "activate desktop";
  config = mkIf cfg.enable {
    link = {
      common.enable = true;
      dns.enable = true;
      wayland.enable = lib.mkDefault true;
      xserver.enable = lib.mkDefault true;
      plasma.enable = lib.mkDefault true;
    };
    programs = {
      dconf.enable = true; # GTK themes are not applied in Wayland applications
      # dconf.packages = with pkgs;[ maliit-keyboard ];
      light.enable =
        true; # backlight control command and udev rules granting access to members of the “video” group.
      ssh.setXAuthLocation = true;
      kdeconnect.enable = true;
      ydotool.enable = true;
      java = {
        binfmt = true;
        enable = true;
      };
    };
    environment.systemPackages = with pkgs;
      [
        wezterm
        kdePackages.partitionmanager
        adwaita-icon-theme
        wifi-qr
        barrier # KVM
        gsettings-qt
        kde-gtk-config
        glib
        gsettings-qt
        gsettings-desktop-schemas
        dconf-editor
        # Virt Manager
        virt-manager
        spice
        spice-vdagent
      ] ++ lib.optionals (config.nixpkgs.hostPlatform.system == "x86_64-linux")
      [
        # cobang
      ] ++ lib.optionals (config.link.podman.enable) [ pods podman-desktop ];
    networking = {
      networkmanager = {
        enable = true;
        # dns = lib.mkDefault "systemd-resolved";
      };
      firewall = {
        allowedTCPPortRanges = [{
          from = 1714;
          to = 1764;
        } # KDE Connect
          ];
        allowedUDPPortRanges = [{
          from = 1714;
          to = 1764;
        } # KDE Connect
          ];
      };
    };
    fonts = {
      enableDefaultPackages = true;
      packages = with pkgs; [
        # font-awesome
        jetbrains-mono
        # fira
        # fira-code
        # fira-code-symbols
        # league-of-moveable-type
        # source-sans-pro
        # source-serif-pro
        noto-fonts-color-emoji
        noto-fonts-cjk-sans # japanese fonts
        # corefonts
        # recursive
        # iosevka-bin
        # font-awesome
        # line-awesome
        nerd-fonts.fira-code
      ];
      fontDir.enable = true;
      fontconfig = {
        defaultFonts = {
          serif = [ "FiraCode" ];
          sansSerif = [ "FiraCode" ];
          monospace = [ "FiraCode" ];
          emoji = [ "Noto Color Emoji" ];
        };
      };
    };
    # nixpkgs.config.permittedInsecurePackages = [
    #   "electron-25.9.0" # Temporary fix for Obsidian
    # ];
    # sound.enable = true; # Enable alsa
    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      # wireplumber = {
      #   extraLuaConfig.main."99-alsa-lowlatency" = ''
      #     alsa_monitor.rules = {
      #       {
      #         matches = {{{ "node.name", "matches", "alsa_output.*" }}};
      #         apply_properties = {
      #           ["audio.format"] = "S32LE",
      #           ["audio.rate"] = "96000", -- for USB soundcards it should be twice your desired rate
      #           ["api.alsa.period-size"] = 2, -- defaults to 1024, tweak by trial-and-error
      #           -- ["api.alsa.disable-batch"] = true, -- generally, USB soundcards use the batch mode
      #         },
      #       },
      #     }
      #   '';
      #   #media-session.enable = true;
      #   extraConfig.bluetoothEnhancements = {
      #     "monitor.bluez.properties" = {
      #       "bluez5.enable-sbc-xq" = true;
      #       "bluez5.enable-msbc" = true;
      #       "bluez5.enable-hw-volume" = true;
      #       "bluez5.roles" = [ "hsp_hs" "hsp_ag" "hfp_hf" "hfp_ag" ];
      #     };
      #   };
      # };
      enable = true;
      alsa.enable = true;
      # alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      extraConfig.pipewire."92-low-latency" = {
        "context.properties" = {
          "default.clock.rate" = 48000;
          "default.clock.allowed-rates" = [ 48000 ];
          "default.clock.quantum" = 2018;
          "default.clock.min-quantum" = 1024;
          "default.clock.max-quantum" = 2048;
        };
      };
      #   context.modules = [{
      #     name = "libpipewire-module-protocol-pulse";
      #     args = {
      #       pulse.min.req = "32/48000";
      #       pulse.default.req = "32/48000";
      #       pulse.max.req = "32/48000";
      #       pulse.min.quantum = "32/48000";
      #       pulse.max.quantum = "32/48000";
      #     };
      #   }];
      #   stream.properties = {
      #     node.latency = "32/48000";
      #     resample.quality = 1;
      #   };
      # };

    };
    services = {
      dbus.enable = true;
      envfs.enable = true;
    };

    # xdg = {
    #   icons.enable = true;
    #   portal = {
    #     wlr.enable = config.link.wayland.enable;
    #   };
    # };
  };
}
