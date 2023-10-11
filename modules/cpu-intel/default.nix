{ lib, pkgs, config, ... }:
with lib;
let cfg = config.link.cpu-intel;
in {
  options.link.cpu-intel.enable = mkEnableOption "activate cpu-intel";
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ intel-gpu-tools nvtop powertop ];
    boot.initrd.kernelModules = [ "i915" ];
    boot.kernelModules = [ "kvm-intel" ];

    boot.extraModprobeConfig = "options kvm_intel nested=1";
    boot.kernelParams = [ "intel_iommu=on" "iommu=pt" ];
    # environment.variables = {
    #   VDPAU_DRIVER =
    #     lib.mkIf config.hardware.opengl.enable (lib.mkDefault "va_gl");
    # };
    hardware.opengl.extraPackages = with pkgs; [
      intel-media-driver
      intel-ocl
      libvdpau-va-gl
      vaapiIntel
      vaapiVdpau
    ];
    hardware.opengl.extraPackages32 = with pkgs.pkgsi686Linux;
      [ intel-media-driver ];
    hardware.cpu.intel.updateMicrocode = true;
  };
}
