{ lib, pkgs, config, ... }:
with lib;
let cfg = config.link.users.paul;
in {
  options.link.users.paul = { enable = mkEnableOption "activate user paul"; };
  config = mkIf cfg.enable {
    users.users.paul = {
      isNormalUser = true;
      home = "/home/paul";
      extraGroups = [ "wheel" "adbusers" "audio" "plugdev" "docker" ]
        ++ lib.optionals config.networking.networkmanager.enable
        [ "networkmanager" ];
      shell = "${pkgs.zsh}/bin/zsh";
    };
  };
}
