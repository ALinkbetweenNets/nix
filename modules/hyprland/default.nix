{ pkgs, lib, config, ... }:
with lib;
let cfg = config.link.hyprland;
in {

  options.link.hyprland = { enable = mkEnableOption "activate hyprland"; };
  config = mkIf cfg.enable {
    link = {
      wayland.enable = true;
      # plasma.enable = mkForce false;
      xserver.enable = mkForce false;
    };
    services.hypridle.enable = true;
    programs = {
      hyprland = {
        enable = true;
        xwayland.enable = true;
        withUWSM = true;
      };
      uwsm.enable = true;
      wayfire.enable = true;
      waybar.enable = false;
      hyprlock.enable = true;
      iio-hyprland.enable = true;
    };
    security.pam.services.hyprlock = { text = "auth include login"; };
    environment.systemPackages = with pkgs; [
      mako
      ags
      kitty # required for the default Hyprland config
      cliphist
      hyprpolkitagent
      waybar
      brightnessctl
      playerctl
      libnotify
      oxipng
      wofi
      grim
      swappy
      slurp
      rofi-wayland-unwrapped
      kdePackages.qt6ct
      xdg-desktop-portal-kde
    ];
    # xdg.portal = {
    #   enable = true;
    #   extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
    # };

    # systemd = {
    #   user.services.polkit-gnome-authentication-agent-1 = {
    #     description = "polkit-gnome-authentication-agent-1";
    #     wantedBy = [ "graphical-session.target" ];
    #     wants = [ "graphical-session.target" ];
    #     after = [ "graphical-session.target" ];
    #     serviceConfig = {
    #       Type = "simple";
    #       ExecStart =
    #         "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
    #       Restart = "on-failure";
    #       RestartSec = 1;
    #       TimeoutStopSec = 10;
    #     };
    #   };
    # };
    services = {
      gvfs.enable = true;
      #   devmon.enable = true;
      udisks2.enable = true;
      upower.enable = true;
      #   power-profiles-daemon.enable = true;
      accounts-daemon.enable = true;
      #   gnome = {
      #     evolution-data-server.enable = true;
      #     glib-networking.enable = true;
      #     gnome-keyring.enable = true;
      #   };
    };
    home-manager.users."l" = {
      link.hyprland.enable = true;
      home.packages = [ ];
    };
  };
}
