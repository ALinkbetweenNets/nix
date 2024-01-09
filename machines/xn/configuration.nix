{ self, ... }:
{ pkgs, lib, config, flake-self, home-manager, ... }: {
  imports = [
    ./hardware-configuration.nix
    home-manager.nixosModules.home-manager
    # https://github.com/NixOS/nixos-hardware/blob/master/lenovo/thinkpad/x13/yoga/3th-gen/default.nix
    flake-self.inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x13-yoga-3th-gen
  ];
  hardware.enableRedistributableFirmware = true;
  home-manager.users.l = flake-self.homeConfigurations.convertible;
  link = {
    convertible.enable = true;
    main.enable = true;
    cpu-intel.enable = true;
    systemd-boot.enable = true;
    secrets = "/home/l/.keys";
    wireguard.enable = true;
    wg-deep.enable = true;
    wg-link.enable = true;
    domain = "xn.local";
    service-ip = "127.0.0.1";
    # xrdp.enable = true;
    eth = "wlp0s20f3";
    docker.enable = true;
    unbound.enable = true;
    services.restic-client = {
      enable = true;
      backup-paths-sn = [
        "/home/l/.config"
        "/home/l/.ssh"
        "/home/l/archive"
        "/home/l/doc"
        "/home/l/Documents"
        "/home/l/obsidian"
        "/home/l/sec"
        "/home/l/w"
      ];
    };
  };
  # networking .  firewall.allowedTCPPorts = [ 5201 ];
  # networking .  firewall.allowedUDPPorts = [ 5201 ];
  networking.hostName = "xn";
  # services.throttled.enable = false;
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  lollypops.deployment = {
    local-evaluation = true;
    # ssh = { user = "l"; };
    # sudo.enable = true;
  };
  #environment.systemPackages = with pkgs;    [ ];
}
