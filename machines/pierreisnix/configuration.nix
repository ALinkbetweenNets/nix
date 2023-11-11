{ self, ... }:
{ pkgs, lib, config, flake-self, home-manager, ... }: {
  imports = [
    ./hardware-configuration.nix
    home-manager.nixosModules.home-manager
  ];
  link = {
    laptop.enable = true;
    main.enable = true;
    cpu-amd.enable = true;
    nvidia.enable = true;
    plasma.enable = lib.mkForce false;
    gnome.enable = true;
    users.l.enable = lib.mkForce false;
    users.pierre.enable = true;
  };
  networking.hostName = "pierreisnix";
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ]; # Is this needed?
  environment.systemPackages = with pkgs; [ fish ];
  #system.stateVersion = "23.05";
}
