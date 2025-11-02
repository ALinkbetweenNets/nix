{ lib, pkgs, config, flake-self,... }:
with lib;
let cfg = config.link.xrlinux;
in {
  options.link.xrlinux = {
    enable = mkEnableOption "activate xrlinux";
    package = mkOption {
      type = types.package;
      default = flake-self.packages."x86_64-linux".xrlinuxdriver.xrlinuxdriver;
      description = "The xrlinuxdriver package to use.";
    };
    autoStart = mkEnableOption "automatically start the xr driver on login";
  };
  config = mkIf cfg.enable {
    services.udev.packages = [ cfg.package ];
    boot.kernelModules = [ "uinput" ];
    environment.systemPackages = [ cfg.package flake-self.packages."x86_64-linux".xrlinuxdriver.breezy-desktop-kwin pkgs.libevdev];
    systemd.user.services.xr-driver = {
      description = "XR user-space driver";
      after = [ "network.target" ];
      wantedBy = [ "default.target" ];
      serviceConfig = {
        Type = "simple";
        Environment = "LD_LIBRARY_PATH=${pkgs.libevdev}/lib";
        ExecStart = "${cfg.package}/bin/xrDriver";
        Restart = "always";
      };
    };
  };
}
