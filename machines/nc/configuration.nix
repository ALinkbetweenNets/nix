# 202.61.251.70
#	2a03:4000:54:8a::/64
# nix run github:numtide/nixos-anywhere -- --flake .#nc root@202.61.251.70
{ self, ... }:{ pkgs, lib, config, flake-self, home-manager, ... }: {
  imports = [ ./netcup.nix home-manager.nixosModules.home-manager ];
  home-manager.users.l = flake-self.homeConfigurations.server;
  link = {
    wg-link-server.enable = true;
    sops = true;
    tailscale-address = "100.86.79.82";
    common.enable = true;
    eth = "ens3";
    domain = "alinkbetweennets.de";
    fail2ban.enable = true;
    nginx.enable = true;
    nginx.geoIP = true;
    serviceHost = "100.108.233.76";
    server.enable = true;
    vm.enable = true;
    # services.coturn.enable = true;
  };
  # ctf vpn forwarding
  networking.nat = {
    enable = true;
    externalInterface = "ens3";
    externalIP = "202.61.251.70";
    internalInterfaces = [ "tailscale0" ];
    internalIPs = [ "192.168.2.15/32" "100.87.16.37/32" ];
    forwardPorts = [
      {
        sourcePort = 25565;
        proto = "tcp";
        destination = "${config.link.serviceHost}:25565";
        loopbackIPs = [ "100.87.16.37" ];
      }
      {
        sourcePort = 51820;
        proto = "udp";
        destination = "192.168.2.15:51820";
        loopbackIPs = [ "100.87.16.37" ];
      }
      {
        sourcePort = 51822;
        proto = "udp";
        destination = "192.168.2.15:51820";
        loopbackIPs = [ "100.87.16.37" ];
      }
      {
        sourcePort = 41623;
        proto = "tcp";
        destination = "192.168.2.15:41623";
        loopbackIPs = [ "100.87.16.37" ];
      }
    ];
  };
  # networking.nat = {
  #   enable = true;
  #   externalInterface = "ens3";
  #   externalIP = "202.61.251.70";
  #   internalInterfaces = [ "tailscale0" ];
  #   internalIPs = [ "100.89.40.41/32" "100.89.178.137/32" ];
  #   forwardPorts = [
  #     { sourcePort = 443; proto = "tcp"; destination = "100.89.178.137:443"; loopbackIPs = [ "100.86.79.82" ]; }
  #   ];
  # };
  networking = {
    firewall.allowedTCPPorts = [ 22 41623 8920 8096 ];
    firewall.allowedUDPPorts = [ 51820 51822 ];
    hostName = "v2202312204123249185";
    domain = "ultrasrv.de";
    interfaces."ens3" = {
      ipv6.addresses = [{
        address = "2a03:4000:54:8a:585a:48ff:fee3:9d06";
        prefixLength = 64;
      }];
    };
  };
  services.nginx.virtualHosts = {
    # "grist.${config.link.domain}" = {
    #   useACMEHost = config.link.domain;
    #   forceSSL = true;
    #   locations."/" = {
    #     proxyPass = "http://${config.link.serviceHost}:8484";
    #     proxyWebsockets = true;
    #   };
    # };
    # services.nginx.virtualHosts."diagrams.${config.link.domain}" = {
    #   enableACME = true;
    #   forceSSL = true;
    #   locations."/" = {
    #     proxyPass = "http://127.0.0.1:8765";
    #     proxyWebsockets = true;
    #   };
    #   # extraConfig = mkIf (!cfg.expose) ''
    #   #   allow ${config.link.service-ip}/24;
    #   #     allow 127.0.0.1;
    #   #     deny all; # deny all remaining ips
    #   # '';
    # };
    # "matrix.${config.link.domain}" = {
    #   # enableACME = true;
    #   useACMEHost = config.link.domain;
    #   forceSSL = true;
    #   locations."/".proxyPass = "http://${config.link.serviceHost}:${
    #       toString config.link.services.matrix.port
    #     }";
    #   locations."/".proxyWebsockets = true;
    # };
    # "vikunja.${config.link.domain}" = {
    #   # enableACME = true;
    #   useACMEHost = config.link.domain;
    #   forceSSL = true;
    #   locations."/".proxyPass = "http://${config.link.serviceHost}:${
    #       toString config.link.services.vikunja.port
    #     }";
    #   locations."/".proxyWebsockets = true;
    # };
    # "gitea.${config.link.domain}" = {
    #   # enableACME = true;
    #   useACMEHost = config.link.domain;
    #   forceSSL = true;
    #   locations."/" = {
    #     proxyPass = "http://${config.link.serviceHost}:${
    #         toString config.services.gitea.settings.server.HTTP_PORT
    #       }";
    #     proxyWebsockets = true;
    #   };
    # };
    # "radicale.${config.link.domain}" = {
    #   # enableACME = true;
    #   useACMEHost = config.link.domain;
    #   forceSSL = true;
    #   locations."/" = {
    #     proxyPass = "http://${config.link.serviceHost}:${
    #         toString config.link.services.radicale.port
    #       }";
    #     proxyWebsockets = true;
    #   };
    # };
    # "keycloak.${config.link.domain}" = {
    #   # enableACME = true;
    #   useACMEHost = config.link.domain;
    #   forceSSL = true;
    #   locations."/" = {
    #     proxyPass =
    #       "http://100.98.35.19:${toString config.link.services.keycloak.port}";
    #     proxyWebsockets = true;
    #   };
    # };
    # "keycloak.alinkbn.de" = {
    #   # enableACME = true;
    #   useACMEHost = "alinkbn.de";
    #   forceSSL = true;
    #   locations."/" = {
    #     proxyPass =
    #       "http://100.98.35.19:${toString config.link.services.keycloak.port}";
    #     proxyWebsockets = true;
    #   };
    # };
    # "grafana.${config.link.domain}" = {
    #   # enableACME = true;
    #   useACMEHost = config.link.domain;
    #   forceSSL = true;
    #   locations."/" = {
    #     proxyPass =
    #       "http://100.98.35.19:${toString config.link.services.grafana.port}/";
    #     proxyWebsockets = true;
    #   };
    # };
    # "grafana.alinkbn.de" = {
    #   # enableACME = true;
    #   useACMEHost = "alinkbn.de";
    #   forceSSL = true;
    #   locations."/" = {
    #     proxyPass =
    #       "http://100.98.35.19:${toString config.link.services.grafana.port}/";
    #     proxyWebsockets = true;
    #   };
    # };
    # "gitlab.${config.link.domain}" = {
    #   # enableACME = true;
    #   useACMEHost = config.link.domain;
    #   forceSSL = true;
    #   locations."/" = {
    #     proxyPass = "http://${config.link.serviceHost}:80/";
    #     proxyWebsockets = true;
    #   };
    # };
    "audiobookshelf.${config.link.domain}" = {
      # enableACME = true;
      useACMEHost = config.link.domain;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://${config.link.serviceHost}:4124/";
        proxyWebsockets = true;
      };
    };
    "crypt.${config.link.domain}" = {
      # enableACME = true;
      useACMEHost = config.link.domain;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://${config.link.serviceHost}:5000/";
        # proxyWebsockets = true;
      };
      locations."/cryptpad_websocket" = {
        proxyPass = "http://${config.link.serviceHost}:5001/";
        proxyWebsockets = true;
      };
      extraConfig = ''
        add_header Strict-Transport-Security "max-age=31536000; includeSubDomains; preload" always;
        add_header X-Frame-Options sameorigin;
        add_header Content-Security-Policy "default-src 'none'; style-src 'unsafe-inline' 'self' https://crypt.alinkbetweennets.de;font-src 'self' data: https://crypt.alinkbetweennets.de; child-src https://crypt.alinkbetweennets.de; frame-src 'self' blob: https://cryptui.alinkbetweennets.de; script-src 'self' resource: https://crypt.alinkbetweennets.de; script-src-elem 'self' blob: 'unsafe-inline' resource: https://crypt.alinkbetweennets.de;img-src 'self' data: blob: https://crypt.alinkbetweennets.de; worker-src 'self';media-src blob: ; frame-ancestors 'self' https://crypt.alinkbetweennets.de;connect-src 'self' blob: https://crypt.alinkbetweennets.de https://cryptui.alinkbetweennets.de wss://crypt.alinkbetweennets.de;" always;
      '';
      #'sha256-ZswfTY7H35rbv8WC7NXBoiC7WNu86vSzCDChNWwZZDM=' 'sha256-Y1z0SyVx5S7ywM8HEuxVVkmBpqUjj6qZLBNBVk8E6h8=' 'sha256-h5wSYKWbmHcoYTdkHNNguMswVNCphpvwW+uxooXhF/Y=' 'sha256-rW/8eO/obXWbRoQlT2KlWVWmbqV+LGgiC1r8kKRsJhc=' 'sha256-OGjU0xQxuhdJDf8iMcgZXmRJZD2QZBQJRLwrFlOBLkI=' 'sha256-fWlVIwe2LsO09S7H48jPEdZpXqvWNASN9MJtP9UqorQ=' 'sha256-EzOdKxNif8wH7zIpBWq8C8s7ReXFFUgKIeh3S8mbzmg=' 'sha256-XqyszejV2KjHp1R/rjEZrlZr+jaJpoSSF34CliTkwsA=' 'sha256-550mecyv+58pd1gBLH1QBIOUYSFa6dRGnPr5EQydW1Y=' 'sha256-OEAthcFABIfn7TlCbTV6bGAv1qO5kVS02Tbru9uBM7E=' 'sha256-+ac8khtNoT0aNZRgSgtufqMcKat1zoMcy2QKOy1king=' 'sha256-Y1z0SyVx5S7ywM8HEuxVVkmBpqUjj6qZLBNBVk8E6h8=' 'sha256-ZswfTY7H35rbv8WC7NXBoiC7WNu86vSzCDChNWwZZDM=' 'sha256-R5+O+GguAMEaEziO1n5XU7JdxbmNH9PrD0455tGIo+Y=' 'sha256-R/9llE0s4++pxJWFqpVdB+eQJk2ANaxrUkOoEgbf4BE=' 'sha256-Y1z0SyVx5S7ywM8HEuxVVkmBpqUjj6qZLBNBVk8E6h8=' 'sha256-ZswfTY7H35rbv8WC7NXBoiC7WNu86vSzCDChNWwZZDM=' 'sha256-tq5fHKUNWCWMHbqZJgps3MZdMB//nQ7ZNRkFNo18098='
    };
    "cryptui.${config.link.domain}" = {
      # enableACME = true;
      useACMEHost = config.link.domain;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://${config.link.serviceHost}:5000/";
        proxyWebsockets = true;
      };
      extraConfig = ''
        add_header Strict-Transport-Security "max-age=31536000; includeSubDomains; preload" always;
        add_header X-Frame-Options sameorigin;
        add_header Content-Security-Policy "default-src 'none'; style-src 'unsafe-inline' 'self' https://crypt.alinkbetweennets.de;font-src 'self' data: https://crypt.alinkbetweennets.de; child-src https://crypt.alinkbetweennets.de; frame-src 'self' blob: https://cryptui.alinkbetweennets.de; script-src 'self' resource: https://crypt.alinkbetweennets.de 'unsafe-eval' 'unsafe-inline';script-src-elem 'self' 'unsafe-inline' resource: https://crypt.alinkbetweennets.de;img-src 'self' data: blob: https://crypt.alinkbetweennets.de; worker-src 'self';media-src blob: ; frame-ancestors 'self' https://crypt.alinkbetweennets.de;connect-src 'self' blob: https://crypt.alinkbetweennets.de https://cryptui.alinkbetweennets.de wss://crypt.alinkbetweennets.de;" always;

      '';
    };
    # "cast.${config.link.domain}" = {
    #   # enableACME = true;
    #   useACMEHost = config.link.domain;
    #   forceSSL = true;
    #   locations."/" = {
    #     proxyPass = "http://${config.link.serviceHost}:8888/";
    #     proxyWebsockets = true;
    #   };
    # };
    "cyyyyyber.${config.link.domain}" = {
      # enableACME = true;
      useACMEHost = config.link.domain;
      forceSSL = true;
      root = "${pkgs.cyberchef}/share/cyberchef";
      extraConfig = ''
        add_header X-Content-Type-Options nosniff;
        add_header X-XSS-Protection "1; mode=block";
        add_header X-Frame-Options sameorigin;
        add_header Content-Security-Policy "frame-ancestors 'self' resource: blob: https://*.alinkbetweennets.de ws://*.alinkbetweennets.de ; object-src 'none'; default-src 'self' 'unsafe-inline' 'unsafe-eval' resource: data: blob: https://*.alinkbetweennets.de ws://*.alinkbetweennets.de https://tiles.immich.cloud https://static.immich.cloud https://api-l.cofractal.com https://maputnik.github.io https://fonts.openmaptiles.org https://fonts.googleapis.com ; script-src 'self' resource: blob: https://*.alinkbetweennets.de ws://*.alinkbetweennets.de ; script-src-elem 'self' 'unsafe-inline' 'unsafe-eval' resource: blob: https://*.alinkbetweennets.de ws://*.alinkbetweennets.de ; font-src https://fonts.openmaptiles.org https://fonts.googleapis.com https://fonts.gstatic.com 'self' 'unsafe-inline' 'unsafe-eval' data: blob: ; img-src 'self' 'unsafe-inline' 'unsafe-eval' data: blob: https://videos.owncast.online https://www.gravatar.com https://logo.clearbit.com https://*.alinkbetweennets.de ws://*.alinkbetweennets.de ; frame-src 'self' 'unsafe-inline' https://*.alinkbetweennets.de ws://*.alinkbetweennets.de https://www.youtube.com https://youtube.com https://www.youtu.be ; media-src 'self' 'unsafe-inline' 'unsafe-eval' data: blob: https://assets.owncast.tv https://videos.owncast.online https://www.gravatar.com https://logo.clearbit.com https://*.alinkbetweennets.de ws://*.alinkbetweennets.de ; base-uri 'self' *.alinkbetweennets.de alinkbetweennets.de;" always;
      '';
    };
    "bettuna.${config.link.domain}" = {
      quic = true;
      http3_hq = true;
      # enableACME = true;
      useACMEHost = config.link.domain;
      forceSSL = true;
      root = "/var/www/bettuna";
    };
    "burp.${config.link.domain}" = {
      quic = true;
      http3_hq = true;
      # enableACME = true;
      serverAliases = [
        "burpsuite.${config.link.domain}"
        "webhacking.${config.link.domain}"
        "xn--w38h.${config.link.domain}"
      ];
      useACMEHost = config.link.domain;
      forceSSL = true;
      root = "/var/www/Vortrag-Burpsuite";
    };
    "lockpicking.${config.link.domain}" = {
      # enableACME = true;
      serverAliases = [
        "vortrag-lockpicking.${config.link.domain}"
        "xn--e18h.${config.link.domain}"
      ];
      useACMEHost = config.link.domain;
      forceSSL = true;
      root = "/var/www/Vortrag-Lockpicking";
    };
    # "hedgedoc.${config.link.domain}" = {
    #   # enableACME = true;
    #   useACMEHost = config.link.domain;
    #   forceSSL = true;
    #   locations."/" = {
    #     proxyPass = "http://${config.link.serviceHost}:${
    #         toString config.link.services.hedgedoc.port
    #       }";
    #     proxyWebsockets = true;
    #   };
    # };
    # "jellyfin.${config.link.domain}" = {
    #   # enableACME = true;
    #   useACMEHost = config.link.domain;
    #   forceSSL = true;
    #   listen = [
    #     {
    #       port = 443;
    #       addr = "0.0.0.0";
    #       ssl = true;
    #     }
    #     {
    #       port = 8096;
    #       addr = "0.0.0.0";
    #       ssl = true;
    #     }
    #     {
    #       port = 8920;
    #       addr = "0.0.0.0";
    #       ssl = true;
    #     }
    #   ];
    #   locations."/".proxyPass = "http://${config.link.serviceHost}:8096/";
    #   locations."/".proxyWebsockets = true;
    # };
    # "jellyfin1.${config.link.domain}" = {
    #   # enableACME = true;
    #   useACMEHost = config.link.domain;
    #   forceSSL = true;
    #   locations."/".proxyPass = "http://${config.link.serviceHost}:8096/";
    # };
    # "jellyfin2.${config.link.domain}" = {
    #   # enableACME = true;
    #   useACMEHost = config.link.domain;
    #   forceSSL = true;
    #   locations."/".proxyPass = "http://${config.link.serviceHost}:8920/";
    # };
    # "jellyseerr.${config.link.domain}" = {
    #   # enableACME = true;
    #   useACMEHost = config.link.domain;
    #   forceSSL = true;
    #   locations."/".proxyPass = "http://${config.link.serviceHost}:5055/";
    #   locations."/".proxyWebsockets = true;
    # };
    "restic.${config.link.domain}" = {
      # enableACME = true;
      useACMEHost = config.link.domain;
      forceSSL = true;
      locations."/".proxyPass = "http://${config.link.serviceHost}:2500/";
      locations."/".proxyWebsockets = true;
    };
    "microbin.${config.link.domain}" = {
      # enableACME = true;
      useACMEHost = config.link.domain;
      forceSSL = true;
      locations."/".proxyPass = "http://${config.link.serviceHost}:9483/";
    };
    "karsten.${config.link.domain}" = {
      # enableACME = true;
      useACMEHost = config.link.domain;
      forceSSL = true;
      locations."/".proxyPass = "http://100.98.48.88:5000/";
      locations."/".proxyWebsockets = true;
    };
    "kasten.${config.link.domain}" = {
      # enableACME = true;
      useACMEHost = config.link.domain;
      forceSSL = true;
      locations."/".proxyPass = "http://100.98.35.19:5000/";
      locations."/".proxyWebsockets = true;
    };
    "immich.${config.link.domain}" = {
      # enableACME = true;
      useACMEHost = config.link.domain;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://${config.link.serviceHost}:${
            toString config.link.services.immich.port
          }";
        proxyWebsockets = true;
      };
    };
    "minio.${config.link.domain}" = {
      # enableACME = true;
      useACMEHost = config.link.domain;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://${config.link.serviceHost}:9002";
        proxyWebsockets = true;
      };
    };
    "s3.${config.link.domain}" = {
      # enableACME = true;
      useACMEHost = config.link.domain;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://${config.link.serviceHost}:9001";
        # extraConfig = ''
        #   proxy_set_header X-Real-IP $remote_addr;
        #   proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        #   proxy_set_header X-Forwarded-Proto $scheme;
        #   # proxy_set_header Host $host;
        #   proxy_connect_timeout 300;
        #   # Default is HTTP/1, keepalive is only enabled in HTTP/1.1
        #   # proxy_http_version 1.1;
        #   proxy_set_header Connection "";
        #   chunked_transfer_encoding off;
        # '';
        proxyWebsockets = true;
      };
      # extraConfig = ''
      #   # To allow special characters in headers
      #   ignore_invalid_headers off;
      #   # Allow any size file to be uploaded.
      #   # Set to a value such as 1000m; to restrict file size to a specific value
      #   client_max_body_size 0;
      #   # To disable buffering
      #   proxy_buffering off;
      # '';
    };
    # "diagrams.${config.link.domain}" = {
    #   # enableACME = true;
    #   useACMEHost = config.link.domain;
    #   forceSSL = true;
    #   locations."/".proxyPass = "http://${config.link.serviceHost}:8765";
    # };
    "nextcloud.${config.link.domain}" = {
      # enableACME = true;
      useACMEHost = config.link.domain;
      forceSSL = true;
      locations."/".proxyPass = "http://${config.link.serviceHost}:80";
      extraConfig = "\n";
    };
    # "outline.${config.link.domain}" = {
    #   # enableACME = true;
    #   useACMEHost = config.link.domain;
    #   forceSSL = true;
    #   locations."/" = {
    #     proxyPass = "http://${config.link.serviceHost}:${
    #         toString config.link.services.outline.port
    #       }";
    #     proxyWebsockets = true;
    #   };
    # };
    # "vaultwarden.${config.link.domain}" = {
    #   # enableACME = true;
    #   useACMEHost = config.link.domain;
    #   forceSSL = true;
    #   locations."/" = {
    #     proxyPass = "http://${config.link.serviceHost}:${
    #         toString config.link.services.vaultwarden.port
    #       }";
    #     proxyWebsockets = true;
    #   };
    # };
    "kinky3d.de" = {
      enableACME = true;
      forceSSL = true;
      locations."/".proxyPass = "http://10.10.10.22:3214/";
    };
    "alinkbn.de" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://100.98.48.88:5000/";
        proxyWebsockets = true;
      };
      extraConfig = ''
        error_page 502 /error-page.html;
      '';
      locations."/error" = {
        return = "307 https://www.youtube.com/watch?v=dQw4w9WgXcQ";
      };
    };
    "shonk.de" = {
      forceSSL = true;
      enableACME = true;
      listen = [
        {
          port = 443;
          addr = "0.0.0.0";
          ssl = true;
        }
        {
          port = 8096;
          addr = "0.0.0.0";
          ssl = true;
        }
        {
          port = 8920;
          addr = "0.0.0.0";
          ssl = true;
        }
      ];
      locations."/" = {
        proxyPass = "http://${config.link.serviceHost}:8096/";
        proxyWebsockets = true;
      };
    };
    "${config.link.domain}" = {
      enableACME = true;
      # useACMEHost = config.link.domain;
      forceSSL = true;
      default = true;
      locations."/" = {
        return = "307 https://www.youtube.com/watch?v=dQw4w9WgXcQ";
      };
    };
    # services.nginx.virtualHosts."paperless.${config.link.domain}" = {
    #   enableACME = true;
    # useACMEHost = config.link.domain;
    #   forceSSL = true;
    #   locations."/" = {
    #     proxyPass = "http://${config.link.serviceHost}:${toString config.link.services.paperless.port}";
    #     proxyWebsockets = true;
    #   };
    # };

    # CTF
    "slides.netintro.${config.link.domain}" = {
      enableACME = true;
      # useACMEHost = config.link.domain;
      forceSSL = true;
      # default = true;
      locations."/" = { proxyPass = "http://192.168.2.15:31337/"; };
    };
    "vpnconfig.netintro.${config.link.domain}" = {
      enableACME = true;
      # useACMEHost = config.link.domain;
      forceSSL = true;
      # default = true;
      locations."/" = { proxyPass = "http://192.168.2.15:31338/"; };
    };
    # /CTF
  };
  # services.oauth2-proxy={
  #   enable=true;
  # };

  # "speedtest.${config.link.domain}" = {
  #   enableACME = true;
  # useACMEHost = config.link.domain;
  #   forceSSL = true;
  #   locations."/" = {
  #     proxyPass = "http://${config.link.serviceHost}:8766";
  #   };
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBu+WcpENdr7FaCIwj6WsinGnykIPV/tnIyrfEHSeU+E root@sn"
  ];
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
