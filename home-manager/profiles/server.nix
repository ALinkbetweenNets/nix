{ lib, pkgs, flake-self, config, system-config, ... }:
with lib; {
  imports = [ ./common.nix ];
  config = {
    home.packages = with pkgs;
      [
        # zola
        nodejs
        # hugo
      ];
  };
}
