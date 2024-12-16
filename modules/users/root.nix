{ lib, pkgs, config, ... }:
with lib;
let cfg = config.link.users.root;
in {
  options.link.users.root.enable = mkEnableOption "activate user root";
  config = mkIf cfg.enable {
    users.users.root = {
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIOaLOyxsr6wgj0JoG/OrDywND2hG2nblOGUuZBPFG1U l@xn"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINI74luZ3xJcgaZYHzn5DtSpYufml+SbhZQV12gWGShS l@dn"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIj1OASl4OePBngiPlI4hixiD1GBlPOSoVNeoEcD23d+ l@fn"
      ];
      hashedPasswordFile =
        config.sops.secrets."users/root/hashedPassword".path; # Initial password
    };
    sops.secrets."users/root/hashedPassword" = { neededForUsers = true; };
  };
}
