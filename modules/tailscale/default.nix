{
  config,
  system-config,
  pkgs,
  lib,
  ...
}:
with lib;
let
  cfg = config.link.tailscale;
in
{
  options.link.tailscale = {
    enable = mkEnableOption "activate tailscale";
    routing = mkOption {
      type = types.str;
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
      extraUpFlags =
        [ ]
        ++ lib.optionals (cfg.advertise-exit-node) [
          "--advertise-exit-node"
        ]
      # ++ lib.optionals (config.link.unbound.enable) [ "--accept-dns=false" ]
      ;
    };
    services.networkd-dispatcher = lib.mkIf (cfg.routing != "client") {
      enable = true;
      rules."50-tailscale" = {
        onState = [ "routable" ];
        script = ''
          NETDEV="$(ip -o route get 8.8.8.8 | cut -f 5 -d " ")"
            "${pkgs.ethtool}" -K "$NETDEV" rx-udp-gro-forwarding on rx-gro-list off
        '';
      };
    };
    environment.systemPackages = with pkgs; [
      ethtool
      networkd-dispatcher
    ];
  };
}
