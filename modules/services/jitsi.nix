{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.services.jitsi;
in {
  options.link.services.jitsi = {
    enable = mkEnableOption "activate jitsi";
    expose = mkOption {
      type = types.bool;
      default = config.link.nginx-expose;
      description = "expose jitsi to the internet with NGINX and ACME";
    };
  };
  # it appears jitsi-meet cannot run without nginx
  config = mkIf cfg.enable {
    services = {
      jitsi-meet = {
        enable = true;
        hostName = "jitsi.${config.link.domain}";
        nginx.enable = true;
        interfaceConfig = {
          SHOW_JITSI_WATERMARK = false;
          SHOW_WATERMARK_FOR_GUESTS = false;
        };
        config = {
          authdomain =
            mkIf config.link.nginx.enable "jitsi.${config.link.domain}";
          enableInsecureRoomNameWarning = true;
          fileRecordingsEnabled = false;
          liveStreamingEnabled = false;
          prejoinPageEnabled = true;
        };
        videobridge.enable = true;
        prosody.enable = true;
        jicofo.enable = true;
        jibri.enable = true;
      };
      jitsi-videobridge = {
        enable = true;
        openFirewall = true;
      };
      jicofo = {
        enable = true;
        config = {
          "org.jitsi.jicofo.auth.URL" = "XMPP:jitsi.${config.link.domain}";
        };
      };
      nginx.virtualHosts = {
        "jitsi.${config.link.domain}" = {
          enableACME = cfg.expose;
          forceSSL = cfg.expose;
        };
      };
    };
  };
}
