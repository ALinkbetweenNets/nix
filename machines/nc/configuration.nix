# 202.61.251.70
#	2a03:4000:54:8a::/64
# nix run github:numtide/nixos-anywhere -- --flake .#nc root@202.61.251.70

# TODO: remove hardware stuff from config module!
# -> bootloader
# -> energy stuff
# -> etc.
# Then everything should work.
# Those things always should be opt in!

{ self, ... }:
{ pkgs, lib, config, flake-self, home-manager, ... }: {
  imports = [
    ./netcup.nix
    home-manager.nixosModules.home-manager
  ];
  home-manager.users.l = flake-self.homeConfigurations.server;
  # home-manager.users.root = flake-self.homeConfigurations.server;
  link = {
    common.enable = true;
    eth = "ens3";
    # fail2ban.enable = true;
    # coturn.enable = true;
    # nginx.enable = true;
  };
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "server";
    extraUpFlags = [ "--advertise-exit-node" ];
  };
  # services.openssh.settings.PermitRootLogin = lib.mkForce "prohibit-password";
  # security.sudo.wheelNeedsPassword = true;

  lollypops.deployment = {
    local-evaluation = true;
    ssh = { host = "202.61.251.70"; user = "root"; };
  };

  networking = {
    hostName = "v2202312204123249185";
    domain = "ultrasrv.de";
    interfaces."ens3" = {
      ipv6.addresses = [{
        address = "2a03:4000:54:8a:585a:48ff:fee3:9d06";
        prefixLength = 64;
      }];
    };
    nat.externalInterface = "ens3";
    # firewall = { allowedTCPPorts = [ 80 443 ]; };
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
