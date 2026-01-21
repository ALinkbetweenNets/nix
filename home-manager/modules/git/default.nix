{ pkgs, lib, ... }: {
  programs = {
    delta.enableGitIntegration = true;
    git = {
      enable = true;
      # package = lib.mkForce pkgs.gitFull;
      settings = {
        maintenance.enable = true;
        maintenance.timers = {
          daily = "Tue..Sun *-*-* 0:53:00";
          hourly = "*-*-* 1..23:53:00";
          weekly = "Mon 0:53:00";
        };
        settings = { init.defaultBranch = "main"; };
        # pull.rebase = false;
        # init.defaultBranch = "main";
        # merge.conflictstyle = "zdiff3";
        # email = "alinkbetweennets@protonmail.com";
        # user = "ALinkbetweenNets";
        aliases = {
          co = "checkout";
          c = "clone";
          p = "pull";
          ps = "push";
          s = "status";
        };
        delta.enable = true;
      };
      ignores = [ ".direnv" "*~" "*.swp" ".vscode" ];
      attributes = [ "*.pdf diff=pdf" ];
      # diff-so-fancy.enable = true;
      lfs.enable = true;
    };
    git-cliff.enable = true; # changelog generator
    # gitui.enable = true;
    lazygit = { enable = true; };
    gh.gitCredentialHelper.enable = true;
  };
}
