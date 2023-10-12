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
      settings = {
        PermitRootLogin = "no";
        #PasswordAuthentication = false;
        #KbdInteractiveAuthentication = false;
        X11Forwarding = true;
        UseDns = true;
        Ciphers = [
          "chacha20-poly1305@openssh.com"
          "aes256-gcm@openssh.com"
          "aes256-ctr"
        ];
        Macs = [ "hmac-sha2-512-etm@openssh.com" "umac-128-etm@openssh.com" ];
        KexAlgorithms = [
          "sntrup761x25519-sha512@openssh.com"
          "curve25519-sha256"
          "curve25519-sha256@libssh.org"
          "diffie-hellman-group-exchange-sha256"
        ];
      };
      sftpServerExecutable = "internal-sftp";
      hostKeys = [{
        path = "/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
        rounds = 200;
      }];

      banner = ''
        KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK
        KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK
        KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK
        KKKKKKKKKKKKKKKKKK0xoc;,'........,;cdOKKKKKKKKKKKKKKKKKKKKK
        KKKKKKKKKKKKKKOo,.                    .:kKKKKKKKKKKKKKKKKKK
        KKKKKKKKKKKKo.       ....'''''''''....      ,OKKKKKKKKKKKKKKKK
        KKKKKKKKKKo.     ..'''''''''''''''''''''''''''..    dKKKKKKKKKKKKKKK
        KKKKKKKK0,     ...........'''''''''''''''''''.    xKKKKKKKKKKKKKK
        KKKK0d:'......................'''''''''''''..   .0KKKKKKKKKKKKK
        KKKo.....';:cloolccccc::;,.......''''''''''.    :KKKKKKKKKKKKK
        KK:...,kNWMMMMMMM0OOOOOOOOOd,.....'''''''''..    0KKKKKKKKKKKK
        Kd...'ONMMWWNNXXKOOOOOOOOOOkc:....'''''''''..    ,codk0KKKKKKK
        K;...:OO00OOOOOOOOOOOOOOOOkocc'....'''''''...         .,l0KKK
        K,...;dOOOOOOOOOOOOOOOOkdocccc'...'''''''''...    ....    .KKK
        Kl...,cclooddddddddoolccccccc:....'''''''''...    '''''''''   oKK
        K0,....;cccccccccccccccccccc;.....'''''''''...    .....'.  'KK
        KKKl......',;;::ccccc:::;,'......''''''''''...    .......   OK
        KKKKl  .........................''''''''''''...    .......   dK
        KKKK:   ....................''''''''''''''''''...    .......   :K
        KKKK;   ''''''''''''''''''''''''''''''''''''''''''''''''...    .......   'K
        KKKK,   ''''''''''''''''''''''''''''''''''''''''''''''....    .......   .K
        KKKK,   .'''''''''''''''''''''''''''''''''''''''''''''....    .......    0
        KKKK,   ..''''''''''''''''''''''''''''''''''''''''''.....    .......    0
        KKKK;   ...'''''''''''''''''''''''''''''''''''''''......    .......   .K
        KKKKc   ....''''''''''''''''''''''''''''''''''........    .......   .K
        KKKKo    .....'''''''''''''''''''''''''''...........    .......   ;K
        KKKKO    ..................................    ......    dK
        KKKKK.   ..................................    ......   .KK
        KKKKK:   ..................................    .....    dKK
      '';
    };
  };
}
