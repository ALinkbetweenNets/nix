# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:
{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
      ./disk-config.nix
    ];
  boot.loader = {
    timeout = 10;
    grub = {
      devices = [ "/dev/sda" ];
      efiSupport = true;
      efiInstallAsRemovable = true;
    };
  };
  boot.initrd.availableKernelModules = [ "ehci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  # boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];
  # fileSystems."/" =
  #   {
  #     device = "/dev/disk/by-uuid/bc5fe8c7-0b3b-4d97-bc45-c1812b49fc37";
  #     fsType = "ext4";
  #   };
  # swapDevices =
  #   [{ device = "/dev/disk/by-uuid/8d4b2108-3aca-4e6f-8f7f-a06128ab9ecc"; }];
  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.eno1.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
