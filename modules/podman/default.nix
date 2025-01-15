{ lib, pkgs, config, ... }:
with lib;
let cfg = config.link.podman;
in {
  options.link.podman.enable = mkEnableOption "activate podman containers";
  config = mkIf cfg.enable {
    virtualisation = {
      oci-containers.backend = "podman";
      podman = {
        enable = true;
        # Create a `docker` alias for podman, to use it as a drop-in replacement
        dockerCompat = true;
        dockerSocket.enable = true;
        # networkSocket.enable = true; # Make available over network via docker compat API
        autoPrune.enable = true;
        extraPackages = with pkgs; [ gvisor ];
        # Required for containers under podman-compose to be able to talk to each other.
        defaultNetwork.settings.dns_enabled = true;
        # For Nixos version > 22.11
        #defaultNetwork.settings = {
        #  dns_enabled = true;
        #};
      };
    };
    environment.systemPackages = with pkgs; [ podman-compose podman-tui ];
  };
}
