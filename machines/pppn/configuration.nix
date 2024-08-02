{ self, ... }:
{ config, lib, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
  ];
  networking.hostName = "pppn";
  # Use Network Manager
  networking.wireless.enable = false;
  networking.networkmanager.enable = true;
  # Use PulseAudio
  hardware.pulseaudio.enable = true;
  # Enable Bluetooth
  hardware.bluetooth.enable = true;
  # Bluetooth audio
  hardware.pulseaudio.package = pkgs.pulseaudioFull;
  # Enable power management options
  powerManagement.enable = true;
  # It's recommended to keep enabled on these constrained devices
  zramSwap.enable = true;
  # Auto-login for phosh
  services.xserver.desktopManager.phosh = {
    user = "l";
  };
  users.users."l" = {
    isNormalUser = true;
    description = "l";
    hashedPassword = "$6$.p.3CNgeNfys/lfs$C5ey0R0CMDlcebtek9bKoCfetajpwmvMG5LqRXzgFGOmLGqsvV.xTVcUtDKtj/c9WJRlv7WDyxIzU2BitOXIy1";
    extraGroups = [
      "dialout"
      "feedbackd"
      "networkmanager"
      "video"
      "wheel"
    ];
  };
  services.openssh.enable = true;
  services.openssh.openFirewall = true;
  services.openssh.startWhenNeeded = true;
}
