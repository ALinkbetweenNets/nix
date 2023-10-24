{ self, ... }:
{ pkgs, lib, config, flake-self, home-manager, ... }: {
  imports = [
    ./hardware-configuration.nix
    home-manager.nixosModules.home-manager
  ];
  home-manager.users.l = flake-self.homeConfigurations.server;
  link = {
    common.enable = true;
    grub.enable = true;
    systemd-boot.enable = false;
    hardware.enable = true;
    cpu-amd.enable = true;
  };
  security.sudo.wheelNeedsPassword = true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  networking.hostName = "deepserver.org";
}
