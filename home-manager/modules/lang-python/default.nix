{ lib, pkgs, config, ... }:
with lib;
let cfg = config.link.python;
in {
  options.link.python.enable = mkEnableOption "enable python using texlive";
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      #python311
      (python311.withPackages (ps:
        with ps; [
          pandas
          seaborn
          matplotlib
          plotly
          cufflinks
          black
          rpy2 # python <-> R
          # scikit-learn-extra
          scikit-learn
          tensorflow # broken
          scipy
          numpy
          # plotnine
          jupyter
          jupyter-client
          jupyterlab
        ]))
    ];
    programs.vscode.extensions = with pkgs.vscode-extensions;
      [
        ms-python.python
        ms-toolsai.jupyter
        ms-pyright.pyright
      ];
  };
}
