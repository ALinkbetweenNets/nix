{ lib, pkgs, config, system-config, ... }:
with lib;
let cfg = config.link.python;
in {
  options.link.python.enable = mkEnableOption "enable python using texlive";
  config = mkIf cfg.enable {
    home.packages = with pkgs;
      [
        #python311
        (python311.withPackages (ps:
          with ps; [
            django
            asgiref
            qrcode
            sqlparse
            typing-extensions
            pillow
            psycopg2
            pandas
            # seaborn
            # matplotlib
            # plotly
            # cufflinks
            # black
            # rpy2 # python <-> R
            # # scikit-learn-extra
            # scikit-learn
            # tensorflow # broken
            # scipy
            # numpy
            # plotnine
            # jupyter
            # jupyter-client
            # jupyterlab
          ]))
      ];
    programs.vscode.profiles.default.extensions = with pkgs.vscode-extensions;
      [ ms-toolsai.jupyter ms-pyright.pyright ] ++ lib.optionals
      (system-config.nixpkgs.hostPlatform.system == "x86_64-linux") [
        #  ms-python.python # broken
      ];
  };
}
