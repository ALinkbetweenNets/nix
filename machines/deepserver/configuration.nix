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
    hardware.enable = true;
    cpu-amd.enable = true;
    users = { jucknath.enable = true; paul.enable = true; };
    wireguard.enable = true;
    # services.jitsi.enable = true;
    nginx-expose = false;
    domain = "deepserver.org";
    service-ip = "10.0.0.1";
    eth = "eth0";
    service-interface = "wg-deep";
    fail2ban.enable = true;
    server.enable = true;
    services = {
      coturn.enable = true;
      gitea.enable = true;
      hedgedoc.enable = true;
      matrix.enable = true;
      nextcloud.enable = true;
      onlyoffice.enable = true;
      vaultwarden.enable = true;
      wg-deep.enable = true;
      restic-client = {
        enable = true;
        backup-paths-storagebox = [
          "/var/lib/bitwarden_rs"
          "/var/lib/gitea"
          "/var/lib/hedgedoc"
          "/var/lib/matrix-synapse"
          "/var/lib/minio"
          "/var/lib/nextcloud"
          "/var/lib/onlyoffice"
          "/var/lib/outline"
          "/var/lib/vaultwarden"
          "/pwd"
        ];
      };
      outline = {
        enable = true;
        oidClientId = "1e030d3b-e260-4f22-a373-41d2b8fea1fa";
      };
      minio.enable = true;
    };
    nginx.enable = true;
  };
  services.openssh.ports = [ 2522 ];
  services.openssh.settings.PermitRootLogin = lib.mkForce "prohibit-password";
  boot.loader.grub.devices = [ "/dev/sda" "/dev/sdb" ];
  security.sudo.wheelNeedsPassword = true;
  networking = {
    hostName = "deepserver";
    domain = "org";
    nat.externalInterface = config.link.eth; # used by wireguard
    firewall = {
      allowedTCPPorts = [ 80 443 ];
    };
  };
  lollypops.deployment = {
    # local-evaluation = true;
    # ssh.host = "deepserver:2522";
    # ssh = { user = "l"; };
    # ssh = { host = "10.0.0.1:2522"; };
    # sudo.enable = true;
  };
}
