{ lib, pkgs, config, nixgl, ... }:
with lib;
let
  cfg = config.link.nvidia;
  cudaoverlay = (self: super: {
    inherit (pkgs.cudapkgs)
      ffmpeg
      hashcat
      jellyfin
      jellyfin-ffmpeg
      ;
  });
in
{
  options.link.nvidia = { enable = mkEnableOption "activate nvidia support"; };
  config = mkIf cfg.enable {
    nixpkgs.overlays = [
      cudaoverlay
    ];
    home-manager.users."l" = mkIf config.link.users.l.enable {
      nixpkgs.overlays = [
        cudaoverlay
      ];
      # nixpkgs.config.cudaSupport = true;
    };
    # nixpkgs.config.cudaSupport = true;
    environment.systemPackages = with pkgs; [
      nixgl
      libva-utils
      nvidia-vaapi-driver
      nvtop-nvidia
      pciutils
      vdpauinfo
      cudaPackages.cudatoolkit
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
