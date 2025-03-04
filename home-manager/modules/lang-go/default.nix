{ lib, pkgs, config, ... }:
with lib;
let cfg = config.link.golang;
in {
  options.link.golang.enable = mkEnableOption "activate golang toolchain";
  config = mkIf cfg.enable {
    home.packages = with pkgs; [ go delve ];
    programs.vscode.extensions = with pkgs.vscode-extensions; [ golang.go ];
  };
}
