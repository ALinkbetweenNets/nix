{ ... }: {
  programs = {
    delta.enableGitIntegration = true;
    git = {
      enable = true;
      settings = {
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
      ignores = [ ".direnv/" ];
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
