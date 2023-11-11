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
    fs.zfs.enable = true;
    hardware.enable = true;
    cpu-amd.enable = true;
    nvidia.enable = true;
    domain = "alinkbetweennets.de";
    storage = "/rz/srv";
    syncthingDir = "/rz/syncthing";
    secrets = "/pwd";
    #seafile.enable = true;
    nginx.enable = true;
    gitea.enable = true;
    grafana.enable = true;
    # hedgedoc.enable = true;
    # home-assistant.enable = true;
    jellyfin.enable = true;
    services = {
      dns.enable = true;
      wg-link.enable = true;
    };
    # services.jitsi = {
    #   enable = true;
    #   expose = false;
    # };
    # keycloak.enable = true;
    nextcloud.enable = true;
    outline.enable = true;
    paperless.enable = true;
    # photoprism.enable = true;
    syncthing.enable = true;
    # services.matrix.enable = true;
    eth = "enp6s0";
  };
  # virtualisation.sharedDirectories = {
  #   arr = {
  #     source = "/rz/arr";
  #     target = "/mnt/arr";
  #   };
  # };
  services.onedrive.enable = true;
  fileSystems."/export" = {
    device = "/rz";
    options = [ "bind" ];
  };
  boot = {
    loader.grub.device = "/dev/sdd";
    zfs.extraPools = [ "wdp" ];
  };
  networking = {
    interfaces."${config.link.eth}".wakeOnLan.enable = true;
    hostName = "sn";
    domain = "fritz.box";
    hostId = "007f0200";
  };
}
