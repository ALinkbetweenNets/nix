{ lib, pkgs, config, nixgl,... }:
with lib;
let cfg = config.link.cpu-amd;
in {
  options.link.cpu-amd.enable = mkEnableOption "activate cpu-amd";
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      nvtopPackages.amd
      nixgl
    ];
    boot.extraModprobeConfig = "options kvm_amd nested=1";
    hardware.cpu.amd.updateMicrocode = true;
    boot.kernelParams = [ "amd_iommu=on" "amd_pstate=active" ];
    boot.kernelModules = [ "kvm-amd" ];
  };
}
