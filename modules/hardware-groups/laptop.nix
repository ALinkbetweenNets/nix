{ config, flake-self, system-config, xr-linux-flake, pkgs, lib, ... }:
with lib;
let cfg = config.link.laptop;
in {
  imports = [ xr-linux-flake.nixosModules.default ];
  options.link.laptop = { enable = mkEnableOption "activate laptop"; };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      wireless-regdb
      kdePackages.kconfig

    ];
    services.xrlinuxdriver = { enable = true; };
    boot.extraModulePackages = [ config.boot.kernelPackages.evdi ];
    boot.initrd.kernelModules = [ "evdi" ];
    environment.variables = { KWIN_DRM_PREFER_COLOR_DEPTH = "24"; };
    systemd.services.displaylink-server = {
      enable = true;
      # Ensure it starts after udev has done its work
      requires = [ "systemd-udevd.service" ];
      after = [ "systemd-udevd.service" ];
      wantedBy = [ "multi-user.target" ]; # Start at boot
      # *** THIS IS THE CRITICAL 'serviceConfig' BLOCK ***
      serviceConfig = {
        Type =
          "simple"; # Or "forking" if it forks (simple is yecommon for daemons)
        # The ExecStart path points to the DisplayLinkManager binary provided by the package
        ExecStart = "${
            (pkgs.displaylink.overrideAttrs {
              src = pkgs.fetchurl {
                sha256 = "sha256-RJgVrX+Y8Nvz106Xh+W9N9uRLC2VO00fBJeS8vs7fKw=";
                url =
                  "https://www.synaptics.com/sites/default/files/exe_files/2024-10/DisplayLink%20USB%20Graphics%20Software%20for%20Ubuntu6.1-EXE.zip";
              };
            })
          }/bin/DisplayLinkManager";
        # User and Group to run the service as (root is common for this type of daemon)
        User = "root";
        Group = "root";
        # Environment variables that the service itself might need
        # Environment = [ "DISPLAY=:0" ]; # Might be needed in some cases, but generally not for this
        Restart = "on-failure";
        RestartSec = 5; # Wait 5 seconds before restarting
      };
    };
    link = {
      desktop.enable = true;
      hardware.enable = true;
      # unbound.enable = true;
      #wg-fritz.enable = true;
    };
    #options.type = "laptop";
    #networking.wireless.enable = !config.networking.networkmanager.enable;
    networking.networkmanager = { wifi.macAddress = "stable"; };
    hardware.bluetooth.enable = true;
    services = {
      libinput.enable = true;
      # power-profiles-daemon.enable = lib.mkForce false;
      tlp.enable = false;
      auto-cpufreq = {
        enable = false; # TLP replacement
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
