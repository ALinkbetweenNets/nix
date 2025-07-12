{ pkgs, lib, config, flake-self, home-manager, ... }: {
  imports =
    [ ./hardware-configuration.nix home-manager.nixosModules.home-manager ];
  home-manager.users.l = flake-self.homeConfigurations.server;
  link = {
    # systemd-boot.enable = false;
    # grub.enable = true;
    # fs.btrfs.enable = true;
    vm.enable = true;
    fs.luks.enable = false; # DISABLE BEFORE INSTALL
    # tailscale.enable = true;
    # tailscale.routing = "server";
  };
  # You need to configure a root filesytem
  # fileSystems."/".label = "vmdisk";

  # Add a test user who can sudo to the root account for debugging
  users.extraUsers.vm = {
    password = "vm";
    shell = "${pkgs.bash}/bin/bash";
    group = "wheel";
    isNormalUser = true;
  };
  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  # Enable your new service!
  #  services =  {
  #    myNewService = {
  #      enable = true;
  #    };
  #  };
  networking.hostName = "vn";
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
}
