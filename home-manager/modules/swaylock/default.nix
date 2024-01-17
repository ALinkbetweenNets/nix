{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.mayniklas.programs.swaylock;
in
{
  options.mayniklas.programs.swaylock.enable = mkEnableOption "enable swaylock";
  config = mkIf cfg.enable {

    # TODO:
    # suspend (lid closed) should trigger swaylock
    # swaylock & suspend should be possible without closing the lid
    # I need to understand, how Swaylock works. It seems to want my pw and fingerprint?

    programs = {
      swaylock = {
        enable = true;
        settings = {
          #  Turn the screen into the given color instead of white.
          color = "${config.pinpox.colors.Black}";
          # Sets the indicator to show even if idle.
          indicator-idle-visible = false;
          # Sets the indicator radius.
          indicator-radius = 100;
          # Sets the color of the line between the inside and ring.
          line-color = "${config.pinpox.colors.White}";
          # Show current count of failed authentication attempts.
          show-failed-attempts = true;
          # Sets the color of the ring of the indicator.
          ring-color = "${config.pinpox.colors.Green}";
          # Sets the color of the text.
          text-color = "${config.pinpox.colors.White}";
          # Sets the font of the text.
          font = "Berkeley Mono";
          # Sets a fixed font size for the indicator text.
          font-size = 24;
          # Sets the color of the inside of the indicator when invalid.
          inside-wrong-color = "${config.pinpox.colors.Red}";
          # When an empty password is provided, do not validate it.
          ignore-empty-password = true;
          # Sets the color of backspace highlight segments.
          bs-hl-color = "${config.pinpox.colors.Magenta}";
          # Sets the color of the layout text.
          layout-text-color = "${config.pinpox.colors.White}";
        };
      };
    };

    # TODO: this needs to be worked on!
    services = {
      swayidle = {
        enable = true;
        timeouts = [
          {
            timeout = 180;
            command = "${pkgs.swaylock}/bin/swaylock -fF && systemctl suspend";
          }
        ];
        events = [
          {
            event = "before-sleep";
            command = "${pkgs.swaylock}/bin/swaylock";
          }
        ];
      };
    };

  };
}
