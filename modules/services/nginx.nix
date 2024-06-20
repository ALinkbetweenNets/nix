{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.nginx;
in {
  options.link.nginx.enable = mkEnableOption "activate nginx";
  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [
      # 25
      80
      # 143
      443
      # 993
      # 111
      # 2049
      # 4000
      # 4001
      # 4002
    ];
    # networking.firewall.allowedUDPPorts = [ 111 2049 4000 4001 4002 20048 ]; # nfs
    services.nginx = {
      enable = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      logError = "stderr debug";
      package = pkgs.nginxStable.override { openssl = pkgs.libressl; };
      clientMaxBodySize = "1000m";
      commonHttpConfig = ''
        # Add HSTS header with preloading to HTTPS requests.
        # Adding this header to HTTP requests is discouraged
          server_names_hash_bucket_size 128;
          proxy_headers_hash_max_size 1024;
          proxy_headers_hash_bucket_size 256;
        map $scheme $hsts_header {
            https   "max-age=31536000; includeSubdomains; preload";
        }
        add_header Strict-Transport-Security $hsts_header;
      '';
      # sslCiphers = "AES256+EECDH:AES256+EDH:!aNULL";
      #   commonHttpConfig = ''
      #     # Add HSTS header with preloading to HTTPS requests.
      #     # Adding this header to HTTP requests is discouraged
      #     map $scheme $hsts_header {
      #         https   "max-age=31536000; includeSubdomains; preload";
      #     }
      #     add_header Strict-Transport-Security $hsts_header;
      #     # Enable CSP for your services.
      #     #add_header Content-Security-Policy "script-src 'self'; object-src 'none'; base-uri 'none';" always;
      #     # Minimize information leaked to other domains
      #     add_header 'Referrer-Policy' 'origin-when-cross-origin';
      #     # Disable embedding as a frame
      #     add_header X-Frame-Options DENY;
      #     # Prevent injection of code in other mime types (XSS Attacks)
      #     add_header X-Content-Type-Options nosniff;
      #     # This might create errors
      #     #proxy_cookie_path / "/; secure; HttpOnly; SameSite=strict";
      #   '';
    };
    security.acme = {
      acceptTerms = true;
      defaults.email = "link2502+acme@proton.me";
      certs."${config.link.domain}" = {
        domain = config.link.domain;
        extraDomainNames = [ "*.${config.link.domain}" ];
        dnsProvider = mkIf config.link.dyndns.enable "cloudflare";
        environmentFile = mkIf config.link.dyndns.enable config.sops.secrets."cloudflare-api".path;
        webroot=null;
      };
    };
  };
}
