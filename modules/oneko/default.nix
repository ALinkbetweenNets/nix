{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.link.oneko;
in
{
  options.link.oneko.enable = mkEnableOption "activate oneko";
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ oneko ];
    systemd.user.services.oneko = {
      description = "oneko";
      serviceConfig.PassEnvironment = "DISPLAY";
      script = ''
        oneko -sakura
      '';
      path = with pkgs; [ oneko ];
      wantedBy = [ "multi-user.target" ]; # starts after login, reboot after first time rebuild
    };
  };
}
