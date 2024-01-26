# 202.61.251.70
#	2a03:4000:54:8a::/64
# nix run github:numtide/nixos-anywhere -- --flake .#nc root@202.61.251.70
# TODO: remove hardware stuff from config module!
# -> bootloader
# -> energy stuff
# -> etc.
# Then everything should work.
# Those things always should be opt in!
{ self, ... }:
{ pkgs, lib, config, flake-self, home-manager, ... }: {
  imports = [
    ./netcup.nix
    home-manager.nixosModules.home-manager
  ];
  home-manager.users.l = flake-self.homeConfigurations.server;
  # home-manager.users.root = flake-self.homeConfigurations.server;
  link = {
    common.enable = true;
    eth = "ens3";
    dyndns.enable = true;
    domain = "alinkbetweennets.de";
    # fail2ban.enable = true;
    # coturn.enable = true;
    nginx.enable = true;
    serviceHost = "100.89.178.137";
    server.enable = true;
  };

  # ctf vpn forwarding
  networking.nat = {
    enable = true;
    externalInterface = "ens3";
    externalIP = "202.61.251.70";
    internalInterfaces = [ "tailscale0" ];
    internalIPs = [ "100.89.40.41/32" ];
    forwardPorts = [
      { sourcePort = 51820; proto = "udp"; destination = "100.89.40.41:51820"; loopbackIPs = [ "100.86.79.82" ]; }
    ];
  };

  networking = {
    firewall.allowedTCPPorts = [ 443 ];
    firewall.allowedUDPPorts = [ 51820 ];
    hostName = "v2202312204123249185";
    domain = "ultrasrv.de";
    interfaces."ens3" = {
      ipv6.addresses = [{
        address = "2a03:4000:54:8a:585a:48ff:fee3:9d06";
        prefixLength = 64;
      }];
    };
  };


  services.nginx.virtualHosts."${config.link.domain}" = {
    enableACME = true;
    forceSSL = true;
    default = true;
    locations."/" = {
      return = "301 https://www.youtube.com/watch?v=dQw4w9WgXcQ";
    };
  };
  # services.nginx.virtualHosts."grist.${config.link.domain}" = {
  #   enableACME = true;
  #   forceSSL = true;
  #   locations."/" = {
  #     proxyPass = "http://127.0.0.1:8484";
  #     proxyWebsockets = true;
  #   };
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
  services.nginx.virtualHosts."gitea.${config.link.domain}" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://${config.link.serviceHost}:${toString config.services.gitea.settings.server.HTTP_PORT}";
    };
  };
  services.nginx.virtualHosts."grafana.${config.link.domain}" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://${config.link.serviceHost
            }:${toString config.link.services.grafana.port}/";
      proxyWebsockets = true;
    };
  };
  services.nginx.virtualHosts."hedgedoc.${config.link.domain}" = {
    enableACME = true;
    forceSSL = true;

    locations."/".proxyPass = "http://${config.link.serviceHost}:${toString config.link.services.hedgedoc.port}";

  };
  services.nginx.virtualHosts."jellyfin.${config.link.domain}" = {
    enableACME = true;
    forceSSL = true;
    locations."/".proxyPass = "http://${config.link.serviceHost}:8096/";
  };
  services.nginx.virtualHosts."jellyseer.${config.link.domain}" = {
    enableACME = true;
    forceSSL = true;
    locations."/".proxyPass = "http://${config.link.serviceHost}:5055/";
  };
  services.  nginx.virtualHosts."minio.s3.${config.link.domain}" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://${config.link.serviceHost}:9001";
      proxyWebsockets = true;
      extraConfig = ''
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        # proxy_set_header Host $host;
        proxy_connect_timeout 300;
        # Default is HTTP/1, keepalive is only enabled in HTTP/1.1
        #proxy_http_version 1.1;
        proxy_set_header Connection "";
        chunked_transfer_encoding off;
      '';
    };
    extraConfig = ''
      # To allow special characters in headers
      ignore_invalid_headers off;
      # Allow any size file to be uploaded.
      # Set to a value such as 1000m; to restrict file size to a specific value
      client_max_body_size 0;
      # To disable buffering
      proxy_buffering off;
    '';
  };
  services.nginx.virtualHosts."s3.${config.link.domain}" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://${config.link.serviceHost}:9000";
      extraConfig = ''
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        # proxy_set_header Host $host;
        proxy_connect_timeout 300;
        # Default is HTTP/1, keepalive is only enabled in HTTP/1.1
        # proxy_http_version 1.1;
        proxy_set_header Connection "";
        chunked_transfer_encoding off;
      '';
      proxyWebsockets = true;
    };
    extraConfig = ''
      # To allow special characters in headers
      ignore_invalid_headers off;
      # Allow any size file to be uploaded.
      # Set to a value such as 1000m; to restrict file size to a specific value
      client_max_body_size 0;
      # To disable buffering
      proxy_buffering off;
    '';
  };
  services.nginx.virtualHosts."diagrams.${config.link.domain}" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://${config.link.serviceHost}:8765";
    };
    # extraConfig = mkIf (!cfg.expose) ''
    #   allow ${config.link.service-ip}/24;
    #     allow 127.0.0.1;
    #     deny all; # deny all remaining ips
    # '';
  };
  services.nginx.virtualHosts."nextcloud.${config.link.domain}" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://${config.link.serviceHost}:80";
    };
  };
  services.nginx.virtualHosts."outline.${config.link.domain}" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://${config.link.serviceHost}:${toString config.link.services.outline.port}";
      proxyWebsockets = true;
    };
  };
  services.nginx.virtualHosts."vaultwarden.${config.link.domain}" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://${config.link.serviceHost}:${toString config.link.services.vaultwarden.port}";
      proxyWebsockets = true;
    };
  };
  services.nginx.virtualHosts."photoprism.${config.link.domain}" = {
    enableACME = true;
    forceSSL = true;
    http2 = true;
    locations."/" = {
      proxyPass = "http://${config.link.serviceHost}:${toString config.link.services.photoprism.port}/";
      proxyWebsockets = true;
      # extraConfig = ''
      #   proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      #   proxy_set_header Host $host;
      #   proxy_buffering off;
      #   proxy_http_version 1.1;
      # '';
    };
  };
  # services.nginx.virtualHosts."paperless.${config.link.domain}" = {
  #   enableACME = true;
  #   forceSSL = true;
  #   locations."/" = {
  #     proxyPass = "http://${config.link.serviceHost}:${toString config.link.services.paperless.port}";
  #     proxyWebsockets = true;
  #   };
  # };

  ## CTF

  services.nginx.virtualHosts."slides.netintro.${config.link.domain}" = {
    enableACME = true;
    forceSSL = true;
    # default = true;
    locations."/" = {
      proxyPass = "http://100.89.40.41:31337/";
    };
  };
  services.nginx.virtualHosts."vpnconfig.netintro.${config.link.domain}" = {
    enableACME = true;
    forceSSL = true;
    # default = true;
    locations."/" = {
      proxyPass = "http://100.89.40.41:31338/";
    };
  };
  # services.nginx.virtualHosts."chal0.internal.netintro.${config.link.domain}" = {
  #   enableACME = true;
  #   # forceSSL = true;
  #   # default = true;
  #   locations."/" = {
  #     proxyPass = "http://100.89.40.41:32772/";
  #   };
  #   extraConfig = ''
  #     allow 127.0.0.1;
  #     allow 172.28.2.0/24;
  #     deny all; # deny all remaining ips
  #   '';
  # };
  # services.nginx.virtualHosts."chal1.internal.netintro.${config.link.domain}" = {
  #   enableACME = true;
  #   # forceSSL = true;
  #   # default = true;
  #   locations."/" = {
  #     proxyPass = "http://100.89.40.41:32770/";
  #   };
  #   extraConfig = ''
  #     allow 127.0.0.1;
  #     allow 172.28.2.0/24;
  #     deny all; # deny all remaining ips
  #   '';
  # };
  # services.nginx.virtualHosts."chal2.internal.netintro.${config.link.domain}" = {
  #   enableACME = true;
  #   # forceSSL = true;
  #   # default = true;
  #   locations."/" = {
  #     proxyPass = "http://100.89.40.41:32768/";
  #   };
  #   extraConfig = ''
  #     allow 127.0.0.1;
  #     allow 172.28.2.0/24;
  #     deny all; # deny all remaining ips
  #   '';
  # };
  # services.nginx.virtualHosts."chal2b.internal.netintro.${config.link.domain}" = {
  #   enableACME = true;
  #   # forceSSL = true;
  #   # default = true;
  #   locations."/" = {
  #     proxyPass = "http://100.89.40.41:32773/";
  #   };
  #   extraConfig = ''
  #     allow 127.0.0.1;
  #     allow 172.28.2.0/24;
  #     deny all; # deny all remaining ips
  #   '';
  # };
  # services.nginx.virtualHosts."chal2c.internal.netintro.${config.link.domain}" = {
  #   enableACME = true;
  #   # forceSSL = true;
  #   # default = true;
  #   locations."/" = {
  #     proxyPass = "http://100.89.40.41:32771/";
  #   };
  #   extraConfig = ''
  #     allow 127.0.0.1;
  #     allow 172.28.2.0/24;
  #     deny all; # deny all remaining ips
  #   '';
  # };
  ## /CTF
  # "speedtest.${config.link.domain}" = {
  #   enableACME = true;
  #   forceSSL = true;
  #   locations."/" = {
  #     proxyPass = "http://${config.link.serviceHost}:8766";
  #   };
  #locations."/" = {
  #  proxyPass = "http://127.0.0.1:80/";
  # extraConfig = ''
  #   proxy_set_header Front-End-Https on;
  #   proxy_set_header Strict-Transport-Security "max-age=2592000; includeSubdomains";
  #   proxy_set_header X-Real-IP $remote_addr;
  #   proxy_set_header Host $host;
  #   proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
  #   proxy_set_header X-Forwarded-Proto $scheme;
  # '';
  #};
  # services.openssh.settings.PermitRootLogin = lib.mkForce "prohibit-password";
  # security.sudo.wheelNeedsPassword = true;
  lollypops.deployment = {
    local-evaluation = true;
    ssh = { host = "100.86.79.82"; user = "root"; };
  };
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
