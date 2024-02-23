{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.common;
in {
  options.link.common.enable = mkEnableOption "activate common";
  config = mkIf cfg.enable {
    programs.ssh.startAgent = lib.mkDefault false;
    programs.ssh.extraConfig = ''
      Host deepserver
        Port 2522
    '';
    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryFlavor = if config.link.plasma.enable then "qt" else "gnome3";
    };

    environment.shellInit = ''
      export GPG_TTY="$(tty)"
      gpg-connect-agent /bye
      export SSH_AUTH_SOCK="/run/user/$UID/gnupg/S.gpg-agent.ssh"
    '';
    # Does not seem to work
    # services.tlp.settings = {
    #   USB_AUTOSUSPEND = 0;
    # };
    environment.pathsToLink = [ "/share/zsh" "/share/fish" ];
    link = {
      # fs.luks.enable = true;
      users = {
        l.enable = true;
        root.enable = true;
      };
      # systemd-boot.enable = lib.mkDefault true;
      openssh.enable = lib.mkDefault true;
      # nftables.enable = lib.mkDefault true;
      # fail2ban.enable = lib.mkDefault true;
    };
    services.postgresql.package = pkgs.postgresql_14; # prevent major upgrades
    security = {
      sudo.wheelNeedsPassword = lib.mkDefault false;
      # polkit = {
      #   enable = true;
      #   adminIdentities = [ "unix-user:l" "unix-user:root" ];
      # };
      # apparmor.enable = true;
      # security.tpm2.enable = true;
      # security.tpm2.abrmd.enable = true;
      # auditd.enable = true;
    };
    networking = {
      firewall = {
        enable = lib.mkDefault true;
        allowedUDPPorts = [
          51820 # wireguard
          53 # dnsmasq
          # 1194 # vpn
          # 1195 # vpn
          # 1196 # vpn
          # 1197 # vpn
          # 1300 # vpn # are you sure about those?
          # 1301 # vpn
          # 1302 # vpn
          # 1303 # vpn
          # 1400 # vpn
        ];
        allowedTCPPorts = [
          53 # dnsmasq
          # 80 # vpn
          # 443 # vpn
          # 1401 # vpn
        ];
      };
    };
    environment.systemPackages = with pkgs; [
      ## system
      exfatprogs
      git-crypt
      libsecret
      gnupg
      gpg-tui
      sshfs
      ## basics
      gitFull
      file
      killall
      trashy
      tmux
      zellij
      ## encryption& filesystem
      cryptsetup
      gocryptfs
      cryfs
      age
      ## Network tools
      wget
      curl
      tree
      ## FS Tools
      unzip
      gnutar
      xz
      bzip2
      p7zip
      ## duplicate Finder
      rmlint
      fdupes
    ];
    # console.font = "FiraCode Nerd Font";
  };
}
