{ lib, pkgs, config, self, ... }:
with lib;
let cfg = config.link.dyndns;
in
{
  options.link.dyndns = {
    enable = mkEnableOption "activate dyndns";
    domains = mkOption {
      type = types.listOf types.str;
      default = [ config.link.domain ];
      description = "domains to update";
    };
  };
  config = mkIf cfg.enable {
    services.cloudflare-dyndns = {
      enable = true;
      apiTokenFile = config.sops.secrets."cloudflare-api".path;
      domains = cfg.domains;
    };
  };
}
