{ lib, pkgs, config, ... }:
with lib;
let cfg = config.link.golang;
in {
  options.link.golang.enable = mkEnableOption "activate golang toolchain";
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      go
      # gcc
      delve
    ];
    programs.vscode.profiles.default.extensions = with pkgs.vscode-extensions;
      [ golang.go ];
  };
}
