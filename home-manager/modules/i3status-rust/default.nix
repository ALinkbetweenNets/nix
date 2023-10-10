{ lib, pkgs, config, flake-self, system-config, ... }:
with lib;
let
  cfg = config.link.i3status-rust;
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
in
{

  options.link.i3status-rust.enable = mkEnableOption "activate i3status-rust";

  config = mkIf cfg.enable {

    programs.i3status-rust = {
      enable = true;
      bars = {
        top = {
          icons = "awesome5";
          theme = builtins.toFile "dracula-custom.toml" theme_content;
          blocks = mkMerge [
            [
              # for all system types
              {
                block = "focused_window";
                format = " $title |";
              }
              {
                block = "music";
                format = "$icon {$combo.str(max_w:75,rot_interval:0.5) $prev $play $next } | $icon No Music";
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
                format = " $icon {$mem_used}/{$mem_total}({$mem_used_percents})";
                format_alt = " $icon {$swap_used}/{$swap_total}({$swap_used_percents})";
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

  };
}
