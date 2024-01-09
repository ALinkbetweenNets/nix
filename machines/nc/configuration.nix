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
  };
  services.nginx.virtualHosts = {
    "${config.link.domain}" = {
      enableACME = true;
      forceSSL = true;
      default = true;
      locations."/" = {
        return = "301 https://www.youtube.com/watch?v=dQw4w9WgXcQ";
      };
    };

    ## CTF

    "slides.netintro.${config.link.domain}" = {
      enableACME = true;
      forceSSL = true;
      # default = true;
      locations."/" = {
        proxyPass = "http://192.168.122.30:31337/";
      };
    };
    "vpnconfig.netintro.${config.link.domain}" = {
      enableACME = true;
      forceSSL = true;
      # default = true;
      locations."/" = {
        proxyPass = "http://192.168.122.30:31338/";
      };
    };
    "chal0.internal.netintro.${config.link.domain}" = {
      enableACME = true;
      forceSSL = true;
      # default = true;
      locations."/" = {
        proxyPass = "http://192.168.122.30:33159/";
      };
    };
    "chal1.internal.netintro.${config.link.domain}" = {
      enableACME = true;
      forceSSL = true;
      # default = true;
      locations."/" = {
        proxyPass = "http://192.168.122.30:33160/";
      };
    };
    "chal2b.internal.netintro.${config.link.domain}" = {
      enableACME = true;
      forceSSL = true;
      # default = true;
      locations."/" = {
        proxyPass = "http://192.168.122.30:33161/";
      };
    };
    "chal2c.internal.netintro.${config.link.domain}" = {
      enableACME = true;
      forceSSL = true;
      # default = true;
      locations."/" = {
        proxyPass = "http://192.168.122.30:33162/";
      };
    };
    "chal2.internal.netintro.${config.link.domain}" = {
      enableACME = true;
      forceSSL = true;
      # default = true;
      locations."/" = {
        proxyPass = "http://192.168.122.30:33163/";
      };
    };

    ## /CTF

    "gitea.${config.link.domain}" = {
      enableACME = true;
      forceSSL = true;
      locations = { "/" = { proxyPass = "http://${config.link.serviceHost}:${toString config.services.gitea.settings.server.HTTP_PORT}"; }; };
    };
    "speedtest.${config.link.domain}" = {
      enableACME = true;
      forceSSL = true;
      locations = { "/" = { proxyPass = "http://${config.link.serviceHost}:8766"; }; };
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
    };
  };

  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "server";
    extraUpFlags = [ "--advertise-exit-node" ];
  };
  # services.openssh.settings.PermitRootLogin = lib.mkForce "prohibit-password";
  # security.sudo.wheelNeedsPassword = true;
  lollypops.deployment = {
    local-evaluation = true;
    ssh = { host = "100.86.79.82"; user = "root"; };
  };
  networking = {
    firewall.allowedTCPPorts = [ 443 ];
    hostName = "v2202312204123249185";
    domain = "ultrasrv.de";
    interfaces."ens3" = {
      ipv6.addresses = [{
        address = "2a03:4000:54:8a:585a:48ff:fee3:9d06";
        prefixLength = 64;
      }];
    };
    nat.externalInterface = "ens3";
    # firewall = { allowedTCPPorts = [ 80 443 ]; };
  };
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
