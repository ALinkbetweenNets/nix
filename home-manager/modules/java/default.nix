{ lib, pkgs, config, flake-self, system-config, ... }:
with lib;
let cfg = config.link.rust;
in {
  options.link.java.enable = mkEnableOption "activate rust toolchain";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ ];
    programs.vscode.extensions = with pkgs.vscode-extensions; [ redhat.java ];
  };
}
