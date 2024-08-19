{ lib, pkgs, config, ... }:
with lib;
let cfg = config.link.users.lmh01;
in {
  options.link.users.lmh01 = { enable = mkEnableOption "activate user lmh01"; };
  config = mkIf cfg.enable {
    users.users.lmh01 = {
      extraGroups = [ "jellyfin" ];
      isNormalUser = true;
      # extraGroups = [ "wheel" "adbusers" "audio" "plugdev" "docker" ]
      #   ++ lib.optionals config.networking.networkmanager.enable
      #   [ "networkmanager" ];
      # shell = "${pkgs.zsh}/bin/zsh";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMHnB5ZsoYbWAa5ndFOngbcLz14yHwewX9Fp62cBkcpw"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIZC4KwR8QrKvOgClilSOhWFh7rblPoRbvVRZ6+uVhNn"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJl+fklAKH1RfSMIB34IK/Vb/tsE07a5fBM4Cy+8sg8q"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGRgxtfc9L1/T/q4JmYZlQupGfDqOx0ewYzOBz3BbehD"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGms0mqx1W833hFHUm8+5kKQKGjWPiYvkii23Ytx02cC"
      ];
    };
    # Note on sftp chrooting: The chroot folder must be owned by root and set to 755. Inside that folder create one or more folders owned by the user
    services.openssh.extraConfig = ''
      Match User lmh01
        ChrootDirectory /home/
        ForceCommand internal-sftp
        AllowTcpForwarding no
    '';
  };
}
