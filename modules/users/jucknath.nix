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
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA5kMfQF0aJyGsvoaV8itiuIm0ZzkG/75hZT5qWOxdIChopXBvJfUMMGjSmElUJFf6miyv6kYtCAYJtEF5RIZzhFIOAcID0vAVkNYE73Xf1eFHpkMGaS766TWHq7kCcT84TLbtXNpiseqQC1OjhNdU69I6leb80grc5W2vK8oAz7igu16pCtOggreDMvfGV2YsionQIEbMjnUCBKdKp8ynBHsWX0prglwIZMskPR2FkI4ez/tC+SmTFySB5pEBJ3ntbKAtkbUY6hOuk5BCUoFFg8h0xTrqr0kDWGJXTmmjXytJdgESdBVV+mC6WhMCrh61WDXcWxNVeasKAOuY7XgVaQ== jucknath@jucknath-laptop"
      ];
    };
  };
}
