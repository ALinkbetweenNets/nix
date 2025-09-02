{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.link.rofi;
  theme_content = ''
    /**
     * ROFI Color theme
     * Copyright: Dave Davenport
     */
    * {
        text-color: #f8f8f2;
        background-color: #282a3630;
        dark: #282a36;
        // Black
        black: #282a36;
        lightblack: #44475a;
        //
        // Red
        red: #ff5555;
        lightred: #ff6e6e;
        //
        // Green
        green: #50fa7b;
        lightgreen: #69ff94;
        //
        // Yellow
        yellow: #f1fa8c;
        lightyellow: #ffffa5;
        //
        // Blue
        blue: #bd93f9;
        lightblue: #d6acff;
        //
        // Magenta
        magenta: #ff79c6;
        lightmagenta: #ff92df;
        //
        // Cyan
        cyan: #8be9fd;
        lightcyan: #a4ffff;
        //
        // White
        white: #f8f8f2;
        lightwhite: #ffffff;
        //
        // Bold, Italic, Underline
        highlight:     bold #ffffff;
    }
    window {
        height:   100%;
        width: 30em;
        location: west;
        anchor:   west;
        border:  0px 2px 0px 0px;
        text-color: @lightwhite;
    }
    mode-switcher {
        border: 2px 0px 0px 0px;
        background-color: @lightblack;
        padding: 4px;
    }
    button selected {
        border-color: @lightgreen;
        text-color: @lightgreen;
    }
    inputbar {
        background-color: @lightblack;
        text-color: @lightgreen;
        padding: 4px;
        border: 0px 0px 2px 0px;
    }
    mainbox {
        expand: true;
        background-color: #1c1c1cee;
        spacing: 1em;
    }
    listview {
        padding: 0em 0.4em 0em 1em;
        dynamic: false;
        lines: 0;
    }
    element-text {
        background-color: inherit;
        text-color: inherit;
        vertical-align: 0.5;
        font: "Iosevka 24px";
    }
    element selected  normal {
        background-color: @blue;
    }
    element normal active {
        text-color: @lightblue;
    }
    element normal urgent {
        text-color: @lightred;
    }
    element alternate normal {
    }
    element alternate active {
        text-color: @lightblue;
    }
    element alternate urgent {
        text-color: @lightred;
    }
    element-icon {
        size: 50;
    }
    element selected active {
        background-color: @lightblue;
        text-color: @dark;
    }
    element selected urgent {
        background-color: @lightred;
        text-color: @dark;
    }
    error-message {
        expand: true;
        background-color: red;
        border-color: darkred;
        border: 2px;
        padding: 1em;
    }
  ''; # based on dracula theme
in
{
  options.link.rofi.enable = mkEnableOption "enable rofi";
  config = mkIf cfg.enable {
    home.packages = with pkgs; [ iosevka ];
    programs.rofi = {
      enable = true;
      font = "Iosevka 12";
      extraConfig = {
        modi = "window,run,ssh,combi";
        show-icons = true;
        icon-theme = "beauty-line";
        combi-modi = "window,drun,run";
      };
      theme = builtins.toFile "theme.rasi" theme_content;
    };
    # TODO Get rofi-emoji mode to work (https://github.com/Mange/rofi-emoji/issues/25)
    # It seems like the plugins have to be set inside the main configuration file (= not in home manager module)
  };
}
