{ self, ... }:
{ pkgs, lib, config, flake-self, home-manager, ... }: {
  imports = [
    ./hardware-configuration.nix
    home-manager.nixosModules.home-manager
  ];
  home-manager.users.l = flake-self.homeConfigurations.server;
  home-manager.users.root = flake-self.homeConfigurations.server;
  link = {
    arr.enable = true;
    systemd-boot.enable = false;
    grub.enable = true;
    vm.enable = true;
    storage = "/arr";
  };
  networking.hostName = "snvnarr";
  boot.loader.grub.device = "/dev/vda";
  services.mullvad-vpn.enable = true;
  services.mullvad-vpn.package = pkgs.mullvad-vpn; # gui version
  fileSystems."arra" = {
    device = "arra"; # Replace with the correct device or path
    fsType = "9p"; # Replace with the filesystem type
    mountPoint = "${config.link.storage}";
    options = [ "trans=virtio" ];
  };
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "server";
    extraUpFlags = [ "--advertise-exit-node" ];
  };
}
