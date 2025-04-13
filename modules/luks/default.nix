{ lib, pkgs, config, ... }:
with lib;
let cfg = config.link.fs.luks;
in {
  options.link.fs.luks.enable = mkEnableOption "activate luks";
  # ONLY ENABLE ONCE "/etc/secrets/initrd/id_ed25519" exists
  # mkdir -p /etc/secrets/initrd
  # ssh-keygen -t ed25519 -N "" -f /etc/secrets/initrd/id_ed25519
  config = mkIf cfg.enable {
    systemd.tmpfiles.rules = [ "d /etc/secrets/initrd 0600 root root -" ];
    services.openssh.hostKeys = [{
      path = "/etc/secrets/initrd/id_ed25519";
      rounds = 200;
      type = "ed25519";
    }];
    boot = {
      kernelParams = [ "ip=dhcp" ];
      ## This enables initrd to run a ssh server for entering the password for luks decryption
      initrd = {
        systemd.users.root.shell = "/bin/cryptsetup-askpass";
        # secrets = {
        #   "/etc/secrets/initrd/ed25519.key" = /etc/secrets/initrd/ed25519.key;
        # };
        # supportedFilesystems = { btrfs=true; };
        network = {
          enable = true;
          flushBeforeStage2 = true;
          # udhcpc.enable = true;
          # postCommands = ''
          #   # Automatically ask for the password on SSH login
          #   echo 'cryptsetup-askpass || echo "Unlock was successful; exiting SSH session" && exit 1' >> /root/.profile
          # '';
          ssh = {
            enable = true;
            port = 25222;
            hostKeys = [ "/etc/secrets/initrd/id_ed25519" ];
            # authorizedKeys = [
            #   "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIOaLOyxsr6wgj0JoG/OrDywND2hG2nblOGUuZBPFG1U l@xn"
            #   "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINI74luZ3xJcgaZYHzn5DtSpYufml+SbhZQV12gWGShS l@dn"
            #   "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIj1OASl4OePBngiPlI4hixiD1GBlPOSoVNeoEcD23d+ l@fn"
            # ];

          };
        };
        availableKernelModules =
          [ "r8169" ]; # should work for most network hardware
      };
    };
  };
}
