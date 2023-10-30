{ lib, pkgs, config, ... }:
with lib;
let cfg = config.link.java;
in {
  options.link.java.enable = mkEnableOption "activate java toolchain";
  config = mkIf cfg.enable {
    #home.packages = with pkgs; [ ];
    programs.vscode.extensions = with pkgs.vscode-extensions; [ redhat.java ];
    programs.java.enable = true;
  };
}
