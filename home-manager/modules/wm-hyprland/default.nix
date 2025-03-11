{ lib, config, pkgs, ... }:
with lib;
let cfg = config.link.hyprland;
in {
  options.link.hyprland.enable = mkEnableOption "activate hyprland";
  config = mkIf cfg.enable {
    link.programs.wofi.enable = true;
    # home.packages = [ launcher ];

    # xdg.desktopEntries."org.gnome.Settings" = {
    #   name = "Settings";
    #   comment = "Gnome Control Center";
    #   icon = "org.gnome.Settings";
    #   exec =
    #     "env XDG_CURRENT_DESKTOP=gnome ${pkgs.gnome.gnome-control-center}/bin/gnome-control-center";
    #   categories = [ "X-Preferences" ];
    #   terminal = false;
    # };
    programs.fuzzel = {
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
    programs.hyprlock = {
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
    services.hypridle = {
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

    wayland.windowManager.hyprland = {
      enable = true;
      # package = hyprland;
      systemd.enable = true;
      xwayland.enable = true;
      # plugins = with plugins; [ hyprbars borderspp ];

      settings = {
        exec-once = [
          "ags -b hypr"
          "hyprctl setcursor Qogir 24"
          "transmission-gtk"
          "wl-paste --watch cliphist store"
        ];

        monitor = [
          # "eDP-1, 1920x1080, 0x0, 1"
          # "HDMI-A-1, 2560x1440, 1920x0, 1"
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
          ws = binding "SUPER CTRL" "workspace";
          resizeactive = binding "SUPER ALT SHIFT" "resizeactive";
          mvactive = binding "SUPER SHIFT" "moveactive";
          mvtows = binding "SUPER CTRL SHIFT" "movetoworkspace";
          e = "exec, ags -b hypr";
          arr = [ 1 2 3 4 5 6 7 8 9 ];
          # yt = pkgs.writeShellScriptBin "yt" ''
          #   notify-send "Opening video" "$(wl-paste)"
          #   mpv "$(wl-paste)"
          # '';
        in [
          "CTRL SHIFT, R,  ${e} quit; ags -b hypr"
          ", XF86PowerOff, ${e} -t powermenu"
          "SUPER, Tab,     ${e} -t overview"
          # ", XF86Launch4,  ${e} -r 'recorder.start()'"
          # ",Print,         ${e} -r 'recorder.screenshot()'"
          "SHIFT,Print,    ${e} -r 'recorder.screenshot(true)'"
          "SUPER, R,       exec, ${pkgs.wofi}/bin/wofi --show run"
          "SUPER, Return, exec, wezterm" # xterm is a symlink, not actually xterm
          "SUPER, N, exec, zen --enable-transparent-background"
          "SUPER, E, exec, dolphin"
          "SUPER SHIFT, L, exec, hyprlock --immediate"
          "SUPER, V, exec, cliphist list | ${pkgs.fuzzel}/bin/fuzzel --dmenu | cliphist decode | wl-copy"
          "SUPER CTRL ALT SHIFT, V, exec, cliphist list | ${pkgs.fuzzel}/bin/fuzzel --dmenu | cliphist delete"

          # youtube
          # ", XF86Launch1,  exec, ${yt}/bin/yt"

          "ALT, Tab, focuscurrentorlast"
          "CTRL ALT, Delete, exit"
          "SUPER SHIFT, Q, killactive"
          "SUPER, F, togglefloating"
          "SUPER, M, fullscreen"
          "SUPER, P, togglesplit"

          (mvfocus "up" "u")
          (mvfocus "down" "d")
          (mvfocus "right" "r")
          (mvfocus "left" "l")
          (ws "left" "e-1")
          (ws "right" "e+1")
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
        ] ++ (map (i: ws (toString i) (toString i)) arr)
        ++ (map (i: mvtows (toString i) (toString i)) arr);

        bindle = let e = "exec, ags -b hypr -r";
        in [
          ",XF86MonBrightnessUp,   ${e} 'brightness.screen += 0.05; indicator.display()'"
          ",XF86MonBrightnessDown, ${e} 'brightness.screen -= 0.05; indicator.display()'"
          ",XF86KbdBrightnessUp,   ${e} 'brightness.kbd++; indicator.kbd()'"
          ",XF86KbdBrightnessDown, ${e} 'brightness.kbd--; indicator.kbd()'"
          ",XF86AudioRaiseVolume,  ${e} 'audio.speaker.volume += 0.05; indicator.speaker()'"
          ",XF86AudioLowerVolume,  ${e} 'audio.speaker.volume -= 0.05; indicator.speaker()'"
        ];

        bindl = let e = "exec, ags -b hypr -r";
        in [
          ",XF86AudioPlay,    ${e} 'mpris?.playPause()'"
          ",XF86AudioStop,    ${e} 'mpris?.stop()'"
          ",XF86AudioPause,   ${e} 'mpris?.pause()'"
          ",XF86AudioPrev,    ${e} 'mpris?.previous()'"
          ",XF86AudioNext,    ${e} 'mpris?.next()'"
          ",XF86AudioMicMute, ${e} 'audio.microphone.isMuted = !audio.microphone.isMuted'"
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

        plugin = {
          hyprbars = {
            bar_color = "rgb(2a2a2a)";
            bar_height = 28;
            col_text = "rgba(ffffffdd)";
            bar_text_size = 11;
            bar_text_font = "Ubuntu Nerd Font";

            buttons = {
              button_size = 0;
              "col.maximize" = "rgba(ffffff11)";
              "col.close" = "rgba(ff111133)";
            };
          };
        };
      };
    };
    # wayland.windowManager.hyprland = {

    #   enable = true;
    #   enableNvidiaPatches = lib.mkIf options.link.nvidia.enable true;
    #   settings = {
    #     decoration = {
    #       shadow_offset = "0 5";
    #       "col.shadow" = "rgba(00000099)";
    #     };
    #     "$mod" = "SUPER";
    #     bindm = [
    #       # mouse movements
    #       "$mod, mouse:272, movewindow"
    #       "$mod, mouse:273, resizewindow"
    #       "$mod ALT, mouse:272, resizewindow"
    #     ];
    #   };
    #   systemd.enable = true;
    # };
  };
}
