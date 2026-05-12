{ pkgs, lib, ... }:
{
  programs = {
    delta.enableGitIntegration = true;
    git = {
      enable = true;
      signing = {
        # package = lib.mkForce pkgs.gitFull;
        format = "ssh";
        signByDefault = true;
      };
      maintenance = {
        enable = true;
        timers = {
          daily = "Tue..Sun *-*-* 0:53:00";
          hourly = "*-*-* 1..23:53:00";
          weekly = "Mon 0:53:00";
        };
      };
      ignores = [
        ".direnv"
        "*~"
        "*.swp"
        ".vscode"
      ];
      attributes = [ "*.pdf diff=pdf" ];
      # diff-so-fancy.enable = true;
      lfs.enable = true;
      settings = {
        gpg.ssh.allowedSignersFile = "~/.ssh/id_ed25519.pub";
        core = {
          whitespace = "trailing-space,space-before-tab";
        };
        init.defaultBranch = "main";
        pull.rebase = true;
        pull.autoStash = true;
        # merge.conflictstyle = "zdiff3";
        aliases = {
          co = "checkout";
          c = "clone";
          p = "pull";
          ps = "push";
          s = "status";
        };
        delta.enable = true;
      };
    };
    git-cliff.enable = true; # changelog generator
    # gitui.enable = true;
    lazygit = {
      enable = true;
    };
    gh.gitCredentialHelper.enable = true;
  };
}
