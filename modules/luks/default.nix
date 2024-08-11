{ lib, pkgs, config, ... }:
with lib;
let cfg = config.link.fs.luks;
in {
  options.link.fs.luks.enable = mkEnableOption "activate luks";
  config = mkIf cfg.enable {
    systemd.tmpfiles.rules = [ "d /etc/secrets/initrd 0600 root root -" ];
    services.openssh.hostKeys = [{
      path = "/etc/secrets/initrd/ed25519";
      rounds = 200;
      type = "ed25519";
    }];
    boot.kernelParams = [ "ip=dhcp" ];
    ## This enables initrd to run a ssh server for entering the password for luks decryption
    boot.initrd = {
      systemd.users.root.shell = "/bin/cryptsetup-askpass";
      # secrets = {
      #   "/etc/secrets/initrd/ed25519.key" = /etc/secrets/initrd/ed25519.key;
      # };
      network = {
        enable = true;
        ssh = {
          enable = true;
          port = 25222;
          hostKeys = [ "/etc/secrets/initrd/ed25519.key" ];
          ignoreEmptyHostKeys = true;
        };
      };
      availableKernelModules =
        [ "r8169" ]; # should work for most network hardware
    };
  };
}
