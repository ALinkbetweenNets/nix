{
  config,
  system-config,
  pkgs,
  lib,
  ...
}:
with lib;
let
  cfg = config.link.libvirt;
in
{
  options.link.libvirt.enable = mkEnableOption "activate libvirt";
  config = mkIf cfg.enable {
    boot.kernelModules = [
      "vfio_virqfd"
      "vfio_pci"
      "vfio_iommu_type1"
      "vfio"
    ];
    environment.systemPackages = with pkgs; [
      virtiofsd
      libvirt
      libguestfs
      qemu
      qemu-utils
      ebtables
    ];
    virtualisation = {
      # virtualbox.host = {
      #   enable = true;
      #   enableKvm = true;
      #   addNetworkInterface = false;
      # };
      libvirtd = {
        enable = true;
        qemu = {
          swtpm.enable = true;
          runAsRoot = true;
        };
        extraConfig = ''
          user="l"
        '';
        onBoot = "ignore";
        onShutdown = "shutdown";
      };
      spiceUSBRedirection.enable = true;
    };
    # systemd.tmpfiles.rules = [
    #   "f /dev/shm/looking-glass 0660 alex qemu-libvirtd -"
    # ];
    programs.dconf.enable = lib.mkForce true;
    networking = {
      # networking.bridges.br0.interfaces = [ config.link.eth ];
      # networking.interfaces.br0 = { useDHCP = true; };
      nat = {
        enable = true;
        internalInterfaces = [ "virbr0" ];
      };
      # interfaces.virbr0 = {
      #   ipv4.addresses = [
      #     {
      #       address = "192.168.122.1";
      #       prefixLength = 24;
      #     }
      #   ];
      # };
      firewall.interfaces.virbr0.allowedUDPPorts = [
        53 # DNS
        67 # DHCP
      ];
      firewall.allowedTCPPorts = [
        5900 # spice
      ];
    };
  };
}
