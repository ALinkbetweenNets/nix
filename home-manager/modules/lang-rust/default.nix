{ lib, pkgs, config, ... }:
with lib;
let cfg = config.link.rust;
in {
  options.link.rust.enable = mkEnableOption "activate rust toolchain";
  config = mkIf cfg.enable {
    home.packages = with pkgs; [ cargo clippy gcc lldb rustc rustfmt ];
    programs.vscode.profiles.default.extensions = with pkgs.vscode-extensions; [
      rust-lang.rust-analyzer
      serayuzgur.crates
      tamasfe.even-better-toml
      llvm-vs-code-extensions.vscode-clangd
      fill-labs.dependi
    ];
  };
}
