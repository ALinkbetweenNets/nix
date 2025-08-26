{ pkgs, lib, config, flake-self, home-manager, ... }: {
  imports = [
    ./hardware-configuration.nix
    home-manager.nixosModules.home-manager
    flake-self.inputs.nixos-hardware.nixosModules.framework-16-7040-amd
    # flake-self.inputs.ucodenix.nixosModules.ucodenix
  ];
  system.autoUpgrade.enable = lib.mkForce false;
  link = {
    wg-link.enable = true;
    wg-link.address = "10.5.5.2/24";
    plymouth.enable = true;
    # hyprland.enable = true;
    sops = true;
    # tailscale-address = "100.108.198.22";
    gaming.enable = true;
    # sway.enable = true;
    # fs.zfs.enable = true;
    # printing.enable = true;
    fs.ntfs.enable = true;
    fs.btrfs.enable = true;
    fs.luks.enable = true;
    laptop.enable = true;
    common.enable = true;
    main.enable = true;
    cpu-amd.enable = true;
    systemd-boot.enable = true;
    #secrets = "/home/l/.keys";
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
    # services.ollama.enable = true;
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
  systemd.services.decrypt-sops = {
    description = "Decrypt sops secrets";
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      # in network is not ready
      Restart = "on-failure";
      RestartSec = "2s";
    };
    script = config.system.activationScripts.setupSecrets.text;
  };
  hardware.enableRedistributableFirmware = true;
  home-manager.users.l = flake-self.homeConfigurations.laptop;
  boot = {
    initrd.systemd.enable = true;
    kernelParams = [ "quiet" ];
    binfmt.emulatedSystems = [ "aarch64-linux" ];
    kernel.sysctl."kernel.sysrq" = 1;
    # Alt+FN+S+key (on other devices Alt+Print+key)
    # h -> help (Output in journal)
    # f -> kernel OOM Killer
    # s -> sync data to disk before reset (REISUB (each key alt+fn+s+key in order) -> Safe reboot)
    # e -> SIGTERM to all processes except PID 0
    # i -> SIGKILL to all processes except PID 0
    # b -> Reboot
    # u -> Remount everything as read only
    # r -> exit Keyboard Raw mode (in case of dead X/Wayland and frozen terminal/ non responsive keyboard)
  };
  #powerManagement.scsiLinkPolicy = "med_power_with_dipm";
  # systemd.extraConfig = "DefaultLimitNOFILE=2048";
  # security.protectKernelImage = false;
  nixpkgs.config.permittedInsecurePackages = [ "unifi-controller-7.5.187" ];
  environment.systemPackages = with pkgs; [
    kdePackages.plasma-thunderbolt
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
  clan.core.networking.targetHost = config.networking.hostName;
  services.languagetool.enable = true;
  # services.ucodenix = {
  #   enable = true;
  #   cpuSerialNumber =
  #     "00A7-0F41-0000-0000-0000-0000"; # Replace with your processor's serial number
  # };
}
