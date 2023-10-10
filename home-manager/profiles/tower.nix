{ lib, pkgs, flake-self, config, system-config, ... }:
with lib; {

  imports = [ ./desktop.nix ./main.nix ];
  config = { };
}
