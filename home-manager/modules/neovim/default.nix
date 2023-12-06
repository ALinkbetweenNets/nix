{ lib, pkgs, ... }:
with lib;
{
  programs.nixvim = {
    enable = true;
    plugins.lightline.enable = true;
    colorschemes.gruvbox.enable = true;
    options = {
      number = true; # Show line numbers
      relativenumber = true; # Show relative line numbers
      shiftwidth = 2; # Tab width should be 2
    };
  };
}
