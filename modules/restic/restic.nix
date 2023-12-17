{ lib, pkgs, config, ... }:
with lib;
let cfg = config.link.services.restic-client;
in
{
  options.link.services.restic-client = {
    enable = mkEnableOption "restic backups";
    backup-paths-storagebox = mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = [ "/var/lib/gitea" ];
      description = "Paths to backup to storagebox";
    };
    backup-paths-sn = mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = [ "/var/lib/gitea" ];
      description = "Paths to backup to sn";
    };
    backup-paths-rsn = mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = [ "/var/lib/gitea" ];
      description = "Paths to backup to rsn";
    };
    backup-paths-exclude = mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = [ "/home/link/.cache" ];
      description = "Paths to exclude from backup";
    };
  };
  config = mkIf cfg.enable {
    sops.secrets = {
      "restic/storagebox/repository" = { };
      "restic/storagebox/password" = { };
      "restic/sn/repository" = { };
      "restic/sn/password" = { };
      "restic/sn/environment" = { };
    };
    users.users.restic.isNormalUser = true;
    security.wrappers.restic = {
      source = "${pkgs.restic.out}/bin/restic";
      owner = "restic";
      group = "users";
      permissions = "u=rwx,g=,o=";
      capabilities = "cap_dac_read_search=+ep";
    };
    services.restic.backups =
      let
        # host = config.networking.hostName;
        # script-post = host: site: ''
        #   if [ $EXIT_STATUS -ne 0 ]; then
        #     ${pkgs.curl}/bin/curl -u $NTFY_USER:$NTFY_PASS \
        #     -H 'Title: Backup (${site}) on ${host} failed!' \
        #     -H 'Tags: backup,restic,${host},${site}' \
        #     -d "Restic (${site}) backup error on ${host}!" 'https://push.pablo.tools/link_backups'
        #   else
        #     ${pkgs.curl}/bin/curl -u $NTFY_USER:$NTFY_PASS \
        #     -H 'Title: Backup (${site}) on ${host} successful!' \
        #     -H 'Tags: backup,restic,${host},${site}' \
        #     -d "Restic (${site}) backup success on ${host}!" 'https://push.pablo.tools/link_backups'
        #   fi
        # '';
        restic-ignore-file = pkgs.writeTextFile {
          name = "restic-ignore-file";
          text = builtins.concatStringsSep "\n" cfg.backup-paths-exclude;
        };
      in
      {
        storagebox = {
          paths = cfg.backup-paths-storagebox;
          repositoryFile = config.sops.secrets."restic/storagebox/repository".path;
          passwordFile = config.sops.secrets."restic/storagebox/password".path;
          # environmentFile = "${config.sops.secrets."restic/backblaze-credentials".path}";
          # backupCleanupCommand = script-post config.networking.hostName "storagebox";
          pruneOpts = [
            "--keep-daily 7"
            "--keep-weekly 5"
            "--keep-monthly 12"
            "--keep-yearly 75"
          ];
          timerConfig = {
            OnCalendar = "03:00";
            Persistent = true;
            RandomizedDelaySec = "5h";
          };
          extraBackupArgs = [
            "--exclude-file=${restic-ignore-file}"
            "--one-file-system"
            "--compression=max"
            # "--dry-run"
            "-v"
          ];
          initialize = true;
        };
        sn = {
          paths = cfg.backup-paths-sn;
          repositoryFile = config.sops.secrets."restic/sn/repository".path;
          passwordFile = config.sops.secrets."restic/sn/password".path;
          environmentFile = config.sops.secrets."restic/sn/environment".path;
          pruneOpts = [
            "--keep-daily 7"
            "--keep-weekly 5"
            "--keep-monthly 12"
            "--keep-yearly 75"
          ];
          timerConfig = {
            OnCalendar = "03:00";
            Persistent = true;
            RandomizedDelaySec = "5h";
          };
          extraBackupArgs = [
            "--exclude-file=${restic-ignore-file}"
            "--one-file-system"
            "--compression=max"
            # "--dry-run"
            "-v"
          ];
          initialize = true;
        };
        # s3-onsite = {
        #   paths = cfg.backup-paths-onsite;
        #   repository = "s3:https://vpn.s3.pablo.tools/restic";
        #   environmentFile = "${config.sops.secrets."restic/credentials".path}";
        #   passwordFile = "${config.sops.secrets."restic/repo-pw".path}";
        #   backupCleanupCommand = script-post config.networking.hostName "NAS";

        #   extraBackupArgs = [
        #     "--exclude-file=${restic-ignore-file}"
        #     "--one-file-system"
        #     # "--dry-run"
        #     "-vv"
        #   ];
        # };
      };
  };
}
