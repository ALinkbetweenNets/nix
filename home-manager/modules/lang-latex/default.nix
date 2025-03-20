{ lib, pkgs, config, ... }:
with lib;
let cfg = config.link.latex;
in {
  options.link.latex.enable = mkEnableOption "enable latex with texlive";
  config = mkIf cfg.enable {
    home.packages = with pkgs; [ texlive.combined.scheme-full ];
    programs.vscode.profiles.default.extensions = with pkgs.vscode-extensions;
      [ james-yu.latex-workshop ];
  };
}
