{ lib, pkgs, flake-self, config, system-config, ... }:
with lib; {
  imports = [ ./main.nix flake-self.homeManagerModules.gaming ];
  config = { link = { gaming.enable = true; }; };
}
