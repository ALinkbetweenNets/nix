{ lib, pkgs, config, ... }:
with lib;
let cfg = config.link.java;
in {
  options.link.java.enable = mkEnableOption "activate java toolchain";
  config = mkIf cfg.enable {
    home.packages = with pkgs; [ jdk19 ];
    programs.vscode.extensions = with pkgs.vscode-extensions; [ vscjava.vscode-java-pack redhat.java ];
    programs.java.enable = true;
  };
}
