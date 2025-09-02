{ lib, pkgs, config, ... }:
with lib;
let cfg = config.link.java;
in {
  options.link.java.enable = mkEnableOption "activate java toolchain";
  config = mkIf cfg.enable {
    # home.packages = with pkgs; [ jdk21 ];
    programs.vscode.profiles.default.extensions = with pkgs.vscode-extensions; [
      vscjava.vscode-java-pack
      redhat.java
      redhat.vscode-xml
    ];
    # programs.java.enable = true;
    # programs.vscode.userSettings."java.jdt.ls.jaca.home" =
    #   "${pkgs.openjdk21}/lib/openjdk";
  };
}
