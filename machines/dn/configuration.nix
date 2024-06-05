{ self, ... }:
{ pkgs, lib, config, flake-self, home-manager, ... }: {
  imports = [
    ./hardware-configuration.nix
    home-manager.nixosModules.home-manager
  ];
  home-manager.users.l = flake-self.homeConfigurations.tower;
  link = {
    gaming.enable = true;
    systemd-boot.enable = true;
    tower.enable = true;
    main.enable = true;
    printing.enable = lib.mkDefault true;
    cpu-intel.enable = true;
    nvidia.enable = true;
    secrets = "/home/l/.keys";
    wireguard.enable = true;
    wg-deep.enable = true;
    # wg-link.enable = true;
    xserver.enable = true;
    eth = "enp111s0";
    domain = "dn.local"; # testing domain
    # home-assistant.enable = true;
    docker.enable = true;
    services = {
      # matrix.enable = true;
      restic-client = {
        enable = true;
        backup-paths-sn = [
          "/home/l/.config"
          "/home/l/.ssh"
          "/home/l/archive"
          "/home/l/doc"
          "/home/l/Documents"
          "/home/l/obsidian"
          "/home/l/plasma-vault"
          "/home/l/sec"
          "/home/l/w"
        ];
        backup-paths-pi4b = [
          "/home/l/.config"
          "/home/l/.ssh"
          "/home/l/archive"
          "/home/l/doc"
          "/home/l/Documents"
          "/home/l/obsidian"
          "/home/l/plasma-vault"
          "/home/l/sec"
          "/home/l/w"
        ];
      };
    };
  };
  # services.unifi = { enable = true; openFirewall = true; };
  networking = {
    hostName = "dn";
    domain = "monitor-banfish.ts.net";
    hostId = "007f0200";
    interfaces."${config.link.eth}".wakeOnLan.enable = true;
  };
  #environment.systemPackages = with pkgs; [ davinci-resolve ];
  # nix run .\#lollypops -- meet:rebuild
  lollypops.deployment = {
    # local-evaluation = true;
    # ssh = { host = "10.0.1.1"; };
    # sudo.enable = true;
  };
  services.xserver.wacom.enable = true;
  environment.systemPackages = with pkgs; [
    wacomtablet
    xf86_input_wacom
  ];
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
}
