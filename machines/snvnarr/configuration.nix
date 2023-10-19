{ self, ... }:
{ pkgs, lib, config, flake-self, home-manager, ... }: {
  imports = [
    ./hardware-configuration.nix
    home-manager.nixosModules.home-manager
  ];
  home-manager.users.l = flake-self.homeConfigurations.server;
  link = {
    arr.enable = true;
    systemd-boot.enable = false;
    grub.enable = true;
    vm.enable = true;
  };
  networking.hostName = "snvnarr";
  boot.loader.grub.device = "/dev/vda";
  services.mullvad-vpn.enable = true;
  services.mullvad-vpn.package = pkgs.mullvad-vpn; # gui version
}
