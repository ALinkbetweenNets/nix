{ lib, pkgs, config, ... }:
with lib;
let cfg = config.link.beancount;
in {
  options.link.beancount.enable = mkEnableOption "activate beancount toolchain";
  config = mkIf cfg.enable {
    home.packages = with pkgs;
      [
        beancount # bookkeeping
      ];
    programs.vscode.profiles.default.extensions =
      pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "beancount";
          publisher = "lencerf";
          version = "0.10.0";
          sha256 = "sha256-xsGYr9Aqfoe16U9lACyGkTfknwMf0n2oOog498SS26Y=";
        }
        {
          name = "vscode-beancount-formatter";
          publisher = "dongfg";
          version = "1.4.2";
          sha256 = "sha256-LLytNvXxcoDvTKiTuQWVPV8niPM8Bvi3R+zO1lxUM0U=";
        }
      ];
  };
}
