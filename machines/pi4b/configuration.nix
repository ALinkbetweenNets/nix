{ self, ... }:
{ pkgs, lib, config, modulesPath, flake-self, home-manager, nixos-hardware, nixpkgs, ... }: {

  imports = [
    # being able to build the sd-image
    "${modulesPath}/installer/sd-card/sd-image-aarch64.nix"
    # https://github.com/NixOS/nixos-hardware/tree/master/raspberry-pi/4
    nixos-hardware.nixosModules.raspberry-pi-4
    home-manager.nixosModules.home-manager
  ];

  home-manager.users.l = flake-self.homeConfigurations.server;

  link = {
    # make sure this module is compatible with ARM!
    # a common module should not take care about the bootloader
    # -> very specific to the hardware
    # use config.nixpkgs.hostPlatform.isAarch64 for conditional statements
    common.enable = true;
    # users.l.enable = true;
    # users.root.enable = true;
    # openssh.enable = true;
  };

  lollypops.deployment = {
    local-evaluation = true;
    ssh = { user = "root"; };
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
  ###

  networking.hostName = "pi4b";

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";

}
