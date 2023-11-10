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
    wg-link.enable = true;
    eth = "enp111s0";
    domain = "dn.local"; # testing domain
    services.matrix.enable = true;
  };
  networking = {
    hostName = "dn";
    hostId = "007f0200";
    interfaces."${config.link.eth}".wakeOnLan.enable = true;
    extraHosts =
      ''
        127.0.0.1 dn.local
        10.0.0.1 deepserver.org
      '';
  };
  #environment.systemPackages = with pkgs; [ davinci-resolve ];
}
