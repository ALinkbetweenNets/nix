{ config, flake-self, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.laptop;
in {
  options.link.laptop = { enable = mkEnableOption "activate laptop"; };
  config = mkIf cfg.enable {
    link = {
      desktop.enable = true;
      hardware.enable = true;
      #wireguard.enable = true;
      #wg-fritz.enable = true;
    };
    #options.type = "laptop";
    #networking.wireless.enable = !config.networking.networkmanager.enable;
    networking.networkmanager = {
      enableStrongSwan = true;
      wifi.macAddress = "stable";
    };
    hardware.bluetooth.enable = true;
    services = {
      libinput.enable = true;
      # power-profiles-daemon.enable = lib.mkForce false;
      # tlp.enable = lib.mkForce false;
      # auto-cpufreq = {
      #   enable = true; # TLP replacement # caps xn cpu clock to 1.3 Ghz
      #   settings = {
      #     battery = {
      #       governor = "powersave";
      #       turbo = "never";
      #     };
      #     charger = {
      #       governor = "performance";
      #       turbo = "auto";
      #     };
      #   };
      # };
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
