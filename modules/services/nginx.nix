{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.nginx;
in {
  options.link.nginx.enable = mkEnableOption "activate nginx";
  config = mkIf cfg.enable {
    networking.firewall.allowedUDPPorts = [ 80 443 ];
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
    sops.secrets."cloudflare-api" = { };
    security.acme = {
      acceptTerms = true;
      defaults.email = "link2502+acme@proton.me";
      defaults.webroot = "/var/lib/acme/acme-challenge";
      certs."${config.link.domain}" = {
        domain = config.link.domain;
        extraDomainNames = [ "*.${config.link.domain}" ];
        dnsProvider = "cloudflare";
        environmentFile = config.sops.secrets."cloudflare-api".path;
        webroot = null;
      };
    };
    services.nginx = {
      enable = true;
      recommendedZstdSettings = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      logError = "stderr debug";
      enableQuicBPF = true;
      package = pkgs.nginxQuic.override { openssl = pkgs.libressl; };
      clientMaxBodySize = "2000m";
      commonHttpConfig = ''
        # sslCiphers = "AES256+EECDH:AES256+EDH:!aNULL";
        # ssl_protocols TLSv1.3;
        # ssl_conf_command Options KTLS; # not supported on nc
        # ssl_prefer_server_ciphers on; # disabled as only secure ciphers enabled. Clients may choose the most performant cipher for them from our whitelist
        log_format myformat '$remote_addr - $remote_user [$time_local] '
          '"$request" $status $body_bytes_sent '
          '"$http_referer" "$http_user_agent"';
        # Add HSTS header with preloading to HTTPS requests.
        # Adding this header to HTTP requests is discouraged
        index index.php index.html /index.php$request_uri;
        server_names_hash_bucket_size 128;
        proxy_headers_hash_max_size 1024;
        proxy_headers_hash_bucket_size 256;
        map $scheme $hsts_header {
          https   "max-age=31536000; includeSubdomains; preload";
        }
        add_header Strict-Transport-Security $hsts_header;
        # ssl_stapling_verify on;
        add_header Content-Security-Policy "default-src 'self' 'unsafe-inline' 'unsafe-eval' resource: data: blob: https://*.${config.link.domain} ws://*.${config.link.domain} https://tiles.immich.cloud https://static.immich.cloud https://api-l.cofractal.com https://maputnik.github.io https://fonts.openmaptiles.org https://fonts.googleapis.com ; script-src default-src 'self' 'unsafe-inline' 'unsafe-eval' resource: data: blob: https://*.${config.link.domain} ws://*.${config.link.domain} ;script-src-elem default-src 'self' 'unsafe-inline' 'unsafe-eval' resource: data: blob: https://*.${config.link.domain} ws://*.${config.link.domain} ; font-src https://fonts.openmaptiles.org https://fonts.googleapis.com https://fonts.gstatic.com 'self' 'unsafe-inline' 'unsafe-eval' data: blob:  ; img-src 'self' 'unsafe-inline' 'unsafe-eval' data: blob: https://videos.owncast.online https://www.gravatar.com https://logo.clearbit.com https://*.${config.link.domain} ws://*.${config.link.domain} ; frame-src 'self' 'unsafe-inline' https://*.${config.link.domain} ws://*.${config.link.domain} https://www.youtube.com https://youtube.com https://www.youtu.be ; media-src 'self' 'unsafe-inline' 'unsafe-eval' data: blob: https://assets.owncast.tv https://videos.owncast.online https://www.gravatar.com https://logo.clearbit.com https://*.${config.link.domain} ws://*.${config.link.domain} ; base-uri 'self' *.${config.link.domain} ${config.link.domain};" always;
        # no-referrer
        add_header Referrer-Policy strict-origin;
        add_header X-Frame-Options sameorigin;
        # Prevent injection of code in other mime types (XSS Attacks)
        add_header X-Content-Type-Options nosniff;
        # This might create errors - doc
        # Yep it destroyed the immich login - me
        #proxy_cookie_path / "/; secure; HttpOnly; SameSite=strict";
        add_header X-Real-IP $remote_addr;
        add_header X-Forwarded-For $proxy_add_x_forwarded_for;
        add_header X-Forwarded-Proto https;
        add_header X-Forwarded-Ssl on;
        add_header X-Forwarded-Port $server_port;
        add_header X-Forwarded-Host $host;
        add_header Host $http_host;
        add_header origin $http_origin;
        add_header X-XSRF-TOKEN $http_x_xsrf_token;
        # proxy_connect_timeout 300;
        # Default is HTTP/1, keepalive is only enabled in HTTP/1.1
        #proxy_http_version 1.1;
        add_header Connection "";
        # chunked_transfer_encoding off;
        # To allow special characters in headers
        ignore_invalid_headers off;
        # Allow any size file to be uploaded.
        # Set to a value such as 1000m; to restrict file size to a specific value
        # client_max_body_size 2048M;
        # To disable buffering
        proxy_buffering off;
        add_header X-XSS-Protection "1; mode=block";
        add_header X-Robots-Tag "noindex, nofollow";
        # add_header X-Download-Options noopen;
        add_header X-Permitted-Cross-Domain-Policies none;
        # add_header Strict-Transport-Security "max-age=15552000; includeSubDomains" always;
        fastcgi_buffers 64 4K;
        fastcgi_hide_header X-Powered-By;
        # gzip_proxied expired no-cache no-store private no_last_modified no_etag auth;
        # gzip_types application/atom+xml application/javascript application/json application/ld+json application/manifest+json application/rss+xml application/vnd.geo+json application/vnd.ms-fontobject application/x-font-ttf application/x-web-app-manifest+json application/xhtml+xml application/xml font/opentype image/bmp image/svg+xml image/x-icon text/cache-manifest text/css text/plain text/vcard text/vnd.rim.location.xloc text/vtt text/x-component text/x-cross-domain-policy;
      '';
    };
  };
}
