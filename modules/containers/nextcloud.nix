{ lib, pkgs, config, ... }:
with lib;
let cfg = config.link.containers.nextcloud;
in {
  options.link.containers.nextcloud = {
    enable = mkEnableOption "activate nextcloud container";
  };
  config = mkIf cfg.enable {
    virtualisation.oci-containers.containers.nextcloud = {
      image = "nextcloud/all-in-one";
      # init = true;
      autoStart = true;
      # container_name = "nextcloud-aio-mastercontainer";
      volumes = [
        "nextcloud_aio_mastercontainer=/mnt/docker-aio-config"
        "/var/run/docker.sock=/var/run/docker.sock=ro"
      ];
      ports = [ "80:80" "8080:8080" "8443:8443" ];
      extraOptions = [ "/docker/nextcloud/data:/app/data:rw" ];
    };
  };
}
