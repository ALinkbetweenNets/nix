{ lib, pkgs, config, ... }:
with lib;
let cfg = config.link.programs.waybar;
in {
  options.link.programs.waybar.enable = mkEnableOption "enable waybar";
  config = mkIf cfg.enable {

    # Applets, shown in tray
    services = {
      # Networking
      network-manager-applet.enable = true;
      # Bluetooth
      blueman-applet.enable = true;
      # Pulseaudio
      pasystray.enable = true;
      # Battery Warning
      cbatticon.enable = true;
    };

    programs.waybar = {
      enable = true;

      style =
        let c = config.pinpox.colors;
        in ''
          @define-color Black #${c.Black};
          @define-color BrightBlack #${c.BrightBlack};
          @define-color White #${c.White};
          @define-color BrightWhite #${c.BrightWhite};
          @define-color Yellow #${c.Yellow};
          @define-color BrightYellow #${c.BrightYellow};
          @define-color Green #${c.Green};
          @define-color BrightGreen #${c.BrightGreen};
          @define-color Cyan #${c.Cyan};
          @define-color BrightCyan #${c.BrightCyan};
          @define-color Blue #${c.Blue};
          @define-color BrightBlue #${c.BrightBlue};
          @define-color Magenta #${c.Magenta};
          @define-color BrightMagenta #${c.BrightMagenta};
          @define-color Red #${c.Red};
          @define-color BrightRed #${c.BrightRed};
          ${fileContents ./style.css}
        '';

      settings.mainbar = {
        layer = "top";
        position = "top";
        height = 30;
        output = [ "eDP-1" "HDMI-A-1" ];
        modules-left = [ "sway/workspaces" "sway/mode" "wlr/taskbar" ];
        modules-center = [ "sway/window" "custom/hello-from-waybar" ];
        modules-right = [ "mpd" "custom/mymodule#with-css-id" "temperature" ];

        "sway/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
        };
        "custom/hello-from-waybar" = {
          format = "hello {}";
          max-length = 40;
          interval = "once";
          exec = pkgs.writeShellScript "hello-from-waybar" ''
            echo "from within waybar"
          '';
        };
      };
    };

  };
}
