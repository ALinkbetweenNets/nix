{ pkgs, lib, config, ... }:
with lib;
let cfg = config.mayniklas.sway;
in
{

  options.mayniklas.sway = {
    enable = mkEnableOption "activate sway";
  };

  config = mkIf cfg.enable {

    link = {
      wayland.enable = true;
      plasma.enable = mkForce false;
      xserver.enable = mkForce false;

    };
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd start-sway";
          user = "greeter";
        };

        river_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd start-river";
          user = "greeter";
        };
      };
    };
    home-manager.users."l" = {
      mayniklas.programs = {
        sway.enable = true;
        swaylock.enable = true;
      };
      home.packages = [ ];
    };

  };

}
