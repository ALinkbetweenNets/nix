{ config, flake-self, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.docker;
in {
  options.link.docker = { enable = mkEnableOption "activate docker"; };
  config = mkIf cfg.enable {
    virtualisation.docker = {
      enable = true;
      # rootless = {
      #   enable = true;
      #   setSocketVariable = true;
      # };
    };
    environment.systemPackages = with pkgs; [
      docker
      # docker-compose
      docker-buildx
    ];
  };
}
