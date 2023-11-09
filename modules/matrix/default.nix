{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.matrix;
in {
  options.link.matrix.enable = mkEnableOption "activate matrix";
  config = mkIf cfg.enable
    {
      services = {
        matrix-synapse = {
          enable = true;
          settings.server_name = "matrix.${config.link.domain}";
          settings.public_baseurl = "https://matrix.${config.link.domain}";
          settings.listeners = [
            {
              port = 8008;
              bind_addresses = [ "127.0.0.1" ];
              type = "http";
              tls = false;
              x_forwarded = config.link.nginx.enable;
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
        nginx.virtualHosts."matrix.${config.link.domain}" = mkIf config.link.nginx.enable {
          # enableACME = true;
          forceSSL = true;
          locations."/" = { proxyPass = "http://127.0.0.1:8008"; };
        };
      };
    };
}
