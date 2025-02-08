{ lib, pkgs, config, nixgl, ... }:
with lib;
let cfg = config.link.cpu-amd;
in {
  options.link.cpu-amd.enable = mkEnableOption "activate cpu-amd";
  config = mkIf cfg.enable {
    services.xserver.videoDrivers = [ "amdgpu" ];
    environment.systemPackages = with pkgs; [ nvtopPackages.amd clinfo ];
    boot = {
      kernelParams = [
        "amd_iommu=on"
        "amd_pstate=active"
        # "amdgpu.dcfeaturemask=0x8"
        # "amdgpu.sg_display=0"
        #"radeon.cik_support=0"
        # "amdgpu.cik_support=1"
      ];
      extraModprobeConfig = "options kvm_amd nested=1";
      kernelModules = [ "kvm-amd" "amdgpu" ];
    };
    hardware = {
      cpu.amd.updateMicrocode = true;
      # amdgpu.initrd.enable = lib.mkDefault true;
      graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = with pkgs; [
          # amdvlk
          # rocmPackages.clr.icd
          # rocmPackages.clr
          # mesa.opencl
          vaapiVdpau
          libvdpau-va-gl
        ];
      };
    };
  };
}
