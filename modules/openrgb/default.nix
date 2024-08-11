{ lib, pkgs, config, ... }:
with lib;
let
  #openrgb-rules = builtins.fetchurl {
  #  url = "https://openrgb.org/releases/release_0.9/60-openrgb.rules";
  #  sha256 = "0f5bmz0q8gs26mhy4m55gvbvcyvd7c0bf92aal4dsyg9n7lyq6xp";
  #};
  cfg = config.link.openrgb;
in {
  options.link.openrgb.enable = mkEnableOption "activate openrgb";
  config = mkIf cfg.enable {
    # set kernel modules required for openrgb to work
    boot.kernelModules = [ "i2c-dev" "i2c-piix4" ];
    # set udef rules that are required that openrgb can be run without root rights (currently broken)
    #services.udev.extraRules = builtins.readFile openrgb-rules;
    # install openrgb package globally
    environment.systemPackages = with pkgs; [ openrgb ];
  };
}
