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
         "luks-1e4c0964-e0dc-482c-a999-64ee1cc3725d" = {
           device = "/dev/disk/by-uuid/854c679d-ad2a-450b-830c-fd49633cbd31";
           #keyFile="/crypto_keyfile.bin";
           #preLVM = true;
           #allowDiscards = true;
         };
         "luks-b6df9624-aab6-4d59-ac03-817bbb806b6c" = {
           device = "/dev/disk/by-uuid/4473a751-a85a-448f-bacf-e821bb543be4";
           #keyFile="/crypto_keyfile.bin";
         };
       };
    };
  };
   fileSystems."/" =
     {
       device = "/dev/disk/by-uuid/854c679d-ad2a-450b-830c-fd49633cbd31";
       fsType = "ext4";
     };
   fileSystems."/boot" =
     {
       device = "/dev/disk/by-uuid/6F02-2160";
       fsType = "vfat";
     };
   swapDevices =
     [{ device = "/dev/disk/by-uuid/4473a751-a85a-448f-bacf-e821bb543be4"; }];
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
