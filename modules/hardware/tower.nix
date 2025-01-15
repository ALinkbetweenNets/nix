{ config, flake-self, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.tower;
in {
  options.link.tower = { enable = mkEnableOption "activate tower laptop"; };
  config = mkIf cfg.enable {
    link.hardware.enable = true;
    link.desktop.enable = true;
    services = {
      power-profiles-daemon.enable = lib.mkForce false;
      tlp.enable = lib.mkForce false;
      auto-cpufreq = {
        enable = true; # TLP replacement
        settings = {
          charger = {
            governor = "performance";
            turbo = "auto";
            energy_performance_preference = "performance";
            platform_profile = "performance";
          };
        };
      };
    };
    powerManagement = { enable = true; };
  };
}
