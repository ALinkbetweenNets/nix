{ self, ... }:
{ pkgs, lib, config, flake-self, home-manager, ... }: {
  imports = [
    ./hardware-configuration.nix
    home-manager.nixosModules.home-manager
  ];
  # home-manager.users.l = flake-self.homeConfigurations.server;
  # home-manager.users.root = flake-self.homeConfigurations.server;
  link = {
    common.enable = true;
    grub.enable = true;
    systemd-boot.enable = false;
    # hardware.enable = true;
    cpu-intel.enable = true;
    eth = "eth0";
    # fail2ban.enable = true;
    # coturn.enable = true;
    # nginx.enable = true;
  };
  # services.tailscale = {
  #   enable = true;
  #   useRoutingFeatures = "server";
  #   extraUpFlags = [ "--advertise-exit-node" ];
  # };
  # services.openssh.settings.PermitRootLogin = lib.mkForce "prohibit-password";
  boot.loader.grub.devices = [ "/dev/vda" ];
  security.sudo.wheelNeedsPassword = true;
  networking = {
    hostName = "v2202312204123249185";
    domain = "ultrasrv.de";
    nat.externalInterface = config.link.eth; # used by wireguard
    # firewall = {
    #   allowedTCPPorts = [ 80 443 ];
    # };
  };
  lollypops.deployment = {
    local-evaluation = true;
    # ssh = { user = "l"; };
    # ssh = { host = "v2202312204123249185.ultrasrv.de"; };
    # sudo.enable = true;
  };
}
