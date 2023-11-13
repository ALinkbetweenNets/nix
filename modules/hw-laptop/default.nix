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
    programs.ssh.startAgent = false;

    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
     environment.shellInit = ''
      export GPG_TTY="$(tty)"
      gpg-connect-agent /bye
      export SSH_AUTH_SOCK="/run/user/$UID/gnupg/S.gpg-agent.ssh"
    '';
    hardware.bluetooth.enable = true;
    services = {
      xserver.libinput.enable = true;
      auto-cpufreq = {
        enable = true; # TLP replacement
        settings = {
          battery = {
            governor = "powersave";
            turbo = "never";
          };
          charger = {
            governor = "performance";
            turbo = "auto";
          };
        };
      };
      tlp.settings = {
        USB_AUTOSUSPEND = 0;
      };
    };
    powerManagement = {
      enable = true;
      powertop.enable = true;
    };
  };
}
