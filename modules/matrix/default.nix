{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.services.matrix;
in {
  options.link.services.matrix = {
    enable = mkEnableOption "activate matrix";
    expose = mkOption {
      type = types.bool;
      default = config.link.expose;
      description = "expose matrix to the internet with NGINX and ACME";
    };
    nginx = mkOption {
      type = types.bool;
      default = config.link.nginx.enable;
      description = "Use service with NGINX";
    };
  };
  config = mkIf cfg.enable
    {
      environment.systemPackages = with pkgs; [ lottieconverter ];
      services = {
        matrix-synapse = with config.services.coturn;{
          enable = true;
          settings.public_baseurl = if cfg.nginx then "matrix.${config.link.domain}" else "http://${config.link.service-ip}:8008";
          settings.server_name = "matrix.${config.link.domain}";
          settings.listeners = [
            {
              port = 8008;
              bind_addresses = [ config.link.service-ip ];
              type = "http";
              tls = false;
              x_forwarded = cfg.nginx;
              resources = [
                {
                  compress = true;
                  names = [
                    "client"
                  ];
                }
                {
                  compress = false;
                  names = [
                    "federation"
                  ];
                }
              ];
            }
          ];
          extraConfigFiles = [ "/pwd/matrix-synapse-registration" ];
        };
        postgresql = {
          enable = true;
          initialScript = pkgs.writeText "synapse-init.sql" ''
            CREATE ROLE "matrix-synapse" WITH LOGIN PASSWORD 'synapse';
            CREATE DATABASE "matrix-synapse" WITH OWNER "matrix-synapse"
              TEMPLATE template0
              LC_COLLATE = "C"
              LC_CTYPE = "C";
          '';
        };
        nginx.virtualHosts."matrix.${config.link.domain}" = mkIf cfg.nginx {
          enableACME = true;
          forceSSL = true;
          locations."/" = { proxyPass = "http://127.0.0.1:8008"; };
          extraConfig = mkIf (!cfg.expose) ''
            allow ${config.link.service-ip}/24;
            deny all; # deny all remaining ips
          '';
        };
      };
      networking.firewall = {
        interfaces."${config.link.service-interface}" =
          let
            range = with config.services.coturn; [{
              from = min-port;
              to = max-port;
            }];
          in
          {
            allowedUDPPortRanges = range;
            allowedUDPPorts = [ 3478 5349 ];
            allowedTCPPortRanges = [ ];
            allowedTCPPorts = [ 3478 5349 8008 ];
          };
      };
    };
}
