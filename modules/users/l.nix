{ lib, pkgs, config, ... }:
with lib;
let cfg = config.link.users.l;
in {
  options.link.users.l = { enable = mkEnableOption "activate user l"; };
  config = mkIf cfg.enable {
    users.users.l = {
      isNormalUser = true;
      home = "/home/l";
      extraGroups = [
        "wheel"
        "adbusers"
        "audio"
        "plugdev"
        "wireshark"
        "video"
        "i2c"
        "plugdev"
      ] ++ lib.optionals config.networking.networkmanager.enable
        [ "networkmanager" ]
        ++ lib.optionals config.link.printing.enable [ "scanner" "lp" ]
        ++ lib.optionals config.link.libvirt.enable [ "libvirtd" "kvm" ]
        ++ lib.optionals config.link.docker.enable [ "docker" ];
      shell = "${pkgs.zsh}/bin/zsh";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIOaLOyxsr6wgj0JoG/OrDywND2hG2nblOGUuZBPFG1U l@xn"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM0skthdvhy0oNOD/nbZ4H6tcMOffiNiRlquVTtdZIy/ l@x390"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINI74luZ3xJcgaZYHzn5DtSpYufml+SbhZQV12gWGShS l@dn"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIj1OASl4OePBngiPlI4hixiD1GBlPOSoVNeoEcD23d+ l@fn"
      ];
      hashedPasswordFile = mkIf config.link.sops
        config.sops.secrets."users/l/hashedPassword".path; # Initial password
    };
    sops.secrets."users/l/hashedPassword" =
      mkIf config.link.sops { neededForUsers = true; };
    # services.openssh.hostKeys = [{
    #   path = "${config.users.users.l.home}/.ssh/id_ed25519";
    #   rounds = 500;
    #   type = "ed25519";
    # }];
    nix.settings = {
      allowed-users = [ "l" ];
      trusted-users = [ "l" ];
    };
  };
}
