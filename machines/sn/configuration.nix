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
    fs.btrfs.enable = true;
    fs.luks.enable = true;
    # fs.ntfs.enable = true;
    ##
    vm.enable = true;
    # cpu-amd.enable = true;
    # nvidia.enable = true;
    ##
    # docker.enable = true;
    fail2ban.enable = true;
    ##
    domain = "alinkbetweennets.de";
    # storage = "/rz/srv";
    # syncthingDir = "/rz/syncthing";
    # secrets = "/pwd";
    #seafile.enable = true;
    # service-ip = "10.0.1.1";
    users.lenny.enable = true;
    users.lmh01.enable = true;
    # syncthing.enable = true;

    service-interface = "tailscale0";
    nginx.enable = false;
    nginx-expose = false;

    # containers = {
    #   grist.enable = true;
    #   diagrams.enable = true;
    # };
    # zola.enable = true;
    service-ports-expose = true;
    services = {
      # photoprism.enable = true; # WIP
      # keycloak.enable = true; # WIP but running
      # gitea.enable = true;
      # grafana.enable = true;
      # # seafile.enable = true;
      # # xandikos.enable = true; # WIP
      # hedgedoc.enable = true;
      # jellyfin.enable = true;
      # jellyseer.enable = true;
      # minio.enable = true;
      # nextcloud = {
      #   enable = true;
      #   nginx-expose = true;
      # };
      # nfs.enable = true;
      # outline = {
      #   enable = true;
      #   # nginx-expose = true;
      #   oidClientId = "2085b101-ee5c-42c1-acac-2f9265767d1f";
      # };
      # paperless.enable = true;
      # vaultwarden.enable = true;
      # matrix.enable = true;
      # restic-server = { enable = true; expose = false; };
      # coturn.enable = true;
      # dns.enable = true;
      # restic-client = {
      #   enable = true;
      #   backup-paths-onedrive = [
      #     "/home/l/.ssh"
      #     "/rz/syncthing"
      #   ];
      #   backup-paths-lenny-storagebox = [
      #     "/home/l/.ssh"
      #     "/rz/syncthing/crypt"
      #     "/rz/syncthing/doc"
      #     "/rz/syncthing/music"
      #     "/rz/syncthing/sec"
      #     "/rz/syncthing/uni"
      #     "/rz/syncthing/w"
      #   ];
      #   backup-paths-pi4b = [
      #     "/home/l/.ssh"
      #     "/rz/archive"
      #     "/rz/bkp/RTec"
      #     "/rz/data"
      #     "/rz/restic"
      #     "/rz/sftp"
      #     "/rz/srv"
      #     "/rz/syncthing"
      #   ];
      # };
      # wg-link.enable = true;
      # services.jitsi = {
      #   enable = true;
      #   expose = false;
      # };
      # keycloak.enable = true;
    };
    eth = "ens18";
  };
  nix.settings.auto-optimise-store = true;
  # services.cloudflare-dyndns = {
  #   ipv4 = lib.mkForce false;
  #   ipv6 = lib.mkForce false;
  # };
  # boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
  networking = {
    firewall = {
      # allowedUDPPorts = [ 51821 ];
      # allowedTCPPorts = [ 51821 ];
    };
    nat = {
      enable = true;
      externalInterface = "tailscale0";
      externalIP = "100.89.178.137";
      internalInterfaces = [ "virbr0" ];
      internalIPs = [ "192.168.122.91/32" ];
      forwardPorts = [
        # { sourcePort = 41623; proto = "tcp"; destination = "192.168.122.91:22"; loopbackIPs = [ "192.168.122.1" ]; }
      ];
    };
    interfaces."${config.link.eth}".wakeOnLan.enable = true;
    hostName = "sn";
    domain = "monitor-banfish.ts.net";
    hostId = "007f0200";
    extraHosts = ''
      192.168.122.200 snvnarr
    '';
  };
  # fileSystems."/rz/sftp/lenny/arr" = {
  #   device = "/rz/arr/";
  #   options = [ "bind" ];
  # };
  # fileSystems."/rz/sftp/lmh01/arr" = {
  #   device = "/rz/arr/";
  #   options = [ "bind" ];
  # };
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
  # services.onedrive.enable = true;
  # boot = {
  #   # loader.grub.device = "/dev/sdd";
  #   zfs.extraPools = [ "wdp" ];
  # };
  # nix run .\#lollypops -- sn:rebuild
  lollypops.deployment = {
    # local-evaluation = true;
    # ssh = { host = "100.89.178.137"; user = "root"; };
    # sudo.enable = true;
  };
}
