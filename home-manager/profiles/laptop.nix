{ lib, pkgs, flake-self, config, system-config, ... }:
with lib; {
  imports = [ ./main.nix ./hardware.nix ];
  config = {
    home.packages = with pkgs;
      [
        system-config.xr-linux-flake.packages.x86_64-linux.xrlinuxdriver
        system-config.xr-linux-flake.packages.x86_64-linux.breezy-desktop-kwin
        #parsec-bin
      ] ++ lib.optionals
      (system-config.nixpkgs.hostPlatform.system == "x86_64-linux") [ ];
    programs = { vscode.profiles.default.userSettings."window.zoomLevel" = 0; };
  };
}
