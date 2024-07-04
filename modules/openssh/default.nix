{ lib, pkgs, config, ... }:
with lib;
let cfg = config.link.openssh;
in {
  options.link.openssh.enable = mkEnableOption "activate openssh";
  config = mkIf cfg.enable {
    # Enable the OpenSSH daemon.
    services.openssh = {
      enable = true;
      openFirewall = true;
      startWhenNeeded = true;
      listenAddresses = [
        {
          addr = "0.0.0.0";
          port = 2522;
        }
      ] ++ lib.optionals (config.link.tailscale-address != "") [
        {
          addr = config.link.tailscale-address;
          port = 22;
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
          # "sntrup761x25519-sha512@openssh.com"
          # "curve25519-sha256"
          "curve25519-sha256@libssh.org"
          "diffie-hellman-group-exchange-sha256"
          "ecdh-sha2-nistp521"
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
