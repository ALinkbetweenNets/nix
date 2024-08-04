{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.link.users.lenny;
in
{
  options.link.users.lenny = {
    enable = mkEnableOption "activate user lenny";
  };
  config = mkIf cfg.enable {
    users.users.lenny = {
      isNormalUser = true;
      home = "/rz/sftp/lenny/home";
      # extraGroups = [ "wheel" "adbusers" "audio" "plugdev" "docker" ]
      #   ++ lib.optionals config.networking.networkmanager.enable
      #   [ "networkmanager" ];
      # shell = "${pkgs.zsh}/bin/zsh";
    };
    # Note on sftp chrooting: The chroot folder must be owned by root and set to 755. Inside that folder create one or more folders owned by the user
    services.openssh.extraConfig = ''
      Match User lenny
        ChrootDirectory /rz/sftp/%u
        ForceCommand internal-sftp
        AllowTcpForwarding no
    '';
  };
}
