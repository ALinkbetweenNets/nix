{ config, flake-self, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.laptop;
in {
  options.link.laptop = { enable = mkEnableOption "activate laptop"; };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ wireless-regdb ];
    link = {
      desktop.enable = true;
      hardware.enable = true;
      # unbound.enable = true;
      #wireguard.enable = true;
      #wg-fritz.enable = true;
    };
    #options.type = "laptop";
    #networking.wireless.enable = !config.networking.networkmanager.enable;
    networking.networkmanager = { wifi.macAddress = "stable"; };
    hardware.bluetooth.enable = true;
    services = {
      libinput.enable = true;
      power-profiles-daemon.enable = lib.mkForce false;
      tlp.enable = false;
      auto-cpufreq = {
        enable = true; # TLP replacement
        settings = {
          charger = {
            governor = "performance";
            turbo = "auto";
            energy_performance_preference = "performance";
            platform_profile = "performance";
          };
          battery = {
            governor = "powersave";
            turbo = "never";
            energy_performance_preference = "power";
            platform_profile = "low-power";
          };
        };
      };
    };
    powerManagement = {
      enable = true;
      #powertop.enable = true; # no option to disable usb powersaving yet
    };
    systemd.sleep.extraConfig = ''
      AllowSuspend=yes
      AllowHibernation=yes
      AllowHybridSleep=yes
      AllowSuspendThenHibernate=yes
    '';
  };
}
