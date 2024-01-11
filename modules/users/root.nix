{ lib, pkgs, config, ... }:
with lib;
let cfg = config.link.users.root;
in {
  options.link.users.root.enable = mkEnableOption "activate user root";
  config = mkIf cfg.enable {
    users.users.root = {
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID/1eePE6/pYo4aahzcDRqbmnVdx9ikKH+93yw7M1pXH l@xn"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINI74luZ3xJcgaZYHzn5DtSpYufml+SbhZQV12gWGShS l@dn"
      ];
      hashedPasswordFile = config.sops.secrets."users/root/hashedPassword".path; # Initial password
    };
    sops.secrets."users/root/hashedPassword" = { neededForUsers = true; };
  };
}
