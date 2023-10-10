{ lib, pkgs, config, flake-self, system-config, ... }:
with lib;
let cfg = config.link.neovim;
in {
  programs.neovim = {
    enable = true;
    coc.enable = true;
    plugins = with pkgs.vimPlugins; [ yankring vim-nix ];
  };
}
