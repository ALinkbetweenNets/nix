{ self, ... }:
{ pkgs, lib, config, flake-self, home-manager, ... }: {
  imports = [
    ./hardware-configuration.nix
    home-manager.nixosModules.home-manager
  ];
  home-manager.users.l = flake-self.homeConfigurations.tower;
  link = {
    tower.enable = true;
  };
  networking.hostId = "007f0200";
  networking.interfaces."enp111s0".wakeOnLan.enable = true;
  networking.hostName = "dn";
}
