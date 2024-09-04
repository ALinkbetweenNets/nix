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
      storageDriver = "overlay2";
    };
    virtualisation.oci-containers = { backend = "docker"; };
    environment.systemPackages = with pkgs; [
      docker
      # docker-compose
      docker-buildx
      lazydocker # tui
    ];
  };
}
