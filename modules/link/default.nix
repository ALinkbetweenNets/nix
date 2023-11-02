{ lib, pkgs, config, nixpkgs, flake-self, home-manager, ... }: with lib;
{
  options.link = {
    domain = mkOption {
      type = types.str;
      default = "alinkbetweennets.de";
      description = "Main Domain name for all services";
    };
    service-ip = mkOption {
      type = types.str;
      default = "0.0.0.0";
      description = "Bind Services to this IP";
    };
    eth = mkOption {
      type = types.str;
      default = "eth0";
      description = "Main ethernet interface";
    };
    storage = mkOption {
      type = types.str;
      default = "/var/lib";
      description = "storage path for all services";
    };
    secrets = mkOption {
      type = types.str;
      default = "/pwd";
      description = "storage path for all secrets";
    };
    syncthingDir = mkOption {
      type = types.str;
      default = "/home/l";
      description = "storage path for syncthing";
    };
    containerDir = mkOption {
      type = types.str;
      default = "/home/l/.container";
      description = "storage path for containers";
    };
  };
}
