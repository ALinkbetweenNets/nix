{ self, ... }:
{ pkgs, lib, config, flake-self, home-manager, ... }: {
  imports =
    [ ./hardware-configuration.nix home-manager.nixosModules.home-manager ];
  home-manager.users.l = flake-self.homeConfigurations.server;
  link = {
    common.enable = true;
    grub.enable = true;
    systemd-boot.enable = false;
    hardware.enable = true;
    cpu-amd.enable = true;
  };
  boot.loader.efi.canTouchEfiVariables = lib.mkForce false;
  boot.loader.grub.devices = [ "/dev/vda" ];
  security.sudo.wheelNeedsPassword = true;
  networking.hostName = "dnvnd";
}
