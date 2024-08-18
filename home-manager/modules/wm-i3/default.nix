{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.link.i3;
  suspend-pc = pkgs.writeShellScriptBin "suspend-pc" # sh
    ''
      i3lock -i ${./wallpaper.png} && systemctl suspend
    '';
  theme_content = ''
    idle_bg = "#282a36" # Background
    idle_fg = "#6272a4" # Comment
    info_bg = "#6272a4" # Comment
    info_fg = "#282a36" # Background
    good_bg = "#50fa75" # Green
    good_fg = "#2e3440" # nord0 - To adjust
    warning_bg = "#ffb86c" # Orange
    warning_fg = "#282a36" # Background
    critical_bg = "#ff5555" # Red
    critical_fg = "#282a36" # Background
    separator = "\ue0b2"
    separator_bg = "auto"
    separator_fg = "auto"
  ''; # based on dracula theme
in {
  options.link.i3.enable = mkEnableOption "activate i3";
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      arandr
      feh
      flameshot
      i3lock
      konsole
      playerctl # musik controlls for pipewire/pulse
      suspend-pc
    ];
    #++ lib.optionals (config.link.options.type == "desktop") [ ]
    #++ lib.optionals (config.link.options.type == "laptop") [ ];
    services = {
      dunst.enable = true; # notification daemon
      network-manager-applet.enable = true;
      pasystray.enable = true;
      flameshot.enable = true;
    };
    # rofi
    link.rofi.enable = true;
    xsession.enable = true;
    xsession.scriptPath = ".hm-xsession";
    xsession.windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      config = rec {
        # Set modifier to WIN
        modifier = "Mod4";
        menu = "${pkgs.rofi}/bin/rofi -show combi";
        terminal = "${pkgs.konsole}/bin/konsole";
        defaultWorkspace = "workspace number 1";
        bars = [{
          fonts = [ "FontAwesome 11" ];
          position = "top";
          statusCommand =
            "${pkgs.i3status-rust}/bin/i3status-rs ~/.config/i3status-rust/config-top.toml";
        }];
        startup = [{
          command = "${pkgs.feh}/bin/feh --bg-fill ${./wallpaper.png}";
          always = false;
          notification = false;
        }];
        programs.i3status-rust = {
          enable = true;
          bars = {
            top = {
              icons = "awesome5";
              theme = builtins.toFile "dracula-custom.toml" theme_content;
              blocks = mkMerge [[
                # for all system types
                {
                  block = "focused_window";
                  format = " $title |";
                }
                {
                  block = "music";
                  format =
                    "$icon {$combo.str(max_w:75,rot_interval:0.5) $prev $play $next } | $icon No Music";
                }
                {
                  block = "disk_space";
                  info_type = "used";
                  format = " {$icon} {$used}/{$total}";
                  warning = 80;
                  alert = 95;
                }
                {
                  block = "memory";
                  format =
                    " $icon {$mem_used}/{$mem_total}({$mem_used_percents})";
                  format_alt =
                    " $icon {$swap_used}/{$swap_total}({$swap_used_percents})";
                  interval = 5;
                  warning_mem = 80;
                  warning_swap = 80;
                  critical_mem = 95;
                  critical_swap = 95;
                }
                {
                  block = "cpu";
                  interval = 1;
                  format = " $icon {$barchart} {$utilization}";
                }
                {
                  block = "sound";
                  max_vol = 100;
                }
                {
                  block = "time";
                  interval = 60;
                }
              ]
              #(mkIf (config.link.options.type == "laptop") [
              #  {
              #    block = "backlight";
              #    invert_icons = true;
              #  }
              #  {
              #    block = "battery";
              #    driver = "sysfs";
              #  }
              #])
              #
              #(mkIf (config.link.options.type == "desktop") [
              #])
                ];
            };
          };
        };
        keybindings = lib.mkOptionDefault ((lib.attrsets.mergeAttrsList [
          # general keybindings not specific to laptop or desktop
          (lib.optionalAttrs true {
            "Mod1+space" = "exec ${pkgs.rofi}/bin/rofi -show combi";
            "${modifier}+Mod1+space" = "exec ${pkgs.rofi}/bin/rofi -show emoji";
            "${modifier}+Shift+Tab" = "workspace prev";
            "${modifier}+Tab" = "workspace next";
            "XF86AudioLowerVolume" =
              "exec --no-startup-id pactl set-sink-volume 0 -5%"; # decrease sound volume
            "XF86AudioMute" =
              "exec --no-startup-id pactl set-sink-mute 0 toggle"; # mute sound
            "XF86AudioNext" = "exec playerctl next";
            "XF86AudioPlay" = "exec playerctl play-pause";
            "XF86AudioPrev" = "exec playerctl previous";
            "XF86AudioRaiseVolume" =
              "exec --no-startup-id pactl set-sink-volume 0 +5% #increase sound volume";
            "XF86AudioStop" = "exec playerctl stop";
            "Print" = "exec flameshot gui";
            "${modifier}+Shift+s" = "exec ${pkgs.flameshot}/bin/flameshot gui";
            "${modifier}+l" = "exec i3lock -i ${./wallpaper.png}";
          })
          # desktop specific keybindings
          #(lib.optionalAttrs (config.link.options.type == "desktop") { })
          # laptop specific keybindings
          #(lib.optionalAttrs (config.link.options.type == "laptop") {
          #  "XF86MonBrightnessUp" = "exec --no-startup-id ${pkgs.brightnessctl}/bin/brightnessctl set 5%+";
          #  "XF86MonBrightnessDown" = "exec --no-startup-id ${pkgs.brightnessctl}/bin/brightnessctl set 5%-";
          #})
        ]));
      };
    };
  };
}
