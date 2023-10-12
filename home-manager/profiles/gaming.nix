{ lib, pkgs, flake-self, config, system-config, ... }:
with lib; {
  imports = with ; [ ./main.nix flake-self.homeManagerModules.gaming ];

    config = {
  link = {
  gaming.enable = true;
};
};

}
