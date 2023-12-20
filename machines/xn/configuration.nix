{ self, ... }:
{ pkgs, lib, config, flake-self, home-manager, ... }: {
  imports = [
    ./hardware-configuration.nix
    home-manager.nixosModules.home-manager
    flake-self.inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x13-yoga
  ];
  hardware.enableRedistributableFirmware = true;
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
    service-ip = "127.0.0.1";
    xrdp.enable = true;
    eth = "wlp0s20f3";
  };
  networking = {
    hostName = "xn";
  };
  services.throttled.enable = true;
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  lollypops.deployment = {
    local-evaluation = true;
    # ssh = { user = "l"; };
    # sudo.enable = true;
  };
  #environment.systemPackages = with pkgs;    [ ];
}
