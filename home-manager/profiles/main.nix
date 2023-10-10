{ lib, pkgs, flake-self, config, system-config, ... }:
with lib; {
  # imports = with flake-self.homeManagerModules; [ "office" ];
  config = {
    link.office.enable = true;
    link.pentesting.enable = true;
    services.kdeconnect = {
      enable = true;
      indicator = true;
    };
  };
}
