{ config, flake-self, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.docker;
in {
  options.link.docker = { enable = mkEnableOption "activate docker"; };
  config = mkIf cfg.enable {
    virtualisation.docker = {
      enable = true;
      autoPrune = {
        enable = true;
        dates = "weekly";
      };
    };
    virtualisation.oci-containers = {
      backend = "docker";
    };
    users.extraUsers.l.extraGroups =
      [ "docker" ];
    environment.systemPackages = with pkgs; [
      docker
      # docker-compose
      docker-buildx
    ];
  };
}
