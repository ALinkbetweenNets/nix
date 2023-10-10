{ lib, pkgs, config, flake-self, system-config, ... }: {
  home.packages = with pkgs;
    [
      prismlauncher # minecraft launcher
      steam
    ] ++ lib.optionals
      (system-config.nixpkgs.hostPlatform.system == "x86_64-linux") [ ];
}
