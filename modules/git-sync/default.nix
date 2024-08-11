{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.git-sync;
in {
  options.link.git-sync.enable = mkEnableOption "activate git-sync";
  config = mkIf cfg.enable {
    systemd.services.git-pull-repo-obsidian = {
      description = "Regularly pull changes from Git repository obsidian";
      serviceConfig.Type = "oneshot";
      serviceConfig.ExecStart = "/usr/bin/git -C /home/l/obsidian pull";
    };
    systemd.timers.git-pull-timer-repo-obsidian = {
      description =
        "Timer to regularly pull changes from Git repository obsidian";
      timerConfig.OnCalendar = "*-*-* *:0/05:00";
      timerConfig.Unit = "git-pull-repo-obsidian.service";
    };
    systemd.services.git-pull-repo-s = {
      description = "Regularly pull changes from Git repository s";
      serviceConfig.Type = "oneshot";
      serviceConfig.ExecStart = "/usr/bin/git -C /home/l/s pull";
    };
    systemd.timers.git-pull-timer-repo-s = {
      description = "Timer to regularly pull changes from Git repository s";
      timerConfig.OnCalendar = "*-*-* *:0/30:00";
      timerConfig.Unit = "git-pull-repo-s.service";
    };
    systemd.services.git-pull-repo-nix = {
      description = "Regularly pull changes from Git repository nix";
      serviceConfig.Type = "oneshot";
      serviceConfig.ExecStart = "/usr/bin/git -C /home/l/nix pull";
    };
    systemd.timers.git-pull-timer-repo-nix = {
      description = "Timer to regularly pull changes from Git repository nix";
      timerConfig.OnCalendar = "*-*-* *:0/10:00";
      timerConfig.Unit = "git-pull-repo-nix.service";
    };
  };
}
