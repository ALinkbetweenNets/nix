{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.libvirt;
in {
  options.link.libvirt.enable = mkEnableOption "activate libvirt";
  config = mkIf cfg.enable {
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
          ovmf.enable = true;
          runAsRoot = false;
        };
        onBoot = "ignore";
        onShutdown = "shutdown";
      };
      spiceUSBRedirection.enable = true;
    };
    # systemd.tmpfiles.rules = [
    #   "f /dev/shm/looking-glass 0660 alex qemu-libvirtd -"
    # ];
    programs.dconf.enable = lib.mkForce true;
    # networking.bridges.br0.interfaces = [ config.link.eth ];
    # networking.interfaces.br0 = { useDHCP = true; };
    networking.firewall.allowedTCPPorts = [
      5900 # spice
    ];
  };
}
