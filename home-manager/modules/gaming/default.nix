{ lib, pkgs, config, system-config, ... }:
with lib;
let cfg = config.link.gaming;
in {
  options.link.gaming.enable = mkEnableOption "enable gaming";
  config = mkIf cfg.enable {
    home.packages = with pkgs;
      [
        prismlauncher # minecraft launcher
        steam
        # protonup-qt
        # protontricks
        # winetricks
        # wine
        # wine64
        prismlauncher # minecraft launcher
      ] ++ lib.optionals
        (system-config.nixpkgs.hostPlatform.system == "x86_64-linux") [ ];
  };
}
