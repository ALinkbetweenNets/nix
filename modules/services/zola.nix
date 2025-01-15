{ lib, pkgs, config, ... }:
with lib;
let cfg = config.link.zola;
in {
  options.link.zola.enable = mkEnableOption "activate zola";
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ zola ];
    systemd.services.zola = {
      description = "zola";
      serviceConfig.ExecStart = ''
        zola serve
      '';
      serviceConfig.WorkingDirectory = "/home/l/Blog of A Link Between Nets";
      path = with pkgs; [ zola ];
      confinement.packages = with pkgs; [ zola ];
      wantedBy = [
        "multi-user.target"
      ]; # starts after login, reboot after first time rebuild
    };
    services.nginx.virtualHosts."blog.${config.link.domain}" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = { proxyPass = "http://127.0.0.1:1111"; };
    };
  };
}
