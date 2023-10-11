{ lib, pkgs, config, ... }:
with lib;
let cfg = config.link.nvidia;
in
{
  options.link.nvidia = {
    enable = mkEnableOption "activate nvidia support";
  };

  config = mkIf cfg.enable {
    services.xserver.videoDrivers = [ "nvidia" ];
    # Nvidia settings
    hardware = {
      opengl = {
        enable = true;
        driSupport = true;
        driSupport32Bit = true;
      };
      nvidia = {
        open = false; # with the open driver the screen will keep black after waking the pc from suspend
        modesetting.enable = true;
        powerManagement.enable = true;
        nvidiaSettings = true;
      };
    };

    # when docker is enabled, enable nvidia-docker
    virtualisation.docker.enableNvidia = lib.mkIf config.virtualisation.docker.enable true;

    environment.systemPackages = with pkgs; [
      nvtop
    ];

    # fix electron problems with nvidia
    environment.sessionVariables.NIXOS_OZONE_WL = "1";

  };
}
