{ self, ... }:
{ pkgs, lib, config, flake-self, home-manager, ... }: {
  imports = [
    ./hardware-configuration.nix
    home-manager.nixosModules.home-manager
  ];
  home-manager.users.l = flake-self.homeConfigurations.server;
  link = {
    tower.enable = true;
  };
  # virtualisation.sharedDirectories = {
  #   arr = {
  #     source = "/rz/arr";
  #     target = "/mnt/arr";
  #   };
  # };

  boot.zfs.extraPools = [ "wdp" ];
  networking.interfaces."enp6s0".wakeOnLan.enable = true;
  networking.hostName = "sn";
  networking.hostId = "007f0200";
}
