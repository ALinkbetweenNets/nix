{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.link.fail2ban;
in
{
  options.link.fail2ban = {
    enable = mkEnableOption "activate fail2ban";
  };
  config = mkIf cfg.enable {
    services.fail2ban = {
      enable = true;
      maxretry = 5;
      ignoreIP = [
        "192.168.0.0/16"
        "1.1.1.1"
        "1.0.0.1"
        "8.8.8.8"
        "9.9.9.9"
        "100.64.0.0/10"
        "93.192.0.0/10" # telekom
      ];
      # bantime = "24h"; # Set bantime to one day
      bantime-increment = {
        enable = true; # Enable increment of bantime after each violation
        # formula = "ban.Time * math.exp(float(ban.Count+1)*banFactor)/math.exp(1*banFactor)";
        # multipliers = "1 2 4 8 16 32 64";
        rndtime = "5m";
        factor = "8";
        overalljails = true; # Calculate the bantime based on all the violations
      };
      jails = mkIf config.link.nginx.enable {
        nginx-bad-request.settings ={
          enabled = true;
          filter = "nginx-bad-request";
        };
        nginx-botsearch.settings ={
          enabled = true;
          filter = "nginx-botsearch";
        };
        nginx-error-common.settings ={
          enabled = true;
          filter = "nginx-error-common";
        };
        nginx-forbidden.settings ={
          enabled = true;
          filter = "nginx-forbidden";
        };
        nginx-http-auth.settings ={
          enabled = true;
          filter = "nginx-http-auth";
        };
        # nginx-limit-req.settings ={
        #   enabled = true;
        #   filter = "nginx-limit-req";
        # };
        nginx-url-probe.settings ={
          enabled = true;
          filter = "nginx-url-probe";
        };
        # ngnix-url-probe = ''
        #   enabled = true
        #   port     = http,https
        #   filter = nginx-url-probe
        #   logpath = /var/log/nginx/access.log
        #   action = %(action_)s[blocktype=DROP]
        #   maxretry = 5
        #   findtime = 600
        # '';
        # nginx-http-auth = ''
        #   enabled  = true
        #   port     = http,https
        #   logpath  = /var/log/nginx/*.log
        #   backend  = polling
        #   journalmatch =
        # '';
        # nginx-botsearch = ''
        #   enabled  = true
        #   port     = http,https
        #   logpath  = /var/log/nginx/*.log
        #   backend  = polling
        #   journalmatch =
        # '';
        # nginx-bad-request = ''
        #   enabled  = true
        #   port     = http,https
        #   logpath  = /var/log/nginx/*.log
        #   backend  = polling
        #   journalmatch =
        # '';
      };
    };
    environment.etc = mkIf config.link.nginx.enable {
      # Define an action that will trigger a Ntfy push notification upon the issue of every new ban
      # "fail2ban/action.d/ntfy.local".text = pkgs.lib.mkDefault (pkgs.lib.mkAfter ''
      #   [Definition]
      #   norestored = true # Needed to avoid receiving a new notification after every restart
      #   actionban = curl -H "Title: <ip> has been banned" -d "<name> jail has banned <ip> from accessing $(hostname) after <failures> attempts of hacking the system." https://ntfy.sh/Fail2banNotifications
      # '');
      # Defines a filter that detects URL probing by reading the Nginx access log
      "fail2ban/filter.d/nginx-url-probe.local".text = pkgs.lib.mkDefault (
        pkgs.lib.mkAfter ''
          [Definition]
          failregex = ^<HOST>.*(GET /(wp-|admin|boaform|phpmyadmin|\.env|\.git)|\.(dll|so|cfm|asp)|(\?|&)(=PHPB8B5F2A0-3C92-11d3-A3A9-4C7B08C10000|=PHPE9568F36-D428-11d2-A769-00AA001ACF42|=PHPE9568F35-D428-11d2-A769-00AA001ACF42|=PHPE9568F34-D428-11d2-A769-00AA001ACF42)|\\x[0-9a-zA-Z]{2})
        ''
      );
    };
  };
}
