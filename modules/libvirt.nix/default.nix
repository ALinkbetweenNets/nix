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
    virtualisation.libvirtd.enable = true;
    virtualisation.libvirtd.qemu.swtpm.enable = true;
    virtualisation.spiceUSBRedirection.enable = true;
    users.users.l.extraGroups = [ "libvirtd" "kvm" ];
  };
}
