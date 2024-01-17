{ config, pkgs, lib, ... }:
with lib;
let cfg = config.link.server;
in {
  options.link.server = { enable = mkEnableOption "activate server"; };
  config = mkIf cfg.enable {
    link = {
      tailscale.enable = true;
      tailscale.routing = "server";
    };
  };
}
