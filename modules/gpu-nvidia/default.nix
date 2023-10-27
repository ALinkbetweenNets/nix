{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.link.nvidia;
  cudaoverlay = (self: super: {
    inherit (pkgs.cudapkgs)
      hashcat
      jellyfin
      ffmpeg
      ffmpeg-jellyfin
      ;
  });
in
{
  options.link.nvidia = { enable = mkEnableOption "activate nvidia support"; };

  config = mkIf cfg.enable {

    nixpkgs.overlays = [
      cudaoverlay
    ];

    home-manager.users."l" = {
      nixpkgs.overlays = [
        cudaoverlay
      ];
      # nixpkgs.config.cudaSupport = true;
    };
    # nixpkgs.config.cudaSupport = true;

    environment.systemPackages = with pkgs; [
      pciutils
      libva-utils
      vdpauinfo
      nvtop-nvidia
      nvidia-vaapi-driver
    ];
    services.xserver.videoDrivers = [ "nvidia" ];
    hardware = {
      opengl = {
        enable = true;
        driSupport = true;
        driSupport32Bit = true;
        extraPackages = with pkgs; [
          vaapiVdpau
          libvdpau-va-gl
          nvidia-vaapi-driver
        ];
        extraPackages32 = with pkgs; [ vaapiVdpau ];
      };
      nvidia = {
        open =
          false; # with the open driver the screen will keep black after waking the pc from suspend
        modesetting.enable = true;
        powerManagement.enable = true;
        nvidiaSettings = true;
      };
    };

    # when docker is enabled, enable nvidia-docker
    virtualisation.docker.enableNvidia =
      lib.mkIf config.virtualisation.docker.enable true;
    # fix electron problems with nvidia
    environment.sessionVariables.NIXOS_OZONE_WL = "1";

  };
}
