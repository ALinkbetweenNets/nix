{ config, lib, pkgs, flake-self, home-manager, ... }: {
  imports =
    [ ./hardware-configuration.nix home-manager.nixosModules.home-manager ];
  home-manager.users.l = flake-self.homeConfigurations.desktop;
  link = {
    desktop.enable = true;
    syncthing.enable = true;
    plasma.enable = false;
    xserver.enable = false;
    tailscale.enable = true;
  };

  # xdg.portal.extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
  networking = {
    hostName = "pppn";
    domain = "monitor-banfish.ts.net";
    # Use Network Manager
    wireless.enable = false;
    networkmanager.enable = true;
  };
  hardware = {
    bluetooth.enable = true;
    enableAllFirmware = true;
  };
  services = {
    # hardware.pulseaudio.enable = lib.mkForce true;
    # services.pipewire.enable =  lib.mkForce true;
    # Bluetooth audio
    pulseaudio.package = pkgs.pulseaudioFull;
    xserver.desktopManager.phosh = {
      # Auto-login for phosh
      enable = true;
      user = "l";
      group = "users";
    };
  };
  # Enable power management options
  powerManagement.enable = true;
  # It's recommended to keep enabled on these constrained devices
  zramSwap.enable = true;
  users.users."l" = {
    isNormalUser = true;
    description = "l";
    hashedPassword =
      "$6$.p.3CNgeNfys/lfs$C5ey0R0CMDlcebtek9bKoCfetajpwmvMG5LqRXzgFGOmLGqsvV.xTVcUtDKtj/c9WJRlv7WDyxIzU2BitOXIy1";
    extraGroups = [ "dialout" "feedbackd" "networkmanager" "video" "wheel" ];
  };
}
