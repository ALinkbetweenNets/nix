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
    zfs.enable = true;
    hardware.enable = true;
    cpu-amd.enable = true;
    nvidia.enable = true;
    storage = "/rz/srv/";
    # Services
    #seafile.enable = true;
    gitea.enable = true;
    grafana.enable = true;
    jellyfin.enable = true;
    jitsi.enable = true;
    nextcloud.enable = true;
    keycloak.enable = true;
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
  fileSystems."/export" = {
    device = "/rz";
    options = [ "bind" ];
  };
  boot.loader.grub.device = "/dev/sdd";
  boot.zfs.extraPools = [ "wdp" ];
  networking.interfaces."enp6s0".wakeOnLan.enable = true;
  networking.hostName = "sn";
  networking.hostId = "007f0200";
  services.syncthing.settings.folders = {
    "v".path = "/rz/syncthing/v";
    "camera".path = "/rz/syncthing/camera";
    "uni".path = "/rz/syncthing/uni";
    "doc".path = "/rz/syncthing/doc";
    "music".path = "/rz/syncthing/music";
    "crypt".path = "/rz/syncthing/crypt";
    "sec".path = "/rz/syncthing/sec";
    "keys".path = "/rz/syncthing/.keys";
  };
}
