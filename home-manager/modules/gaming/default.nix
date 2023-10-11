{ lib, pkgs, config, flake-self, system-config, ... }:
with lib;
let cfg = config.link.gaming;
in {
  options.link.gaming.enable = mkEnableOption "enable gaming";
  config = mkIf cfg.enable {
    home.packages = with pkgs;
      [
        prismlauncher # minecraft launcher
        steam
      ] ++ lib.optionals
      (system-config.nixpkgs.hostPlatform.system == "x86_64-linux") [ ];
  };
}
