{ lib, pkgs, config, ... }:
with lib;
let cfg = config.link.xserver;
in {
  options.link.xserver.enable = mkEnableOption "activate xserver";
  config = mkIf cfg.enable {
    # Enable the X11 windowing system.
    services = {
      libinput = {
        enable = true;
        touchpad.accelProfile = "adaptive";
      };
      xserver = {
        enable = true;
        autorun = true;
        xkb = {
          layout = "de";
          variant = "nodeadkeys";
          options = "eurosign:e,caps:escape";
        };
        desktopManager = {
          xterm.enable = false;
          session = [{
            name = "home-manager";
            start = ''
              export `dbus-launch`
              ${pkgs.runtimeShell} $HOME/.hm-xsession &
               waitPID=$!
            '';
          }];
        };
      };
    };
    # Enable pulseaudio compatible api for audio volume control in i3
    # services.pipewire.pulse.enable = true;
    environment.systemPackages = with pkgs; [ xclip xdotool ];
  };
}
