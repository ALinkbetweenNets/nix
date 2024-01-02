{ lib, pkgs, flake-self, config, system-config, ... }:
with lib; {
  imports = [ ./laptop.nix ];
  # screen rotation, wacom support
  # home.packages = with pkgs; [ xournalpp ];
}
