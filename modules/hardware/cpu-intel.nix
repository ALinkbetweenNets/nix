{ lib, pkgs, config, nixgl, ... }:
with lib;
let cfg = config.link.cpu-intel;
in {
  options.link.cpu-intel.enable = mkEnableOption "activate cpu-intel";
  config = mkIf cfg.enable {
    boot.initrd.kernelModules = [ "i915" ];
    boot.kernelModules = [ "kvm-intel" ];
    boot.extraModprobeConfig = "options kvm_intel nested=1";
    boot.kernelParams = [ "intel_iommu=on" "iommu=pt" ];
    # environment.variables = {
    #   VDPAU_DRIVER =
    #     lib.mkIf config.hardware.opengl.enable (lib.mkDefault "va_gl");
    # };
    environment.systemPackages = with pkgs; [
      intel-gpu-tools
      nvtop-intel
      nixgl
    ];
    hardware.opengl.extraPackages = with pkgs; [
      intel-media-driver
      libvdpau-va-gl
      vaapiIntel
      vaapiVdpau
      intel-compute-runtime
      intel-ocl
    ];
    hardware.opengl.extraPackages32 = with pkgs.pkgsi686Linux;
      [
        intel-media-driver
        # libvdpau-va-gl
        vaapiIntel
        # vaapiVdpau
        #intel-compute-runtime
        #intel-ocl
      ];
    hardware.cpu.intel.updateMicrocode = true;
  };
}
