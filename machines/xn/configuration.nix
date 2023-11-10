{ self, ... }:
{ pkgs, lib, config, flake-self, home-manager, ... }: {
  imports = [
    ./hardware-configuration.nix
    home-manager.nixosModules.home-manager
  ];
  home-manager.users.l = flake-self.homeConfigurations.convertible;
  link = {
    convertible.enable = true;
    main.enable = true;
    cpu-intel.enable = true;
    secrets = "/home/l/.keys";
    wireguard.enable = true;
    wg-deep.enable = true;
    wg-link.enable = true;
    domain = "xn.local";
  };
  networking = {
    extraHosts =
      ''
        127.0.0.1 xn.local
      '';
    hostName = "xn";
  };
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  #environment.systemPackages = with pkgs;    [ ];
}
