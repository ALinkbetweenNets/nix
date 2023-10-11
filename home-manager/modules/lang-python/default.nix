{ lib, pkgs, config, flake-self, system-config, ... }:
with lib;
let cfg = config.link.python;
in {
  options.link.python.enable = mkEnableOption "enable python using texlive";
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      python311
      (python311.withPackages (ps:
        with ps; [
          pandas
          seaborn
          numpy
          jupyter
          jupyter-client
          jupyterlab
        ]))

    ];
    programs.vscode.extensions = with pkgs.vscode-extensions;
      [ ms-python.python ms-toolsai.jupyter
 ];
  };

}
