# 202.61.251.70
#	2a03:4000:54:8a::/64
# nix run github:numtide/nixos-anywhere -- --flake .#nc root@202.61.251.70
{ self, ... }:
{ pkgs, lib, config, flake-self, home-manager, ... }: {
  imports = [ ./netcup.nix home-manager.nixosModules.home-manager ];
  home-manager.users.l = flake-self.homeConfigurations.server;
  link = {
    sops = true;
    tailscale-address = "100.86.79.82";
    common.enable = true;
    eth = "ens3";
    domain = "alinkbetweennets.de";
    fail2ban.enable = true;
    nginx.enable = true;
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
    internalIPs = [ "10.10.10.63/32" "100.87.16.37/32" ];
    forwardPorts = [
      {
        sourcePort = 51820;
        proto = "udp";
        destination = "10.10.10.63:51820";
        loopbackIPs = [ "100.87.16.37" ];
      }
      {
        sourcePort = 51822;
        proto = "udp";
        destination = "10.10.10.63:51820";
        loopbackIPs = [ "100.87.16.37" ];
      }
      {
        sourcePort = 41623;
        proto = "tcp";
        destination = "10.10.10.63:41623";
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
    firewall.allowedTCPPorts = [ 443 22 41623 ];
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
    "matrix.${config.link.domain}" = {
      # enableACME = true;
      useACMEHost = config.link.domain;
      forceSSL = true;
      locations."/".proxyPass = "http://${config.link.serviceHost}:${
          toString config.link.services.matrix.port
        }";
      locations."/".proxyWebsockets = true;
    };
    "vikunja.${config.link.domain}" = {
      # enableACME = true;
      useACMEHost = config.link.domain;
      forceSSL = true;
      locations."/".proxyPass = "http://${config.link.serviceHost}:${
          toString config.link.services.vikunja.port
        }";
      locations."/".proxyWebsockets = true;
    };
    "gitea.${config.link.domain}" = {
      # enableACME = true;
      useACMEHost = config.link.domain;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://${config.link.serviceHost}:${
            toString config.services.gitea.settings.server.HTTP_PORT
          }";
        proxyWebsockets = true;
      };
    };
    "keycloak.${config.link.domain}" = {
      # enableACME = true;
      useACMEHost = config.link.domain;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://${config.link.serviceHost}:${
            toString config.link.services.keycloak.port
          }";
        proxyWebsockets = true;
      };
    };
    "grafana.${config.link.domain}" = {
      # enableACME = true;
      useACMEHost = config.link.domain;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://${config.link.serviceHost}:${
            toString config.link.services.grafana.port
          }/";
        proxyWebsockets = true;
      };
    };
    "gitlab.${config.link.domain}" = {
      # enableACME = true;
      useACMEHost = config.link.domain;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://${config.link.serviceHost}:80/";
        proxyWebsockets = true;
      };
    };
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
    };
    "cryptui.${config.link.domain}" = {
      # enableACME = true;
      useACMEHost = config.link.domain;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://${config.link.serviceHost}:5000/";
        proxyWebsockets = true;
      };
    };
    "cast.${config.link.domain}" = {
      # enableACME = true;
      useACMEHost = config.link.domain;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://${config.link.serviceHost}:8888/";
        proxyWebsockets = true;
      };
    };
    "cyyyyyber.${config.link.domain}" = {
      # enableACME = true;
      useACMEHost = config.link.domain;
      forceSSL = true;
      root = "${pkgs.cyberchef}/share/cyberchef";
    };
    "webhacking.${config.link.domain}" = {
      # enableACME = true;
      useACMEHost = config.link.domain;
      forceSSL = true;
      root = "/var/www/Burpsuite-Presentation";
    };
    "hedgedoc.${config.link.domain}" = {
      # enableACME = true;
      useACMEHost = config.link.domain;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://${config.link.serviceHost}:${
            toString config.link.services.hedgedoc.port
          }";
        proxyWebsockets = true;
      };
    };
    "jellyfin.${config.link.domain}" = {
      # enableACME = true;
      useACMEHost = config.link.domain;
      forceSSL = true;
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
      locations."/".proxyPass = "http://${config.link.serviceHost}:8096/";
      locations."/".proxyWebsockets = true;
    };
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
    "jellyseerr.${config.link.domain}" = {
      # enableACME = true;
      useACMEHost = config.link.domain;
      forceSSL = true;
      locations."/".proxyPass = "http://${config.link.serviceHost}:5055/";
      locations."/".proxyWebsockets = true;
    };
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
    # "minio.${config.link.domain}" = {
    #   # enableACME = true;
    #   useACMEHost = config.link.domain;
    #   forceSSL = true;
    #   locations."/" = {
    #     proxyPass = "http://${config.link.serviceHost}:9002";
    #     proxyWebsockets = true;
    #   };
    # };
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
    "diagrams.${config.link.domain}" = {
      # enableACME = true;
      useACMEHost = config.link.domain;
      forceSSL = true;
      locations."/".proxyPass = "http://${config.link.serviceHost}:8765";
    };
    "nextcloud.${config.link.domain}" = {
      # enableACME = true;
      useACMEHost = config.link.domain;
      forceSSL = true;
      locations."/".proxyPass = "http://${config.link.serviceHost}:80";
      extraConfig = "\n";
    };
    "outline.${config.link.domain}" = {
      # enableACME = true;
      useACMEHost = config.link.domain;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://${config.link.serviceHost}:${
            toString config.link.services.outline.port
          }";
        proxyWebsockets = true;
      };
    };
    "vaultwarden.${config.link.domain}" = {
      # enableACME = true;
      useACMEHost = config.link.domain;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://${config.link.serviceHost}:${
            toString config.link.services.vaultwarden.port
          }";
        proxyWebsockets = true;
      };
    };
    "photoprism.${config.link.domain}" = {
      # enableACME = true;
      useACMEHost = config.link.domain;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://${config.link.serviceHost}:${
            toString config.link.services.photoprism.port
          }/";
        proxyWebsockets = true;
        # extraConfig = ''
        #   proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        #   proxy_set_header Host $host;
        #   proxy_buffering off;
        #   proxy_http_version 1.1;
        # '';
      };
    };
    "kinky3d.de" = {
      enableACME = true;
      forceSSL = true;
      locations."/".proxyPass = "http://10.10.10.22:3214/";
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
        return = "301 https://www.youtube.com/watch?v=dQw4w9WgXcQ";
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
      locations."/" = { proxyPass = "http://10.10.10.45:31337/"; };
    };
    "vpnconfig.netintro.${config.link.domain}" = {
      enableACME = true;
      # useACMEHost = config.link.domain;
      forceSSL = true;
      # default = true;
      locations."/" = { proxyPass = "http://10.10.10.45:31338/"; };
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
  lollypops.deployment = {
    local-evaluation = true;
    ssh.host = "nc.monitor-banfish.ts.net";
    ssh.user = "l";
    ssh.opts = [ "-p 2522" ];
    sudo.enable = true;
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
