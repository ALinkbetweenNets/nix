{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.nginx;
in {
  options.link.nginx.enable = mkEnableOption "activate nginx";
  config = mkIf cfg.enable {
    services.
    nginx = {
      enable = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      logError = "stderr debug";
      package = pkgs.nginxStable.override { openssl = pkgs.libressl; };
      clientMaxBodySize = "1000m";
    };
    security.acme = {
      acceptTerms = true;
      defaults.email = "link2502+acme@proton.me";
      # certs."ur6qwb3amjjhe15h.myfritz.net" = {
      #   dnsProvider = "inwx";
      #   # Suplying password files like this will make your credentials world-readable
      #   # in the Nix store. This is for demonstration purpose only, do not use this in production.
      #   credentialsFile = "${pkgs.writeText "inwx-creds" ''
      #     INWX_USERNAME=xxxxxxxxxx
      #     INWX_PASSWORD=yyyyyyyyyy
      #   ''}";
      # };
    };
  };
}
