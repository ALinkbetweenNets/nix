{ lib, pkgs, config, flake-self, system-config, ... }: {
  programs = {
    git = {
      enable = true;
      extraConfig = { pull.rebase = false; };
      userEmail = "alinkbetweennets@protonmail.com";
      userName = "ALinkbetweenNets";
      aliases = {
        co = "checkout";
        p = "pull";
        ps = "push";
        s = "status";
      };
      config={
        init = { defaultBranch = "main"; };
        # credential.helper = "${
        #     pkgs.git.override { withLibsecret = true; }
        #   }/bin/git-credential-libsecret";
      };

      attributes = [ "*.pdf diff=pdf" ];
      #delta.enable = true;
      diff-so-fancy.enable = true;
      lfs.enable = true;
    };
    git-cliff.enable = true;
    gitui.enable = true;
    gh.gitCredentialHelper.enable = true;
  };
}
