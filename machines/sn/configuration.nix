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
    storage = "/rz/srv";
    syncthingDir = "/rz/syncthing";
    # Services
    #seafile.enable = true;
    gitea.enable = true;
    grafana.enable = true;
    hedgedoc.enable = true;
    home-assistant.enable = true;
    jellyfin.enable = true;
    jitsi.enable = true;
    keycloak.enable = true;
    nextcloud.enable = true;
    nginx.enable = true;
    outline.enable = true;
    paperless.enable = true;
    photoprism.enable = true;
    syncthing.enable = true;
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
    interfaces."enp6s0".wakeOnLan.enable = true;
    hostName = "sn";
    hostId = "007f0200";
  };
}
