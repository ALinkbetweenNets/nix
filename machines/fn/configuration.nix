{ self, ... }:
{ pkgs, lib, config, flake-self, home-manager, ... }: {
  imports = [
    ./hardware-configuration.nix
    home-manager.nixosModules.home-manager
    flake-self.inputs.nixos-hardware.nixosModules.framework-16-7040-amd
    # flake-self.inputs.ucodenix.nixosModules.ucodenix
  ];
  system.autoUpgrade.enable=lib.mkForce false;
  link = {
    sops = false;
    # tailscale-address = "100.108.198.22";
    gaming.enable = true;
    # sway.enable = true;
    # fs.zfs.enable = true;
    # printing.enable = true;
    fs.ntfs.enable = true;
    fs.luks.enable = false; # DO NOT ACTIVATE, DEBUG IN VM
    laptop.enable = true;
    common.enable = true;
    main.enable = true;
    cpu-amd.enable = true;
    systemd-boot.enable = true;
    #secrets = "/home/l/.keys";
    #wireguard.enable = true;
    # wg-link.enable = true;
    domain = "fn.local";
    service-ip = "127.0.0.1";
    # xrdp.enable = true;
    # eth = "wlp0s20f3";
    # nftables.enable = true;
    fail2ban.enable = true;
    podman.enable = true;
    # docker.enable = true;
    i2p.enable = true;
    services.restic-client = {
      enable = true;
      backup-paths-sn = [
        "/home/l/.ssh"
        "/home/l/Documents"
        "/home/l/Pictures"
        "/home/l/obsidian"
        "/home/l/s"
      ];
      #  backup-paths-sciebo = [
      #    "/home/l/.ssh"
      #    # "/home/l/archive"
      #    "/home/l/doc"
      #    # "/home/l/Documents"
      #    "/home/l/obsidian"
      #    "/home/l/sec"
      #    "/home/l/w"
      #  ];
      backup-paths-pi4b = [
        "/home/l/.ssh"
        "/home/l/archive"
        "/home/l/doc"
        "/home/l/Music"
        "/home/l/obsidian"
        "/home/l/sec"
        "/home/l/w"
        "/home/l/Pictures"
        "/home/l/uni"
      ];
    };
  };
  hardware.enableRedistributableFirmware = true;
  home-manager.users.l = flake-self.homeConfigurations.laptop;
  boot = {
    initrd.systemd.enable = true;
    kernelParams = [ "quiet" ];
    binfmt.emulatedSystems = [ "aarch64-linux" ];
  };
  #powerManagement.scsiLinkPolicy = "med_power_with_dipm";
  systemd.extraConfig = "DefaultLimitNOFILE=2048";
  # security.protectKernelImage = false;
  nixpkgs.config.permittedInsecurePackages = [ "unifi-controller-7.5.187" ];
  environment.systemPackages = with pkgs; [
    plasma5Packages.plasma-thunderbolt
    fw-ectool
    framework-tool
  ];
  #services.fprintd = {
  #  enable = true;
  #  tod.enable = true;
  #  tod.driver = pkgs.libfprint-2-tod1-vfs0090;
  #};
  networking = {
    hostId = "007f0200";
    firewall = {
      allowedTCPPorts = [ 60955 ];
      allowedUDPPorts = [ 60955 ];
    };
    hostName = "fn";
    domain = "monitor-banfish.ts.net";
  };
  # services.ucodenix = {
  #   enable = true;
  #   cpuSerialNumber =
  #     "00A7-0F41-0000-0000-0000-0000"; # Replace with your processor's serial number
  # };
  lollypops.deployment = {
    local-evaluation = true;
    ssh = { user = "l"; };
    sudo.enable = true;
  };
}
