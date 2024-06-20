# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:
{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
      #./disk-config.nix
    ];
  #swapDevices = [{ device = "/.swapvol/swapfile"; }];
  boot = {
    extraModulePackages = [ ];
    kernelModules = [ "kvm-intel" "usbnet" ];
    kernelParams = [ "intel_pstate=active" "resume_offset=533760" ];
    #resumeDevice = "/dev/disk/by-uuid/854c679d-ad2a-450b-830c-fd49633cbd31";
    initrd = {
      availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" ];
      kernelModules = [ ];
      # secrets = {
      #   "/crypto_keyfile.bin" = null;
      # };
      luks.devices = {
        "root" = {
          device = "/dev/nvme0n1p2";
          #keyFile="/crypto_keyfile.bin";
          #preLVM = true;
          #allowDiscards = true;
        };
        "swap" = {
          device = "/dev/nvme0n1p3";
          #keyFile="/crypto_keyfile.bin";
        };
      };
    };
  };
  fileSystems."/" =
    {
      device = "/dev/mapper/root";
      fsType = "ext4";
    };
  fileSystems."/boot" =
    {
      device = "/dev/nvme0n1p1";
      fsType = "vfat";
    };
  swapDevices =
    [{ device = "/dev/mapper/swap"; }];
  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp0s13f0u1u4c2.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp0s20f3.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";
  hardware.cpu.intel.updateMicrocode = true;
}
