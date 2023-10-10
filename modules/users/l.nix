{ lib, pkgs, config, ... }:
with lib;
let cfg = config.link.users.l;
in {

  options.link.users.l = { enable = mkEnableOption "activate user l"; };

  config = mkIf cfg.enable {

    users.users.l = {
      isNormalUser = true;
      home = "/home/l";
      extraGroups = [ "wheel" ]
        ++ lib.optionals config.networking.networkmanager.enable
        [ "networkmanager" ];
      shell = "${pkgs.zsh}/bin/zsh";
    };
    nix.settings.allowed-users = [ "l" ];
  };

}
