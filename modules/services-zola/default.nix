{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.link.zola;
in
{
  options.link.zola.enable = mkEnableOption "activate zola";
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ zola ];
    systemd.services.zola = {
      description = "zola";
      serviceConfig.ExecStart = ''
        cd /home/l/Blog\ of\ A\ Link\ Between\ Nets
        zola serve
      '';
      path = with pkgs; [ zola ];
      wantedBy = [ "multi-user.target" ]; # starts after login, reboot after first time rebuild
    };
    services.nginx.virtualHosts."blog.${config.link.domain}" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:1111";
      };
    };
  };
}
