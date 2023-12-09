{ self, ... }:
{ pkgs, lib, config, flake-self, home-manager, ... }: {
  imports = [
    ./hardware-configuration.nix
    home-manager.nixosModules.home-manager
  ];
  home-manager.users.l = flake-self.homeConfigurations.server;
  home-manager.users.root = flake-self.homeConfigurations.server;
  link = {
    common.enable = true;
    grub.enable = true;
    systemd-boot.enable = false;
    fs.zfs.enable = true;
    tower.enable = true;
    cpu-amd.enable = true;
    nvidia.enable = true;
    docker.enable = true;
    domain = "alinkbetweennets.de";
    storage = "/rz/srv";
    syncthingDir = "/rz/syncthing";
    secrets = "/pwd";
    #seafile.enable = true;
    nginx.enable = true;
    fail2ban.enable = true;
    service-ip = "10.0.1.1";
    fs.ntfs.enable = true;
    containers = {
      grist.enable = true;
      diagrams.enable = true;
    };
    # zola.enable = true;
    grafana.enable = true;
    # home-assistant.enable = true;
    jellyfin.enable = true;
    paperless.enable = true;
    # photoprism.enable = true;
    syncthing.enable = true;
    keycloak.enable = true;
    services = {
      dns.enable = true;
      gitea.enable = true;
      hedgedoc = { enable = true; expose = true; };
      # matrix.enable = true;
      minio.enable = true;
      nextcloud = { enable = true; expose = true; };
      restic-server = { enable = true; expose = false; };
      vaultwarden = { enable = true; expose = false; };
      wg-link.enable = true;
      outline = {
        enable = true;
        oidClientId = "2085b101-ee5c-42c1-acac-2f9265767d1f";
        expose = true;
      };
      # services.jitsi = {
      #   enable = true;
      #   expose = false;
      # };
      # keycloak.enable = true;
    };
    expose = true;
    eth = "enp6s0";
  };
  powerManagement.powertop.enable = true;
  # virtualisation.sharedDirectories = {
  #   arr = {
  #     source = "/rz/arr";
  #     target = "/mnt/arr";
  #   };
  # };
  services.onedrive.enable = true;
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
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "server";
    extraUpFlags = [ "--advertise-routes 192.168.178.0/24" "--advertise-exit-node" ];
  };
  # nix run .\#lollypops -- sn:rebuild
  lollypops.deployment = {
    local-evaluation = true;
    ssh = { host = "10.0.1.1"; };
    # sudo.enable = true;
  };
}
