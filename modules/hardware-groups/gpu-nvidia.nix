{ lib, pkgs, config, nixgl, ... }:
with lib;
let
  cfg = config.link.nvidia;
  cudaoverlay = (self: super: {
    inherit (pkgs.cudapkgs) ffmpeg hashcat jellyfin jellyfin-ffmpeg;
  });
in
{
  options.link.nvidia = { enable = mkEnableOption "activate nvidia support"; };
  config = mkIf cfg.enable {
    nixpkgs.overlays = [ cudaoverlay ];
    home-manager.users."l" = mkIf config.link.users.l.enable {
      nixpkgs.overlays = [ cudaoverlay ];
      # nixpkgs.config.cudaSupport = true;
    };
    # nixpkgs.config.cudaSupport = true;
    environment.systemPackages = with pkgs; [
      nixgl
      libva-utils
      nvidia-vaapi-driver
      nvtopPackages.nvidia
      pciutils
      vdpauinfo
      cudaPackages.cudatoolkit
      cudaPackages.cudnn
    ];
    # services.xserver.videoDrivers = [ "nvidia" ];
    boot.blacklistedKernelModules = [ "nouveau" ];
    services.xserver.videoDrivers = [ "nvidia" ];
    hardware = {
      graphics = {
        enable = true;
        extraPackages = with pkgs; [
          libva-vdpau-driver
          libvdpau-va-gl
          nvidia-vaapi-driver
        ];
        extraPackages32 = with pkgs; [ libva-vdpau-driver ];
      };
      nvidia = {
        open =
          false; # with the open driver the screen will keep black after waking the pc from suspend
        modesetting.enable = true;
        # powerManagement.enable = false;
        # package = config.boot.kernelPackages.nvidiaPackages.stable;
        nvidiaSettings = true;
        #dynamicBoost.enable=true;
        #prime.offload={
        #  enableOffloadCmd=true;
        #	enable=true;

        #};
      };
    };
    hardware.nvidia-container-toolkit.enable =
      mkIf config.virtualisation.docker.enable true;
    # when docker is enabled, enable nvidia-docker
    # hardware.nvidia-container-toolkit.enable =
    # lib.mkIf config.virtualisation.docker.enable true;
    # fix electron problems with nvidia
    environment.sessionVariables.NIXOS_OZONE_WL = "1";
  };
}
