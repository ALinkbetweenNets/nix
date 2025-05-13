{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.services.mailserver;
in {
  # imports = [
  #   (builtins.fetchTarball {
  #     # Pick a release version you are interested in and set its hash, e.g.
  #     url =
  #       "https://gitlab.com/simple-nixos-mailserver/nixos-mailserver/-/archive/nixos-24.05/nixos-mailserver-nixos-24.05.tar.gz";
  #     # To get the sha256 of the nixos-mailserver tarball, we can use the nix-prefetch-url command:
  #     # release="nixos-23.05"; nix-prefetch-url "https://gitlab.com/simple-nixos-mailserver/nixos-mailserver/-/archive/${release}/nixos-mailserver-${release}.tar.gz" --unpack
  #     sha256 = "0clvw4622mqzk1aqw1qn6shl9pai097q62mq1ibzscnjayhp278b";
  #   })
  # ];
  options.link.services.mailserver = {
    #   enable = mkEnableOption "activate mailserver";
    #   expose-port = mkOption {
    #     type = types.bool;
    #     default = config.link.service-ports-expose;
    #     description = "directly expose the port of the application";
    #   };
    #   nginx = mkOption {
    #     type = types.bool;
    #     default = config.link.nginx.enable;
    #     description =
    #       "expose the application to the internet with NGINX and ACME";
    #   };
    #   nginx-expose = mkOption {
    #     type = types.bool;
    #     default = config.link.nginx-expose;
    #     description = "expose the application to the internet";
    #   };
    #   port = mkOption {
    #     type = types.int;
    #     default = 4500;
    #     description = "port to run the application on";
    #   };
    # };
    # config = mkIf cfg.enable {
    #   sops.secrets = { "mailserver/alinkbetweennets" = { }; };

    #   mailserver = {
    #     enable = true;
    #     fqdn = "mail.${config.link.domain}";
    #     domains = [ config.link.domain ];

    #     # A list of all login accounts. To create the password hashes, use
    #     # nix-shell -p mkpasswd --run 'mkpasswd -sm bcrypt'
    #     loginAccounts = {
    #       "ALinkBetweenNets@${config.link.domain}" = {
    #         hashedPasswordFile =
    #           config.sops.secrets."mailserver/alinkbetweennets".path;
    #         aliases = [ "Link@${config.link.domain}" ];
    #       };
    #     };

    #     # Use Let's Encrypt certificates. Note that this needs to set up a stripped
    #     # down nginx and opens port 80.
    #     # certificateScheme = "acme-nginx";
    #   };
    #   networking.firewall.interfaces."${config.link.service-interface}".allowedTCPPorts =
    #     mkIf cfg.expose-port [ cfg.port ];
    #   systemd.services.gitlab-backup.environment.BACKUP = "dump";
  };
}
