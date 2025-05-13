{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.services.prometheus;
in {
  options.link.services.prometheus = {
    enable = mkEnableOption "activate prometheus";
    expose-port = mkOption {
      type = types.bool;
      default = config.link.service-ports-expose;
      description = "directly expose the port of the application";
    };
    port = mkOption {
      type = types.int;
      default = 9005;
      description = "port to run the application on";
    };
  };
  config = mkIf cfg.enable {
    services = {
      prometheus = {
        enable = true;
        port = cfg.port;
        scrapeConfigs = [{
          job_name = "scraper";
          static_configs = [{
            targets = [
              "127.0.0.1:${
                toString config.services.prometheus.exporters.node.port
              }"
              "127.0.0.1:${
                toString config.services.prometheus.exporters.ping.port
              }"
              "127.0.0.1:${
                toString config.services.prometheus.exporters.domain.port
              }"
              # "127.0.0.1:${
              #   toString config.services.prometheus.exporters.postgres.port
              # }"
              "127.0.0.1:${
                toString config.services.prometheus.exporters.redis.port
              }"
              # "127.0.0.1:${
              # toString config.services.prometheus.exporters.restic.port
              # }"
              "127.0.0.1:${
                toString config.services.prometheus.exporters.statsd.port
              }"
              "127.0.0.1:${
                toString config.services.prometheus.exporters.smokeping.port
              }"
              # "127.0.0.1:${
              #   toString config.services.prometheus.exporters.blackbox.port
              # }"

            ];
          }];
        }];

        exporters = {
          node = {
            enable = true;
            enabledCollectors = [
              "systemd"
              "cpu"
              "diskstats"
              "filesystem"
              "loadavg"
              "meminfo"
              "netdev"
              "stat"
              "time"
            ];
          };
          ping = {
            enable = true;
            settings = {
              targets = [ "1.0.0.1" ];
              interval = "20s";
              timeout = "5s";
              history-size = "120";
              payload-size = "64";
            };
          };
          domain.enable = true;
          # postgres.enable = true;
          postgres.runAsLocalSuperUser = true;
          redis.enable = true;
          # restic.enable = true;
          statsd.enable = true;
          smokeping = {
            enable = true;
            hosts = [ "1.0.0.1" ];
          };
          # blackbox = {
          #   enable = true;
          #   configFile = builtins.toFile "blackbox.yml" ''
          #     modules:
          #       http_2xx:
          #         prober: http
          #         timeout: 5s
          #         http:
          #       http_post_2xx:
          #         prober: http
          #         timeout: 5s
          #         http:
          #           method: POST
          #           body_size_limit: 1MB
          #       tcp_connect:
          #         prober: tcp
          #         timeout: 5s
          #       pop3s_banner:
          #         prober: tcp
          #         tcp:
          #           query_response:
          #           - expect: "^+OK"
          #           tls: true
          #           tls_config:
          #             insecure_skip_verify: false
          #       ssh_banner:
          #         prober: tcp
          #         timeout: 5s
          #         tcp:
          #           query_response:
          #           - expect: "^SSH-2.0-"
          #       smtp_starttls:
          #         prober: tcp
          #         timeout: 5s
          #         tcp:
          #           query_response:
          #           - expect: "^220 "
          #           - send: "EHLO prober\r"
          #           - expect: "^250-STARTTLS"
          #           - send: "STARTTLS\r"
          #           - expect: "^220"
          #           - starttls: true
          #           - send: "EHLO prober\r"
          #           - expect: "^250-AUTH"
          #           - send: "QUIT\r"
          #       irc_banner:
          #         prober: tcp
          #         timeout: 5s
          #         tcp:
          #           query_response:
          #           - send: "NICK prober"
          #           - send: "USER prober prober prober :prober"
          #           - expect: "PING :([^ ]+)"
          #             send: "PONG ${1}"
          #           - expect: "^:[^ ]+ 001"
          #       icmp_test:
          #         prober: icmp
          #         timeout: 5s
          #         icmp:
          #           preferred_ip_protocol: ip4
          #       dns_test:
          #         prober: dns
          #         timeout: 5s
          #         dns:
          #           query_name: example.com
          #           preferred_ip_protocol: ip4
          #           ip_protocol_fallback: false
          #           validate_answer_rrs:
          #             fail_if_matches_regexp: [test]
          #       http_header_match_origin:
          #         prober: http
          #         timeout: 5s
          #         http:
          #           method: GET
          #           headers:
          #             Origin: example.com
          #           fail_if_header_not_matches:
          #           - header: Access-Control-Allow-Origin
          #             regexp: '(\*|example\.com)'
          #             allow_missing: false
          #   '';
          # };

          # zfs = {
          #   enable = true;
          #   listenAddress = "0.0.0.0";
          # };
          # nextcloud={
          #   enable=true;
          #   username="l";
          #   user="l";
          #   port="443";
          # };
        };
        # scrapeConfigs = [{
        #   job_name = "zfs";
        #   static_configs =
        #     [{ targets = [ "127.0.0.1:${toString cfg.port}" ]; }];
        # }];
      };
    };
    networking.firewall.interfaces."${config.link.service-interface}".allowedTCPPorts =
      mkIf cfg.expose-port [ cfg.port ];
  };
}
