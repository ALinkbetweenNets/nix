{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.outline;
in {
  options.link.outline.enable = mkEnableOption "activate outline";
  config = mkIf cfg.enable {
    services = {
      outline = {
        enable = true;
        port=3123;
        publicUrl="https://outline.alinkbetweennets.de";
      };
      nginx.virtualHosts."outline.alinkbetweennets.de" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = { proxyPass = "http://127.0.0.1:3123/"; };
      };
    };
  };
}
