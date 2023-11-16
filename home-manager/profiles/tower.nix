{ lib, pkgs, flake-self, config, system-config, ... }:
with lib; {
  imports = [ ./main.nix ./hardware.nix ];
  config = { programs.vscode.userSettings."window.zoomLevel" = -3; };
}
