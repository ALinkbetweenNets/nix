{ lib, pkgs, flake-self, config, system-config, ... }:
with lib; {
  imports = [ ./main.nix ./hardware.nix ];
  config = { programs.vscode.profiles.default.userSettings."window.zoomLevel" = -2; };
}
