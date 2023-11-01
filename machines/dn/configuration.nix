{ self, ... }:
{ pkgs, lib, config, flake-self, home-manager, ... }: {
  imports = [
    ./hardware-configuration.nix
    home-manager.nixosModules.home-manager
  ];
  home-manager.users.l = flake-self.homeConfigurations.tower;
  link = {
    tower.enable = true;
    main.enable = true;
    cpu-intel.enable = true;
    nvidia.enable = true;
    secrets = "/home/l/.keys";
    wireguard.enable = true;
    wg-deep.enable = true;
  };
  networking = {
    hostName = "dn";
    hostId = "007f0200";
    interfaces."enp111s0".wakeOnLan.enable = true;
  };
  environment.systemPackages = with pkgs; [ davinci-resolve ];
}
