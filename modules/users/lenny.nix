{ lib, pkgs, config, ... }:
with lib;
let cfg = config.link.users.lenny;
in {
  options.link.users.lenny = { enable = mkEnableOption "activate user lenny"; };
  config = mkIf cfg.enable {
    users.users.lenny = {
      isNormalUser = true;
      home = "/rz/sftp/lenny";
      # extraGroups = [ "wheel" "adbusers" "audio" "plugdev" "docker" ]
      #   ++ lib.optionals config.networking.networkmanager.enable
      #   [ "networkmanager" ];
      # shell = "${pkgs.zsh}/bin/zsh";
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDLoxnTT9WVrfIqks5UeHQNstAUZlU+1fK/s4EoKLFYGifrtZJv3E3O8VuwxZyndjLRfwYYorKnyVqmdm9ebMnMgbzZPBfwkVdMMOEhO8JDgCC38A+cGZ3bJie1Wi7BiJnNhKAgcGdv+tsdt8AQfwJQRXdZV7NvNeBVs0XqZc05feP8jRAzh2HEAk0csU6U51doIGmbh+69iAHQhBqjy1LcF6VQmnf9vjVo2yiF/vl+xsDO5tWcbdZwnH7WL6qKCOT3xGqTJN6CA89gK/jvPuAdpi//VO0yVHypqXXqZCbYIs6D9TOdLOHPaBxSENwD/5MOJILzaX06LTLxrWV0FOhrRNh42QnFWyoIh/To1135rpz1PJDb8NGHqelKkRBF3HDSqRl0N9kdhFvjrEFph9hMYjb6DyAgkRSKHGDJfAwaeJwdNj5yv0iXX1ZfZcRPMgWdL5MZz2TWEBcBxi20/jxx4yooTNdvE09IlxQWr81flyhpSnBwd/ph1YyTkYKH548= lb@peridot"
      ];
    };
    services.openssh.extraConfig = ''
      Match User lenny
          ChrootDirectory /rz/sftp/lenny
          ForceCommand internal-sftp
          AllowTcpForwarding no
    '';
  };
}
