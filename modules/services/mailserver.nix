{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.services.mailserver;
in {
  imports = [
    (builtins.fetchTarball {
      # Pick a release version you are interested in and set its hash, e.g.
      url = "https://gitlab.com/simple-nixos-mailserver/nixos-mailserver/-/archive/nixos-23.05/nixos-mailserver-nixos-23.05.tar.gz";
      # To get the sha256 of the nixos-mailserver tarball, we can use the nix-prefetch-url command:
      # release="nixos-23.05"; nix-prefetch-url "https://gitlab.com/simple-nixos-mailserver/nixos-mailserver/-/archive/${release}/nixos-mailserver-${release}.tar.gz" --unpack
      sha256 = "1ngil2shzkf61qxiqw11awyl81cr7ks2kv3r3k243zz7v2xakm5c";
    })
  ];
  options.link.services.mailserver = {
    enable = mkEnableOption "activate mailserver";
    expose-port = mkOption {
      type = types.bool;
      default = config.link.service-ports-expose;
      description = "directly expose the port of the application";
    };
    nginx = mkOption {
      type = types.bool;
      default = config.link.nginx.enable;
      description = "expose the application to the internet with NGINX and ACME";
    };
    nginx-expose = mkOption {
      type = types.bool;
      default = config.link.nginx-expose;
      description = "expose the application to the internet";
    };
    port = mkOption {
      type = types.int;
      default = 5000;
      description = "port to run the application on";
    };
  };
  config = mkIf cfg.enable {
    sops.secrets = {
      "mailserver/alinkbetweennets" = { owner = "gitlab"; group = "gitlab"; };
      "gitlab/dbPass" = { owner = "gitlab"; group = "gitlab"; };
      "gitlab/otp" = { owner = "gitlab"; group = "gitlab"; };
      "gitlab/initial-root" = { owner = "gitlab"; group = "gitlab"; };
      "gitlab/secret" = { owner = "gitlab"; group = "gitlab"; };
    };

    mailserver = {
      enable = true;
      fqdn = "mail.example.com";
      domains = [ "example.com" ];

      # A list of all login accounts. To create the password hashes, use
      # nix-shell -p mkpasswd --run 'mkpasswd -sm bcrypt'
      loginAccounts = {
        "user1@example.com" = {
          hashedPasswordFile = "/a/file/containing/a/hashed/password";
          aliases = [ "postmaster@example.com" ];
        };
        };

        # Use Let's Encrypt certificates. Note that this needs to set up a stripped
        # down nginx and opens port 80.
        certificateScheme = "acme-nginx";
        };
        networking.firewall.interfaces."${config.link.service-interface}".allowedTCPPorts = mkIf cfg.expose-port [ cfg.port ];
        systemd.services.gitlab-backup.environment.BACKUP = "dump";
        };
        }
