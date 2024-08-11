{ lib, pkgs, config, ... }:
with lib;
let cfg = config.link.oneko;
in {
  options.link.oneko.enable = mkEnableOption "release oneko";
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ oneko ];
    systemd.user.services.oneko = {
      enable = true;
      description = "oneko";
      serviceConfig.PassEnvironment = "DISPLAY";
      script = ''
        oneko -sakura
      '';
      path = with pkgs; [ oneko ];
      wantedBy = [
        "graphical-session.target"
      ]; # starts after login, reboot after first time rebuild
      after = [ "network.target" ];
    };
  };
}
