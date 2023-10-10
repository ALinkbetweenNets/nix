{ lib, pkgs, config, flake-self, system-config, ... }:
with lib;
let cfg = config.link.rust;
in
{

  options.link.rust.enable = mkEnableOption "activate rust toolchain";

  config = mkIf cfg.enable {

    # TODO see if this is feasable or if it is a better idea to use rust using a nix shell
    # (i heared that it is a bad idea to install gcc directly this way)
    home.packages = with pkgs; [
      cargo
      clippy
      gcc
      rustc
      rustfmt
    ];

    programs.vscode.extensions = with pkgs.vscode-extensions; [ rust-lang.rust-analyzer ];
  };
}
