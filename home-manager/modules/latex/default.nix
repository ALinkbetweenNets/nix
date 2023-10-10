{ lib, pkgs, config, flake-self, system-config, ... }:
with lib;
let cfg = config.link.latex;
in {

  options.link.latex.enable = mkEnableOption "enable latex using texlive";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      texlive.combined.scheme-full
    ];

    # enable vscode extension
    programs.vscode.extensions = with pkgs.vscode-extensions; [ james-yu.latex-workshop ];
  };

}
