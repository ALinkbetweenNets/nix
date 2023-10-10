{ lib, pkgs, config, ... }:
with lib;
let cfg = config.link.users.root;
in {
  options.link.users.root.enable = mkEnableOption "activate user root";
  config = mkIf cfg.enable {
    users.users.root = { };
  };
}
