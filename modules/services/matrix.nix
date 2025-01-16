{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.services.matrix;
in {
  options.link.services.matrix = {
    enable = mkEnableOption "activate matrix";
    expose-port = mkOption {
      type = types.bool;
      default = config.link.service-ports-expose;
      description = "directly expose the port of the application";
    };
    nginx = mkOption {
      type = types.bool;
      default = config.link.nginx.enable;
      description =
        "expose the application to the internet with NGINX and ACME";
    };
    nginx-expose = mkOption {
      type = types.bool;
      default = config.link.nginx-expose;
      description = "expose the application to the internet";
    };
    port = mkOption {
      type = types.int;
      default = 8008;
      description = "port to run the application on";
    };
  };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ lottieconverter element-web ];
    services = {
      matrix-synapse = with config.services.coturn; {
        enable = true;
        # turn_shared_secret = static-auth-secret;
        settings = {
          turn_user_lifetime = "1h";
          turn_uris = [
            "turn:${realm}:3478?transport=udp"
            "turn:${realm}:3478?transport=tcp"
          ];
          public_baseurl = if cfg.nginx then
            "https://matrix.${config.link.domain}"
          else
            "http://${config.link.service-ip}:8008";
          server_name = "matrix.${config.link.domain}";
          listeners = [{
            port = cfg.port;
            bind_addresses =
              if cfg.expose-port then [ "0.0.0.0" ] else [ "127.0.0.1" ];
            type = "http";
            tls = false;
            x_forwarded = true;
            resources = [
              {
                compress = true;
                names = [ "client" ];
              }
              {
                compress = false;
                names = [ "federation" ];
              }
            ];
          }];
        };
        extraConfigFiles =
          [ config.sops.secrets."matrix-synapse-registration".path ];
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
        extraConfig = mkIf (!cfg.nginx-expose) ''
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
    networking.firewall.interfaces."${config.link.service-interface}".allowedTCPPorts =
      mkIf cfg.expose-port [ cfg.port ];
  };
}
