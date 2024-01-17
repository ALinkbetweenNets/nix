{ pkgs, lib, config, ... }:
with lib;
let cfg = config.mayniklas.hyprland;
in
{

  options.mayniklas.hyprland = {
    enable = mkEnableOption "activate hyprland";
  };

  config = mkIf cfg.enable {

    link = {
      wayland.enable = true;
      plasma.enable = mkForce false;
      xserver.enable = mkForce false;

    };

    #home-manager.users."l" = {
    #  mayniklas.programs = {
    #    hyprland.enable = true;
    #    hyprlandlock.enable = true;
    #  };
    #  home.packages = [ ];
    #};

  };

}
