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
          settings.server_name = config.link.domain;
          settings.public_baseurl = config.link.domain;
          settings.listeners = [
            {
              port = 8008;
              bind_addresses = [ "127.0.0.1" ];
              type = "http";
              tls = false;
              x_forwarded = true;
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
        nginx.virtualHosts."matrix.${config.link.domain}" = {
          enableACME = true;
          forceSSL = true;
          locations."/" = { proxyPass = "http://127.0.0.1:8008"; };
        };
      };
    };
}
