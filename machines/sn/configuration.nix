{ self, ... }:
{ pkgs, lib, config, flake-self, home-manager, ... }: {
  imports = [
    ./hardware-configuration.nix
    home-manager.nixosModules.home-manager
  ];
  home-manager.users.l = flake-self.homeConfigurations.server;
  link = {
    common.enable = true;
    server.enable = true;
    grub.enable = true;
    systemd-boot.enable = false;
    fs.zfs.enable = true;
    fs.ntfs.enable = true;
    ##
    tower.enable = true;
    cpu-amd.enable = true;
    nvidia.enable = true;
    ##
    docker.enable = true;
    fail2ban.enable = true;
    ##
    domain = "alinkbetweennets.de";
    storage = "/rz/srv";
    syncthingDir = "/rz/syncthing";
    secrets = "/pwd";
    #seafile.enable = true;
    # service-ip = "10.0.1.1";
    service-interface = "tailscale0";
    users.lenny.enable = true;

    nginx.enable = false;
    containers = {
      grist = {
        enable = true;
        expose-port = true;
      };
      diagrams = {
        enable = true;
        expose-port = true;
      };
    };
    # zola.enable = true;
    syncthing.enable = true;
    services = {
      # photoprism = {
      #   enable = true;
      #   expose-port = true;
      # };
      # keycloak.enable = true;
      gitea = {
        enable = true;
        expose-port = true;
      };
      grafana = {
        enable = true;
        expose-port = true;
      };
      # seafile = {
      #   enable = true;
      #   expose-port = true;
      # };
      hedgedoc = {
        enable = true;
        expose-port = true;
      };
      jellyfin = {
        enable = true;
        expose-port = true;
      };
      jellyseer = {
        enable = true;
        expose-port = true;
      };
      minio = {
        enable = true;
        expose-port = true;
      };
      # nextcloud = {
      #   enable = true;
      #   nginx-expose = true;
      # };
      outline = {
        enable = true;
        nginx-expose = true;
        oidClientId = "2085b101-ee5c-42c1-acac-2f9265767d1f";
      };
      paperless = {
        enable = true;
        expose-port = true;
      };
      restic-client.enable = true;
      restic-client.backup-paths-onedrive = [
        "/home/l/.ssh"
        "/rz/syncthing"
      ];
      restic-client.backup-paths-lenny-synology = [
        "/home/l/.ssh"
        "/rz/syncthing/uni"
        "/rz/syncthing/sec"
        "/rz/syncthing/music"
        "/rz/syncthing/doc"
      ];
      vaultwarden = {
        enable = true;
        nginx-expose = false;
      };
      # matrix.enable = true;
      # restic-server = { enable = true; expose = false; };
      coturn.enable = true;
      dns.enable = true;
      # wg-link.enable = true;
      # services.jitsi = {
      #   enable = true;
      #   expose = false;
      # };
      # keycloak.enable = true;
    };
    nginx-expose = false;
    service-ports-expose = true;
    eth = "enp6s0";
  };

  # boot.kernel.sysctl."net.ipv4.ip_forward" = 1;

  networking.firewall.interfaces."${config.link.service-interface}".allowedTCPPorts = [ 31337 ];
  networking.firewall.allowedUDPPorts = [ 51821 ];
  networking.firewall.allowedTCPPorts = [ 51821 ];

  fileSystems."/rz/sftp/lenny/arr" = {
    device = "/rz/arr/lenny/";
    options = [ "bind" ];
  };

  # virtualisation.oci-containers.containers.librespeedtest = {
  #   autoStart = true;
  #   image = "adolfintel/speedtest";
  #   environment = {
  #     TITLE = "sn speedtest";
  #     ENABLE_ID_OBFUSCATION = "true";
  #     WEBPORT = "8766";
  #     MODE = "standalone";
  #   };
  #   ports = [ "8766:8766/tcp" ];
  # };
  # systemd.services.docker-librespeedtest = {
  #   preStop = "${pkgs.docker}/bin/docker kill librespeedtest";
  # };


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
  # nix run .\#lollypops -- sn:rebuild
  lollypops.deployment = {
    # local-evaluation = true;
    # ssh = { host = "100.89.178.137"; user = "root"; };
    # sudo.enable = true;
  };
}
