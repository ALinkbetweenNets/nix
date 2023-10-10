{ lib, pkgs, config, ... }:
with lib;
let cfg = config.link.openssh;
in {

  options.link.openssh.enable = mkEnableOption "activate openssh";

  config = mkIf cfg.enable {

    # Enable the OpenSSH daemon.
    services.openssh = {
      enable = true;
      startWhenNeeded = true;
      settings = {
        #PasswordAuthentication = false;
        #KbdInteractiveAuthentication = false;
      };
    };

  };
}
