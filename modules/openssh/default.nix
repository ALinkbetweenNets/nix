{ lib, pkgs, config, ... }:
with lib;
let cfg = config.link.openssh;
in {
  options.link.openssh.enable = mkEnableOption "activate openssh";
  config = mkIf cfg.enable {
    # networking.firewall.allowedTCPPorts = [ 2522 ];
    networking.firewall.interfaces."tailscale0".allowedTCPPorts = mkIf config.link.tailscale.enable [ 2522 ];
    networking.firewall.allowedTCPPorts = mkIf (!config.link.sops || !config.link.tailscale.enable) [ 2522 ];
    # Enable the OpenSSH daemon.
    services.openssh = {
      enable = true;
      openFirewall = false;
      startWhenNeeded = true;
      listenAddresses = [
        {
          addr = "0.0.0.0";
          port = 2522;
        }
      ];
      settings = {
        LogLevel = "VERBOSE"; # for fail2ban to work properly
        PermitRootLogin = "prohibit-password";
        PasswordAuthentication = true;
        KbdInteractiveAuthentication = true;
        X11Forwarding = true;
        UseDns = true;
        GatewayPorts = "yes";
        maxAuthTries = 5;
        Ciphers = [
          "chacha20-poly1305@openssh.com"
          "aes256-gcm@openssh.com"
          "aes256-ctr"
          # "aes256-cbc" # insecure
        ];
        Macs = [
          "hmac-sha2-512-etm@openssh.com"
          # "umac-128-etm@openssh.com"
        ];
        KexAlgorithms = [
          #"sntrup761x25519-sha256@openssh.com"
          # "curve25519-sha256"
          #"curve25519-sha256@libssh.org"
          "diffie-hellman-group-exchange-sha256"
          #"aes128-ctr"
          #"aes128-gcm@openssh.com"
          #"aes192-ctr"
          "curve25519-sha256"
          "diffie-hellman-group16-sha512"
          "diffie-hellman-group18-sha512"
          #"rsa-sha2-256"
          #"rsa-sha2-512"
          "sntrup761x25519-sha512@openssh.com"
        ];
      };
      sftpServerExecutable = "internal-sftp";
      hostKeys = [{
        path = "/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
        rounds = 200;
      }];
      # banner = ''
      #                :cc:        xkkkko      okkd
      #               .cccc;        lkkkkl    lkkkk:
      #                .cccc:        ,kkkkd  okkkk,
      #                  cccc:.       .kkkkxxkkkk.
      #           .......:ccccc'........kkkkkkkk
      #          ,cccccccccccccc:::::::,.dkkkkk        ,,
      #         ;ccccccccccccccc::::::::;.;kkkko      ;cc;
      #                  ccccc.            .kkkkd    :cccc
      #                .xxxxx.               xxxxx .ccccc
      #               ,xkkkx                  dxx.,cccc;
      #    :lllllllllokkkkl                    ,.;ccccc:;;;;;;,
      #   .kkkkkkkkkkkkkk;.                     :cccccccccccccc.
      #           ckkkkk.';.                  .:::cc
      #          'kkkkk.':::'                .::::;
      #         :kkkkd  .::::,              ,::::'
      #        .kkkk:    .:::::            ',,,,,.
      #         .kk'       :ccc:'.xxxxkkkkkkkkkkkkkkkkkkk.
      #                   .cccccc,.xxxkkkkkkkkkkkkkkkkkk
      #                  'cccccccc;        lkkkkx
      #                 ,cccc,.cccc:        ;kkkko
      #                :cccc.   ccccc.       .kkkkx.
      #                cccc      ccccc.        kkkk
      #                .cc'      .ccccc.       ,kk;
      # '';
    };
  };
}
