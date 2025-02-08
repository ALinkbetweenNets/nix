{ self, ... }:
{ pkgs, lib, config, modulesPath, flake-self, home-manager, nixos-hardware
, nixpkgs, ... }: {

  imports = [
    # being able to build the sd-image
    "${modulesPath}/installer/sd-card/sd-image-aarch64.nix"
    # https://github.com/NixOS/nixos-hardware/tree/master/raspberry-pi/4
    nixos-hardware.nixosModules.raspberry-pi-4
    home-manager.nixosModules.home-manager
  ];
  powerManagement.powerUpCommands = ''
    ${pkgs.hdparm}/sbin/hdparm -S 9 -B 127 /dev/sda
  '';
  fileSystems."/mnt" = {
    device = "/dev/disk/by-uuid/865aca39-8ddc-4949-8413-50382b0a84ae";
    fsType = "btrfs";
  };
  hardware = {
    raspberry-pi."4" = {
      apply-overlays-dtmerge.enable = true;
      fkms-3d.enable = true;
    };
    deviceTree = {
      enable = true;
      # filter = "*-rpi-*.dtb";
      # overlays = [
      #   {
      #     name = "spi";
      #     dtsoFile = ./spi0-0cd.dtso;
      #   }
      # ];
    };
  };
  console.enable = true;
  environment.systemPackages = with pkgs; [ libraspberrypi raspberrypi-eeprom ];
  home-manager.users.l = flake-self.homeConfigurations.server;
  link = {
    # make sure this module is compatible with ARM!
    # a common module should not take care about the bootloader
    # -> very specific to the hardware
    # use config.nixpkgs.hostPlatform.isAarch64 for conditional statements
    common.enable = true;
    server.enable = true;
    # desktop.enable = true;
    syncthing.enable = true;
    syncthingDir = "/mnt/syncthing";
    services = {
      home-assistant.enable = true;
      node-red.enable = true;
    };
  };
  users.users.l.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIER/dVmTaW5sjMi3Yf60y5pqDlXs7pI6w/CCBEfofKQL root@fn"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBu+WcpENdr7FaCIwj6WsinGnykIPV/tnIyrfEHSeU+E root@sn"
  ];
  lollypops.deployment = {
    local-evaluation = true;
    sudo.enable = true;
    ssh = {
      user = "l";
      opts = [ "-p 2522" ];
    };
  };
  services.frigate = {
    enable = true;
    hostname = "pi4b.monitor-banfish.ts.net";
    settings.cameras = {
      "pizero1" = {
        ffmpeg.inputs = [{
          path = "rtsp://192.168.123.108:8554/unicast";
          roles = [ "detect" ];
        }];
      };
    };
  };
  services.home-assistant = {
    enable = true;
    config = {
      lovelace.mode = "storage";
      homeassistant.name = "Pi";
    };
    openFirewall = true;
    lovelaceConfigWritable = true;
    configWritable = true;
    extraPackages = python3Packages:
      with python3Packages;
      [
        # postgresql support
        psycopg2
      ];
  };
  ### build sd-image
  # nix build .\#nixosConfigurations.pi4b.config.system.build.sdImage
  # add boot.binfmt.emulatedSystems = [ "aarch64-linux" ]; to your x86 system
  # to build ARM stuff through qemu
  sdImage.compressImage = false;
  sdImage.imageBaseName = "raspi-image";
  nix.registry.nixpkgs.flake = nixpkgs;
  nix.nixPath = [ "nixpkgs=${nixpkgs}" ];
  # this workaround is currently needed to build the sd-image
  # basically: there currently is an issue that prevents the sd-image to be built successfully
  # remove this once the issue is fixed!
  nixpkgs.overlays = [
    (final: super: {
      makeModulesClosure = x:
        super.makeModulesClosure (x // { allowMissing = true; });
    })
  ];
  networking.hostName = "pi4b";
  networking.domain = "monitor-banfish.ts.net";
  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
}
