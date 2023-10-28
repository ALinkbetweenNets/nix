{ lib, pkgs, config, ... }:
with lib;
let cfg = config.link.users.jucknath;
in {
  options.link.users.jucknath = { enable = mkEnableOption "activate user jucknath"; };
  config = mkIf cfg.enable {
    users.users.jucknath = {
      isNormalUser = true;
      home = "/home/jucknath";
      extraGroups = [ "wheel" "adbusers" "audio" "plugdev" "docker" ]
        ++ lib.optionals config.networking.networkmanager.enable
        [ "networkmanager" ];
      shell = "${pkgs.zsh}/bin/zsh";
    };
  };

}
