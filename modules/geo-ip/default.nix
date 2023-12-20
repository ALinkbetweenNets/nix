{ config, lib, pkgs, ... }:
with lib;
let cfg = config.paul.nginx; in
{
  # NGINX Snippet
  #  extraConfig = toString (
  #       optional config.paul.nginx.geoIP ''
  #         if ($allowed_country = no) {
  #             return 444;
  #         }
  #       ''
  #     );

  options.paul.nginx = {
    geoIP = mkEnableOption "enable GeoIP";
  };

  config = mkIf cfg.geoIP {

    # when Nginx is enabled, enable the GeoIP updater service
    services.geoipupdate = mkIf cfg.enable {
      enable = true;
      interval = "weekly";
      settings = {
        EditionIDs = [ "GeoLite2-Country" ];
        # TODO: set AccountID and create a license key file
        AccountID = 12345;
        LicenseKey = "/var/maxmind_license_key";
        DatabaseDirectory = "/var/lib/GeoIP";
      };
    };

    # build nginx with geoip2 module
    services.nginx = {
      package = pkgs.nginxStable.override (oldAttrs: {
        modules = with pkgs.nginxModules; [ geoip2 ];
        buildInputs = oldAttrs.buildInputs ++ [ pkgs.libmaxminddb ];
      });
      appendHttpConfig = toString (
        [
          # we want to load the geoip2 module in our http config, pointing to the database we are using
          # country iso code is the only data we need
          ''
            geoip2 ${config.services.geoipupdate.settings.DatabaseDirectory}/GeoLite2-Country.mmdb {
              $geoip2_data_country_iso_code country iso_code;
            }
          ''
          # we want to allow only requests from specific countries
          # if a request is not from such a country, we return no, which will result in a 403
          ''
            map $geoip2_data_country_iso_code $allowed_country {
              default no;
              DE yes;
              ES yes;
              FR yes;
              GB yes;
              IT yes;
              NL yes;
            }
          ''
        ]
      );
    };

  };
}
