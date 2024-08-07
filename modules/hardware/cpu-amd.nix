{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.link.cpu-amd;
in
{
  options.link.cpu-amd.enable = mkEnableOption "activate cpu-amd";
  config = mkIf cfg.enable {
    boot.extraModprobeConfig = "options kvm_amd nested=1";
    hardware.cpu.amd.updateMicrocode = true;
    boot.kernelParams = [ "amd_iommu=on" ];
    boot.kernelModules = [ "kvm-amd" ];
  };
}
