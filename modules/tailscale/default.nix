{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.tailscale;
in {
  options.link.tailscale = {
    enable = mkEnableOption "activate tailscale";
    routing = mkOption {
      type = types.string;
      default = "client";
      description = "Routing Features, either server or client";
    };
    advertise-exit-node = mkOption {
      type = types.bool;
      default = cfg.routing == "server";
      description = "Routing Features, either server or client";
    };
  };
  config = mkIf cfg.enable {
    services.tailscale = {
      enable = true;
      useRoutingFeatures = "server";
      extraUpFlags = [ ] ++ lib.optionals (cfg.advertise-exit-node) [
        "--advertise-exit-node"
      ]
      # ++ lib.optionals (config.link.unbound.enable) [ "--accept-dns=false" ]
      ;
    };
  };
}
