{ lib, pkgs, config, nixgl, ... }:
with lib;
let cfg = config.link.cpu-amd;
in {
  options.link.cpu-amd.enable = mkEnableOption "activate cpu-amd";
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ nvtopPackages.amd nixgl mesa];
    boot.extraModprobeConfig = "options kvm_amd nested=1";
    hardware.cpu.amd.updateMicrocode = true;
    boot.kernelParams = [ "amd_iommu=on" "amd_pstate=active" ];
    boot.kernelModules = [ "kvm-amd" ];
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [ vaapiVdpau libvdpau-va-gl ];
    };
  };
}
