{ ... }: {
  programs = {
    git = {
      enable = true;
      extraConfig = {
        pull.rebase = false;
        init.defaultBranch = "main";
        delta.navigate = true;
        delta.dark = true;
        merge.conflictstyle = "zdiff3";

      };
      userEmail = "alinkbetweennets@protonmail.com";
      userName = "ALinkbetweenNets";
      aliases = {
        co = "checkout";
        c = "clone";
        p = "pull";
        ps = "push";
        s = "status";
      };
      ignores = [ ".direnv/" ];
      attributes = [ "*.pdf diff=pdf" ];
      delta.enable = true;
      # diff-so-fancy.enable = true;
      lfs.enable = true;
    };
    git-cliff.enable = true; # changelog generator
    # gitui.enable = true;
    lazygit = { enable = true; };
    gh.gitCredentialHelper.enable = true;
  };
}
