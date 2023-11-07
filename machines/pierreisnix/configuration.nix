{ self, ... }:
{ pkgs, lib, config, flake-self, home-manager, ... }: {
  imports = [
    ./hardware-configuration.nix
    home-manager.nixosModules.home-manager
  ];
  home-manager.users.l = flake-self.homeConfigurations.convertible;
  link = {
    laptop.enable = true;
    main.enable = true;
    cpu-amd.enable = true;
    nvidia.enable = true;
    plasma.enable = lib.mkForce false;
    users.l.enable = lib.mkForce false;
    users.pierre.enable = true;
  };
  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  networking.hostName = "pierreisnix";
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ]; # Is this needed?
  environment.systemPackages = with pkgs;    [ fish ];
  #system.stateVersion = "23.05";
}
