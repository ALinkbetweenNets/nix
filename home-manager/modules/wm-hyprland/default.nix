{ lib, config, pkgs, ... }:
with lib;
let cfg = config.link.hyprland;
in {
  options.link.hyprland.enable = mkEnableOption "activate hyprland";
  config = mkIf cfg.enable {
    link.programs.wofi.enable = true;
    # xdg.desktopEntries."org.gnome.Settings" = {
    #   name = "Settings";
    #   comment = "Gnome Control Center";
    #   icon = "org.gnome.Settings";
    #   exec =
    #     "env XDG_CURRENT_DESKTOP=gnome ${pkgs.gnome.gnome-control-center}/bin/gnome-control-center";
    #   categories = [ "X-Preferences" ];
    #   terminal = false;
    # };
    services = {
      # Networking
      network-manager-applet.enable = true;
      # Bluetooth
      blueman.enable = true;
      # Pulseaudio
      pasystray.enable = true;
      # Battery Warning
      cbatticon.enable = true;
      hypridle = {
        enable = true;
        settings = {
          general = {
            after_sleep_cmd = "hyprctl dispatch dpms on";
            ignore_dbus_inhibit = false;
            lock_cmd = "hyprlock";
          };

          listener = [
            {
              timeout = 900;
              on-timeout = "hyprlock";
            }
            {
              timeout = 1200;
              on-timeout = "hyprctl dispatch dpms off";
              on-resume = "hyprctl dispatch dpms on";
            }
          ];
        };
      };
    };
    programs = {
      fuzzel = {
        enable = true;
        settings = {
          main = {
            terminal = "wezterm";
            layer = "overlay";
            width = 60;
          };
          colors.background = "01010101";
          border.radius = 0;
        };
      };
      hyprlock = {
        enable = true;
        settings = {
          general = {
            disable_loading_bar = false;
            grace = 300;
            hide_cursor = true;
            # ignore_empty_inpput = true;
          };
          background = [{
            path = "screenshot";
            blur_passes = 3;
            blur_size = 8;
          }];
          input-field = [{
            size = "400, 400";
            # size = "100, 100";
            outline_thickness = 20;
            # dots_size = 0.2;
            # dots_spacing = 0.5;
            dots_center = true;
            font_color = "rgb(226, 226, 226)";
            inner_color = "rgba(0,0,0,0)";
            # outer_color = "rgba(33ccffee) rgba(00ff99ee) rgba(faf76eee)";
            outer_color = "rgba(255, 0, 0, 0)";
            fade_on_empty = false;
            rounding = -1;
            placeholder_text = "";
            # placeholder_text = ''
            # <span foreground="##8bd5ca"><i>󰌾 Logged in as </i><span foreground="##8bd5ca">$USER</span></span>'';
            hide_input = true;
            check_color = "rgb(8, 169, 8)";
            fail_color = "rgb(130, 14, 14)";
            fail_text = "$ATTEMPTS";
            capslock_color = "rgb(192, 204, 23)";
            position = "0, -185";
            halign = "center";
            valign = "center";
            shadow_passes = 0;
          }];
          label = [
            {
              text = ''cmd[update:30000] echo "$(date +"%I:%M %p")"'';
              font_size = 90;
              position = "0, -100";
              halign = "center";
              valign = "top";
              shadow_passes = 2;
            }
            {
              text = ''cmd[update:43200000] echo "$(date +"%A, %d %B %Y")"'';
              font_size = 25;
              position = "0, -250";
              halign = "center";
              valign = "top";
              shadow_passes = 2;
            }
          ];
        };
      };
      waybar = {
        enable = true;
        settings.mainbar = {
          layer = "top";
          position = "top";
          height = 20;
          output = [ "eDP-1" "DP-2" ];
          modules-left = [ "hyprland/workspaces" ];
          modules-center = [ "hyprland/window" "clock" ];
          modules-right = [
            "tray"
            "mpd"
            "temperature"
            "load"
            "custom/brightness"
            "mpris"
            "wireplumber"
            "battery"
          ];
          "hyprland/workspaces" = {
            "on-scroll-up" = "hyprctl dispatch workspace e+1";
            "on-scroll-down" = "hyprctl dispatch workspace e-1";
            all-outputs = true;
          };
          "hyprland/window" = { "separate-outputs" = true; };
          "tray"={
            show-passive-items=true;
          };
          "custom/hello-from-waybar" = {
            format = "hello {}";
            max-length = 40;
            interval = "once";
            exec = pkgs.writeShellScript "hello-from-waybar" ''
              echo "from within waybar"
            '';
            "backlight/slider" = {
              min = 0;
              max = 100;
              orientation = "horizontal";
              min-width = 100;
            };
            "custom/brightness" = {
              "format" = "{icon} {percentage}%";
              "format-icons" = [ "uDB80uDCDE" "uDB80uDCDF" "uDB80uDCE0" ];
              "return-type" = "json";
              "exec" = ''
                ddcutil --bus 7 getvcp 10 | grep -oP 'current.*?=\s*\K[0-9]+' | { read x; echo '{"percentage"='$x'}'; }'';
              "on-scroll-up" = "ddcutil --noverify --bus 7 setvcp 10 + 10";
              "on-scroll-down" = "ddcutil --noverify --bus 7 setvcp 10 - 10";
              "on-click" = "ddcutil --noverify --bus 7 setvcp 10 0";
              "on-click-right" = "ddcutil --noverify --bus 7 setvcp 10 100";
              "interval" = 1;
              "tooltip" = false;
            };
          };
        };
      };
    };

    wayland.windowManager.hyprland = {
      enable = true;
      # package = hyprland;
      systemd.enable = true;
      systemd.enableXdgAutostart = true;
      xwayland.enable = true;
      #plugins = with plugins;
      #  [ # hyprbars
      #    borderspp
      #  ];
      settings = {
        exec-once = [
          "waybar"
          "hyprctl setcursor Qogir 24"
          "kwalletd6&"
          "wl-paste --watch cliphist store" # hook to store anything copied in cliphist
          "mako"
          "signal-desktop --password-store=kwallet6"
          ''
            gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"''
        ];
        env = ["QT_QPA_PLATFORMTHEME,qt6ct"];
        monitor = [
          # "eDP-1, 1920x1080, 0x0, 1"
          # "HDMI-A-1, 2560x1440, 1920x0, 1"
          "DP-3, preferred, 0x0, 1"
          "DP-2, preferred, 1920x0, 1"
          "DP-4, preferred, 1920x-2160, 1"
          "eDP-1, preferred, 5360x0, 1"
          ",preferred,auto,1"
        ];
        general = {
          layout = "dwindle";
          resize_on_border = true;
        };
        misc = {
          layers_hog_keyboard_focus = false;
          disable_splash_rendering = true;
          force_default_wallpaper = 0;
        };
        workspace = {

        };
        input = {
          kb_layout = "de";
          kb_variant = "nodeadkeys";
          kb_model = "pc104";
          follow_mouse = 1;
          touchpad = {
            natural_scroll = "yes";
            disable_while_typing = true;
            drag_lock = true;
          };
          sensitivity = 0;
          float_switch_override_focus = 2;
        };
        binds = { allow_workspace_cycles = true; };
        dwindle = {
          pseudotile = "yes";
          preserve_split = "yes";
        };
        gestures = {
          workspace_swipe = true;
          workspace_swipe_forever = true;
        };
        windowrule = let f = regex: "float, ^(${regex})$";
        in [
          (f "org.gnome.Calculator")
          (f "org.gnome.Nautilus")
          (f "pavucontrol")
          (f "nm-connection-editor")
          (f "blueberry.py")
          (f "org.gnome.Settings")
          (f "org.gnome.design.Palette")
          (f "Color Picker")
          (f "xdg-desktop-portal")
          (f "xdg-desktop-portal-gnome")
          (f "transmission-gtk")
          (f "com.github.Aylur.ags")
          "workspace 7, title:Spotify"
        ];
        bind = let
          binding = mod: cmd: key: arg: "${mod}, ${key}, ${cmd}, ${arg}";
          mvfocus = binding "SUPER" "movefocus";
          resizeactive = binding "SUPER ALT SHIFT" "resizeactive";
          mvactive = binding "SUPER SHIFT" "moveactive";
          ws = binding "SUPER CTRL" "workspace";
          mvtows = binding "SUPER CTRL SHIFT" "movetoworkspace";
          e = "exec, ";
          arr = [ 1 2 3 4 5 6 7 8 9 ];
        in [
          (mvfocus "up" "u")
          (mvfocus "down" "d")
          (mvfocus "right" "r")
          (mvfocus "left" "l")
          (ws "0" "0")
          (ws "1" "1")
          (ws "2" "2")
          (ws "3" "3")
          (ws "4" "4")
          (ws "5" "5")
          (ws "6" "6")
          (ws "7" "7")
          (ws "8" "8")
          (ws "9" "9")
          (ws "left" "-1")
          (ws "right" "+1")
          (mvtows "0" "0")
          (mvtows "1" "1")
          (mvtows "2" "2")
          (mvtows "3" "3")
          (mvtows "4" "4")
          (mvtows "5" "5")
          (mvtows "6" "6")
          (mvtows "7" "7")
          (mvtows "8" "8")
          (mvtows "9" "9")
          (mvtows "left" "e-1")
          (mvtows "right" "e+1")
          (resizeactive "up" "0 -40")
          (resizeactive "down" "0 40")
          (resizeactive "right" "40 0")
          (resizeactive "left" "-40 0")
          (mvactive "up" "0 -20")
          (mvactive "down" "0 20")
          (mvactive "right" "20 0")
          (mvactive "left" "-20 0")
          ", XF86PowerOff, ${e} -t powermenu"
          "SUPER, Tab,     ${e} -t overview"
          ",Print,    exec, /home/l/s/screenshot.sh"
          "SUPER, T, exec, /home/l/s/translator.sh"
          #-t png - | ${pkgs.swappy}/bin/swappy -f - -o - |${pkgs.oxipng}/bin/oxipng - |wl-copy'"
          "SUPER, R,       exec, ${pkgs.wofi}/bin/wofi --show run"
          "SUPER, Return, exec, wezterm" # xterm is a symlink, not actually xterm
          "SUPER, N, exec, zen --enable-transparent-background"
          "SUPER, E, exec, dolphin"
          "SUPER SHIFT, L, exec, hyprlock --immediate"
          "SUPER, V, exec, cliphist list | ${pkgs.wofi}/bin/wofi --dmenu | cliphist decode | wl-copy"
          "SUPER CTRL ALT SHIFT, V, exec, cliphist list | ${pkgs.wofi}/bin/wofi --dmenu | cliphist delete"
          "ALT, Tab, focuscurrentorlast"
          "CTRL ALT, Delete, exit"
          "SUPER SHIFT, Q, killactive"
          "SUPER, F, togglefloating"
          "SUPER, M, fullscreen"
          "SUPER, P, togglesplit"
        ] ++ (map (i: ws (toString i) (toString i)) arr)
        ++ (map (i: mvtows (toString i) (toString i)) arr);

        bindle = let e = "exec, ";
        in [
          ",XF86MonBrightnessUp,   ${e} 'ddcutil --display 1 setvcp 10 + 5& ddcutil --display 2 setvcp 10 + 5& ddcutil --display 3 setvcp 10 + 5& ddcutil --display 4 setvcp 10 + 5& ddcutil --display 5 setvcp 10 + 5& brightnessctl s 10%+&'"
          ",XF86MonBrightnessDown,   ${e} 'ddcutil --display 1 setvcp 10 - 5& ddcutil --display 2 setvcp 10 - 5& ddcutil --display 3 setvcp 10 - 5& ddcutil --display 4 setvcp 10 - 5& ddcutil --display 5 setvcp 10 - 5& brightnessctl s 10%-&'"
          ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"
          ", XF86AudioLowerVolume, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%-"
        ];
        bindl = let e = "exec, ";
        in [
          ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          ",XF86AudioMicMute, ${e} 'wpctl set-mute  @DEFAULT_AUDIO_SOURCE@ toggle'"
          ",F20, ${e} 'wpctl set-mute  @DEFAULT_AUDIO_SOURCE@ toggle'"
          ",XF86AudioPlay,    ${e} '${pkgs.playerctl}/bin/playerctl play-pause'"
          ",XF86AudioStop,    ${e} '${pkgs.playerctl}/bin/playerctl play-pause'"
          ",XF86AudioPause,   ${e} '${pkgs.playerctl}/bin/playerctl play-pause'"
          ",XF86AudioPrev,    ${e} '${pkgs.playerctl}/bin/playerctl previous'"
          ",XF86AudioNext,    ${e} '${pkgs.playerctl}/bin/playerctl next'"
        ];
        bindm =
          [ "SUPER, mouse:273, resizewindow" "SUPER, mouse:272, movewindow" ];
        decoration = {
          dim_inactive = false;
          blur = {
            enabled = true;
            size = 8;
            passes = 3;
            new_optimizations = "on";
            noise = 1.0e-2;
            contrast = 0.9;
            brightness = 0.8;
          };
        };
        animations = {
          enabled = "yes";
          bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
          animation = [
            "windows, 1, 5, myBezier"
            "windowsOut, 1, 7, default, popin 80%"
            "border, 1, 10, default"
            "fade, 1, 7, default"
            "workspaces, 1, 6, default"
          ];
        };
        misc.vfr = true;
        # plugin = {
        #   hyprbars = {
        #     bar_color = "rgb(2a2a2a)";
        #     bar_height = 28;
        #     col_text = "rgba(ffffffdd)";
        #     bar_text_size = 11;
        #     bar_text_font = "Ubuntu Nerd Font";

        #     buttons = {
        #       button_size = 0;
        #       "col.maximize" = "rgba(ffffff11)";
        #       "col.close" = "rgba(ff111133)";
        #     };
        #   };
        # };
      };
    };
  };
}
