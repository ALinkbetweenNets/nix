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
    coturn.enable = true;
    containers = {
      grist.enable = true;
      diagrams.enable = true;
    };
    # zola.enable = true;
    grafana.enable = true;
    # home-assistant.enable = true;
    jellyfin.enable = true;
    # photoprism.enable = true;
    syncthing.enable = true;
    keycloak.enable = true;
    services = {
      paperless = {
        # enable = true;
        expose = false;
      };
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
      services.restic-client = {
        enable = true;
        backup-paths-onedrive = [
          "/home/l/.ssh"
        ];
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
  services.nginx.virtualHosts."${config.link.domain}" = {
    enableACME = true;
    forceSSL = true;
    default = true;
    locations."/" = {
      return = "301 https://www.youtube.com/watch?v=dQw4w9WgXcQ";
    };
  };

  ## CTF

  services.nginx.virtualHosts."slides.netintro.${config.link.domain}" = {
    enableACME = true;
    forceSSL = true;
    # default = true;
    locations."/" = {
      proxyPass = "http://192.168.122.30:31337/";
    };
  };
  services.nginx.virtualHosts."vpnconfig.netintro.${config.link.domain}" = {
    enableACME = true;
    forceSSL = true;
    # default = true;
    locations."/" = {
      proxyPass = "http://192.168.122.30:31338/";
    };
  };
  services.nginx.virtualHosts."chal0.internal.netintro.${config.link.domain}" = {
    enableACME = true;
    forceSSL = true;
    # default = true;
    locations."/" = {
      proxyPass = "http://192.168.122.30:33159/";
    };
  };
  services.nginx.virtualHosts."chal1.internal.netintro.${config.link.domain}" = {
    enableACME = true;
    forceSSL = true;
    # default = true;
    locations."/" = {
      proxyPass = "http://192.168.122.30:33160/";
    };
  };
  services.nginx.virtualHosts."chal2b.internal.netintro.${config.link.domain}" = {
    enableACME = true;
    forceSSL = true;
    # default = true;
    locations."/" = {
      proxyPass = "http://192.168.122.30:33161/";
    };
  };
  services.nginx.virtualHosts."chal2c.internal.netintro.${config.link.domain}" = {
    enableACME = true;
    forceSSL = true;
    # default = true;
    locations."/" = {
      proxyPass = "http://192.168.122.30:33162/";
    };
  };
  services.nginx.virtualHosts."chal2.internal.netintro.${config.link.domain}" = {
    enableACME = true;
    forceSSL = true;
    # default = true;
    locations."/" = {
      proxyPass = "http://192.168.122.30:33163/";
    };
  };

  ## /CTF

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
    # local-evaluation = true;
    ssh = { host = "100.89.178.137"; user = "root"; };
    # sudo.enable = true;
  };
}
