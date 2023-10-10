{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.proxy;
in {
  options.link.proxy.enable = mkEnableOption "activate proxy";
  config = mkIf cfg.enable {

    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  };
}
