{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.common;
in {
  options.link.common.enable = mkEnableOption "activate common";
  config = mkIf cfg.enable {
    programs.ssh.startAgent = false;
    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    environment.shellInit = ''
      export GPG_TTY="$(tty)"
      gpg-connect-agent /bye
      export SSH_AUTH_SOCK="/run/user/$UID/gnupg/S.gpg-agent.ssh"
    '';
    fonts = {
      packages = with pkgs;
        [
          league-of-moveable-type
          inter
          source-sans-pro
          source-serif-pro
          noto-fonts-emoji
          corefonts
          recursive
          iosevka-bin
          font-awesome
          line-awesome
          (nerdfonts.override { fonts = [ "FiraCode" ]; })
        ];
      fontDir.enable = true;
      fontconfig = {
        defaultFonts = {
          serif =
            [ "Berkeley Mono" "Inconsolata Nerd Font Mono" ];
          sansSerif =
            [ "Berkeley Mono" "Inconsolata Nerd Font Mono" ];
          monospace =
            [ "Berkeley Mono" "Inconsolata Nerd Font Mono" ];
          emoji = [ "Noto Color Emoji" ];
        };
      };
    };
    services.tlp.settings = {
      USB_AUTOSUSPEND = 0;
    };
    environment.noXlibs = false;
    environment.pathsToLink = [ "/share/zsh" ];
    link = {
      users = {
        l.enable = true;
        root.enable = true;
      };
      systemd-boot.enable = lib.mkDefault true;
      openssh.enable = lib.mkDefault true;
      # fail2ban.enable = lib.mkDefault true;
    };
    services.postgresql.package = pkgs.postgresql_14;
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
      # nftables.enable = true; # libvirt, docker and others use iptables
      networkmanager = {
        enable = true;
      };
      firewall = {
        enable = lib.mkDefault true;
        allowedUDPPorts = [
          51820 # wireguard
          53 # vpn
          1194 # vpn
          1195 # vpn
          1196 # vpn
          1197 # vpn
          1300 # vpn
          1301 # vpn
          1302 # vpn
          1303 # vpn
          1400 # vpn
        ];
        allowedTCPPorts = [
          80 # vpn
          443 # vpn
          1401 # vpn
        ];
      };
    };
    boot = {
      # plymouth = {
      #   enable = true;
      #   theme = "breeze";
      # };
      # initrd.systemd.enable = true;
      loader = {
        efi.canTouchEfiVariables = lib.mkDefault true;
      };
      tmp.cleanOnBoot = true;
      kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
      kernelParams = [ "quiet" "loglevel=3" ];
    };
    environment.systemPackages = with pkgs; [
      ## system
      font-awesome
      fira
      fira-code
      fira-code-symbols
      libsecret
      gnupg
      gpg-tui
      ## basics
      file
      killall
      trashy
      tmux
      ## encryption& filesystem
      sshfs
      nfs-utils
      cryptsetup
      gocryptfs
      age
      restic
      ## Network tools
      wget
      curl
      tree
      unzip
      gnutar
      xz
      bzip2
      p7zip
      rmlint
      gitFull
      fdupes
      # gitFull
      iptables
      nftables
      wireguard-tools
      dnsutils
    ];
    # console.font = "FiraCode Nerd Font";
  };
}
