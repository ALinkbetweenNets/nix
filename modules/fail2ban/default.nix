{ lib, pkgs, config, ... }:
with lib;
let cfg = config.link.fail2ban;
in {
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
        "8.8.8.8"
        "9.9.9.9"
      ];
      bantime = "24h"; # Set bantime to one day
      bantime-increment = {
        enable = true; # Enable increment of bantime after each violation
        # formula = "ban.Time * math.exp(float(ban.Count+1)*banFactor)/math.exp(1*banFactor)";
        multipliers = "1 2 4 8 16 32 64";
        maxtime = "168h"; # Do not ban for more than 1 week
        overalljails = true; # Calculate the bantime based on all the violations
      };
      jails = {
        ngnix-url-probe = ''
          enabled = true
          filter = nginx-url-probe
          logpath = /var/log/nginx/access.log
          action = %(action_)s[blocktype=DROP]
                   ntfy
          backend = auto # Do not forget to specify this if your jail uses a log file
          maxretry = 5
          findtime = 600
        '';
      };
    };
    environment.etc = {
      # Define an action that will trigger a Ntfy push notification upon the issue of every new ban
      # "fail2ban/action.d/ntfy.local".text = pkgs.lib.mkDefault (pkgs.lib.mkAfter ''
      #   [Definition]
      #   norestored = true # Needed to avoid receiving a new notification after every restart
      #   actionban = curl -H "Title: <ip> has been banned" -d "<name> jail has banned <ip> from accessing $(hostname) after <failures> attempts of hacking the system." https://ntfy.sh/Fail2banNotifications
      # '');
      # Defines a filter that detects URL probing by reading the Nginx access log
      "fail2ban/filter.d/nginx-url-probe.local".text = pkgs.lib.mkDefault (pkgs.lib.mkAfter ''
        [Definition]
        failregex = ^<HOST>.*(GET /(wp-|admin|boaform|phpmyadmin|\.env|\.git)|\.(dll|so|cfm|asp)|(\?|&)(=PHPB8B5F2A0-3C92-11d3-A3A9-4C7B08C10000|=PHPE9568F36-D428-11d2-A769-00AA001ACF42|=PHPE9568F35-D428-11d2-A769-00AA001ACF42|=PHPE9568F34-D428-11d2-A769-00AA001ACF42)|\\x[0-9a-zA-Z]{2})
      '');
    };
  };
}
