{ lib, pkgs, config, ... }:
with lib;
let cfg = config.link.users.l;
in {
  options.link.users.l = { enable = mkEnableOption "activate user l"; };
  config = mkIf cfg.enable {
    users.users.l = {
      isNormalUser = true;
      home = "/home/l";
      extraGroups = [ "wheel" "adbusers" "audio" "plugdev" "wireshark" "video" "i2c" ]
        ++ lib.optionals config.networking.networkmanager.enable
        [ "networkmanager" ]
        ++ lib.optionals config.link.printing.enable
        [ "scanner" "lp" ]
        ++ lib.optionals config.link.libvirt.enable
        [ "libvirtd" "kvm" ]
        ++ lib.optionals config.link.docker.enable
        [ "docker" ]
      ;
      shell = "${pkgs.zsh}/bin/zsh";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID/1eePE6/pYo4aahzcDRqbmnVdx9ikKH+93yw7M1pXH l@xn"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINI74luZ3xJcgaZYHzn5DtSpYufml+SbhZQV12gWGShS l@dn"
      ];
      hashedPasswordFile = config.sops.secrets."users/l/hashedPassword".path; # Initial password
    };
    sops.secrets."users/l/hashedPassword" = { neededForUsers = true; };
    nix.settings.allowed-users = [ "l" ];
  };
}
