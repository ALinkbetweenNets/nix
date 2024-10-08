# NOTE: this file was generated by the Mobile NixOS installer.
{ config, lib, pkgs, modulesPath, ... }: {
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];
  boot = {
    initrd = {
      availableKernelModules = [ "usbhid " ];
      kernelModules = [ ];
      luks.devices = {
        "LUKS-PPPN-ROOTFS" = {
          device = "/dev/disk/by-uuid/123ba5a7-4f23-4184-a398-e3232a69e37b";
        };
      };
    };
    kernelModules = [ ];
    extraModulePackages = [ ];
  };
  swapDevices = [ ];
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/2f35078a-1513-44d9-a83e-3658eea8d6fb";
      fsType = "ext4";
    };
  };
  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
  nix.settings.max-jobs = lib.mkDefault 3;
}
