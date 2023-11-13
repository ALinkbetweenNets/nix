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
    wireguard.enable = true;
    # services.jitsi.enable = true;
    expose = false;
    domain = "deepserver.org";
    service-ip = "10.0.0.1";
    eth = "eth0";
    service-interface = "wg-deep";
    services = {
      wg-deep.enable = true;
      matrix = { enable = true; expose = false; };
      nextcloud = { enable = true; expose = false; };
      hedgedoc = { enable = true; expose = false; };
    };
    nginx.enable = true;
  # };
  # services.tailscale = {
  #   enable = true;
  #   useRoutingFeatures = "server";
  #   extraUpFlags = [ "--advertise-exit-node" ];
  # };
  services.openssh.settings.PermitRootLogin = lib.mkForce "prohibit-password";
  boot.loader.grub.devices = [ "/dev/sda" "/dev/sdb" ];
  security.sudo.wheelNeedsPassword = true;
  networking = {
    hostName = "deepserver";
    domain = "org";
    nat.externalInterface = config.link.eth; # used by wireguard
    firewall = {
      allowedTCPPorts = [ 80 443 ];
    };
  };
}
