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
    service-ip = "127.0.0.1";

  };
  networking = {
    extraHosts =
      ''
        127.0.0.1 xn.local
        127.0.0.1 hedgedoc.xn.local
        10.0.0.1 nextcloud.deepserver.org
        10.0.0.1 matrix.deepserver.org
        10.0.0.1 hedgedoc.deepserver.org
        10.0.0.1 onlyoffice.deepserver.org
        10.0.0.1 vaultwarden.deepserver.org
      '';
    hostName = "xn";
  };
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client";
  };
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  lollypops.deployment = {
    local-evaluation = true;
    ssh = { user = "l"; };
    sudo.enable = true;
  };
  #environment.systemPackages = with pkgs;    [ ];
}
