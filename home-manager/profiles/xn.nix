{ lib, pkgs, flake-self, config, system-config, ... }:
with lib; {

  imports = with flake-self.homeManagerModules; [ git zsh neovim vscode ];

  config = {
    home.packages = with pkgs;
      [
        #_1password-gui

      ] ++ lib.optionals
        (system-config.nixpkgs.hostPlatform.system == "x86_64-linux") [ ];

    programs = {  };


  };

}
