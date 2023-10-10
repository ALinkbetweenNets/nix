{ lib, pkgs, config, ... }:
with lib;
let cfg = config.link.options;
in {

  options.link.options = {

    CISkip = mkOption {
      type = types.bool;
      default = false;
      example = true;
      description = "Wheter this host should be skipped by the CI pipeline";
    };

    type = mkOption {
      type = types.enum [ "desktop" "laptop" "server" ];
      default = "desktop";
      example = "server";
    };

  };

}
