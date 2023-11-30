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
      environment.systemPackages = with pkgs; [ lottieconverter element-web ];
      services = {
        matrix-synapse = with config.services.coturn;{
          enable = true;
          settings = {
            public_baseurl = if cfg.nginx then "https://matrix.${config.link.domain}" else "http://${config.link.service-ip}:8008";
            server_name = "matrix.${config.link.domain}";
            listeners = [
              {
                port = 8008;
                bind_addresses = [ "127.0.0.1" ];
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
          };
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
            allow 127.0.0.1;
            deny all; # deny all remaining ips
          '';
        };
        # nginx.virtualHosts."element.${config.link.domain}" = {
        #   enableACME = true;
        #   forceSSL = true;
        #   root = pkgs.element-web.override {
        #     conf = {
        #       default_server_config = "https://element.${config.link.domain}";
        #     };
        #   };
        #   extraConfig = mkIf (!cfg.expose) ''
        #     allow ${config.link.service-ip}/24;
        #     allow 127.0.0.1;
        #     deny all; # deny all remaining ips
        #   '';
        # };
      };
    };
}
