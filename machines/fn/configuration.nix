{ self, ... }:
{ pkgs, lib, config, flake-self, home-manager, ... }: {
  imports = [
    ./hardware-configuration.nix
    home-manager.nixosModules.home-manager
    flake-self.inputs.nixos-hardware.nixosModules.framework-16-7040-amd
    # flake-self.inputs.ucodenix.nixosModules.ucodenix
  ];
  hardware.enableRedistributableFirmware = true;
  home-manager.users.l = flake-self.homeConfigurations.laptop;
  boot.initrd.systemd.enable = true;
  systemd.extraConfig = "DefaultLimitNOFILE=2048";
  # security.protectKernelImage = false;
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
  services = {
    # ollama = {
    #   enable = true;
    #   port = 11434;
    #   host = "127.0.0.1";
    #   loadModels = [ "llama3.1:70b" "nomic-embed-text" "starcoder2:3b" ];
    # };
    # private-gpt = {
    #   enable = true;
    #   settings = {
    #     azopenai = { };
    #     data = { local_data_folder = "/var/lib/private-gpt"; };
    #     embedding = { mode = "ollama"; };
    #     llm = {
    #       mode = "ollama";
    #       tokenizer = "";
    #     };
    #     ollama = {
    #       api_base = "http://localhost:11434";
    #       embedding_api_base = "http://localhost:11434";
    #       embedding_model = "nomic-embed-text";
    #       keep_alive = "5m";
    #       llm_model = "llama3.1:405b";
    #       repeat_last_n = 64;
    #       repeat_penalty = 1.2;
    #       request_timeout = 120;
    #       tfs_z = 1;
    #       top_k = 40;
    #       top_p = 0.9;
    #     };
    #     openai = { };
    #     qdrant = { path = "/var/lib/private-gpt/vectorstore/qdrant"; };
    #     vectorstore = { database = "qdrant"; };
    #   };
    # };
    # nextjs-ollama-llm-ui = {
    #   enable = true;
    #   port = 11444;
    #   ollamaUrl = "127.0.0.1:11444";
    # };
  };
  nixpkgs.config.permittedInsecurePackages = [ "unifi-controller-7.5.187" ];
  boot.kernelParams = [ "quiet" ];
  networking.hostId = "007f0200";
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
  networking.firewall.allowedTCPPorts = [ 60955 ];
  networking.firewall.allowedUDPPorts = [ 60955 ];
  networking.hostName = "fn";
  networking.domain = "monitor-banfish.ts.net";
  #powerManagement.scsiLinkPolicy = "med_power_with_dipm";
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
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
  #environment.systemPackages = with pkgs;    [ ];
}
