{ lib, pkgs, ... }:
with lib;
{
  programs.neovim = {
    enable = true;
    coc.enable = true;
    plugins = with pkgs.vimPlugins; [ yankring vim-nix ];
  };
}
