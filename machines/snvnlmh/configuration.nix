{ self, ... }:
{ pkgs, lib, config, flake-self, home-manager, ... }: {
  imports = [
    ./hardware-configuration.nix
    home-manager.nixosModules.home-manager
  ];
  home-manager.users.l = flake-self.homeConfigurations.server;
  link = {
    # systemd-boot.enable = false;
    # grub.enable = true;
    vm.enable = true;
  };
  networking.hostName = "snvnlmh";
  boot.loader.grub.device = "/dev/vda";
  # services.mullvad-vpn.enable = true;
  # services.mullvad-vpn.package = pkgs.mullvad-vpn; # gui version
  # fileSystems."arra" = {
  #   device = "arra"; # Replace with the correct device or path
  #   fsType = "9p"; # Replace with the filesystem type
  #   mountPoint = "${config.link.storage}";
  #   options = [ "trans=virtio" ];
  # };
  # services.tailscale = {
  #   enable = true;
  #   useRoutingFeatures = "server";
  #   extraUpFlags = [ "--advertise-exit-node" ];
  # };
  lollypops.deployment = {
    local-evaluation = true;
    # ssh.host = "192.168.122.5";
  };
}
