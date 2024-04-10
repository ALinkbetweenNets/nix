{ lib, pkgs, config, ... }:
with lib;
let cfg = config.link.fs.luks;
in {
  options.link.fs.luks.enable = mkEnableOption "activate luks";
  config = mkIf cfg.enable
    {
      # systemd.services.generate-initrd-ssh-key = {
      #   wantedBy = [ "multi-user.target" ];
      #   serviceConfig.Type = "oneshot";
      #   path = [ pkgs.nix ];
      #   script = ''
      #     [[ -f /etc/nix/private-key ]] && exit
      #     mkdir -p /etc/secrets/initrd/ && ssh-keygen -t ed25519 -a 500 -f /etc/secrets/initrd/ed25519.key
      #   '';
      # };
      # systemd.tmpfiles.rules = [
      #   "d /etc/secrets/initrd 0600 root root"
      # ];
      services.openssh.hostKeys = [{
        path = "/etc/secrets/initrd/ed25519.key";
        rounds = 200;
        type = "ed25519";
      }];
      ## This enables initrd to run a ssh server for entering the password for luks decryption
      boot.initrd = {
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
        availableKernelModules = [ "r8169" ]; # should work for most network hardware
      };
      # boot.initrd.network.postCommands = ''
      #   # Automatically ask for the password on SSH login
      #   echo 'cryptsetup-askpass || echo "Unlock was successful; exiting SSH session" && exit 1' >> /root/.profile
      # '';
    };
}
