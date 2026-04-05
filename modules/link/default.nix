{
  lib,
  pkgs,
  config,
  nixpkgs,
  flake-self,
  home-manager,
  ...
}:
with lib;
{
  options.link = {
    domain = mkOption {
      type = types.str;
      default = "";
      description = "Main Domain name for all services";
    };
    expose-lan = mkOption {
      type = types.bool;
      default = false;
      description = "expose the port of applications to the local network (link.eth) by default";
    };
    eth = mkOption {
      type = types.str;
      default = "eth0";
      description = "Main ethernet interface";
    };

    expose-ts = mkOption {
      type = types.bool;
      default = false;
      description = "expose the port of applications to the ts network by default";
    };
    expose-nginx-public = mkOption {
      type = types.bool;
      default = false;
      description = "expose the port of applications to the internet with NGINX+ACME by default";
    };
    serviceHost = mkOption {
      type = types.str;
      default = "127.0.0.1";
      description = "IP address on which services are exposed";
    };
    tailscale-address = mkOption {
      type = types.str;
      default = "";
      description = "Tailscale address of host";
    };

    nginx-expose = mkOption {
      type = types.bool;
      default = config.link.domain != "";
      description = "if domain is empty services will be made available locally with self-signed certificates";
    };
    sops = mkOption {
      type = types.bool;
      default = false;
      description = "Wether the host has sops access";
    };
    service-ip = mkOption {
      type = types.str;
      default = "0.0.0.0";
      description = "Bind Services to this IP";
    };
    service-interface = mkOption {
      type = types.str;
      default = config.link.eth;
      description = "Main service interface";
    };
    service-ports-expose = mkOption {
      type = types.bool;
      default = config.link.domain != "";
      description = "if domain is empty services will be made available locally with self-signed certificates";
    };
    allowed = mkOption {
      type = types.listOf types.str;
      default = [ "0.0.0.0" ];
      description = "IPs allowed to access services";
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
      default = if config.link.server.enable then config.link.storage + "/syncthing/" else "/home/l";
      description = "storage path for syncthing";
    };
    containerDir = mkOption {
      type = types.str;
      default = "/home/l/.container";
      description = "storage path for containers";
    };
  };
}
