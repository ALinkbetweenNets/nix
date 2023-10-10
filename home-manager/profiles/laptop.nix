{ lib, pkgs, flake-self, config, system-config, ... }:
with lib; {


  imports = [ ./desktop.nix ./main.nix ];

  config = {

    home.packages = with pkgs; [
      parsec-bin
    ] ++ lib.optionals (system-config.nixpkgs.hostPlatform.system == "x86_64-linux") [ ];

    programs = { };

    services = { };

  };

}
