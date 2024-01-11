{ lib, pkgs, config, ... }:
with lib;
let cfg = config.link.users.lenny;
in {
  options.link.users.lenny = { enable = mkEnableOption "activate user lenny"; };
  config = mkIf cfg.enable {
    users.users.lenny = {
      isNormalUser = true;
      home = "/home/lenny";
      # extraGroups = [ "wheel" "adbusers" "audio" "plugdev" "docker" ]
      #   ++ lib.optionals config.networking.networkmanager.enable
      #   [ "networkmanager" ];
      # shell = "${pkgs.zsh}/bin/zsh";
      openssh.authorizedKeys.keys = [
      ];
    };
    services.openssh.extraConfig = ''
      Match User lenny
          ChrootDirectory /home/lenny
          ForceCommand internal-sftp
          AllowTcpForwarding no
    '';
  };
}
