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
    users = { jucknath.enable = true; paul.enable = true; };
  };
  services.openssh.settings = {
    PermitRootLogin = lib.mkForce "prohibit-password";
  };
  boot.loader.grub.devices = [ "/dev/sda" "/dev/sdb" ];
  security.sudo.wheelNeedsPassword = true;
  networking.hostName = "deepserver";
}
