{ lib, pkgs, config, ... }:
with lib;
let cfg = config.link.fs.luks;
in {
  options.link.fs.luks.enable = mkEnableOption "activate luks";
  config = mkIf cfg.enable {
    sops.secrets."users/initrd/ssh-private" = {
      # path = "/etc/initrd/secrets/ssh-private";
    };
    ## This enables initrd to run a ssh server for entering the password for luks decryption
    boot.initrd = {
      # secrets = {
      #   "/root/initrd-ssh-private" = config.sops.secrets."users/initrd/ssh-private".path;
      # };
      network = {
        enable = lib.mkDefault true;
        ssh = {
          enable = lib.mkDefault true;
          port = 25222;
          hostKeys = [
            # /etc/initrd/secrets/ssh-private
            config.sops.secrets."users/initrd/ssh-private".path
          ];
        };
      };
      availableKernelModules = [ "r8169" ]; # should work for most network hardware
    };
  };
}
