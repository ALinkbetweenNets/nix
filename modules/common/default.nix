{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.common;
in {
  options.link.common.enable = mkEnableOption "activate common";
  config = mkIf cfg.enable {
    fonts.packages = with pkgs;
      [ (nerdfonts.override { fonts = [ "FiraCode" ]; }) ];
    environment.systemPackages = with pkgs; [
      ## system
      font-awesome
      dbus
      libsecret
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
    environment.pathsToLink = [ "/share/zsh" ];
    link = {
      users = {
        l.enable = true;
        root.enable = true;
      };
      systemd-boot.enable = lib.mkDefault true;
      openssh.enable = lib.mkDefault true;
    };
    security = {
      sudo.wheelNeedsPassword = false;
      # polkit = {
      #   enable = true;
      #   adminIdentities = [ "unix-user:l" "unix-user:root" ];
      # };
      apparmor.enable = true;
      # security.tpm2.enable = true;
      # security.tpm2.abrmd.enable = true;
      auditd.enable = true;
    };
    services = {
      fail2ban = {
        enable = true;
        maxretry = 5;
        bantime-increment.enable = true;
      };
    };
    networking = {
      # nftables.enable = true; # libvirt, docker and others use iptables
      networkmanager = {
        enable = true;
        appendNameservers = [
          "1.1.1.1"
          "192.168.178.1"
          "9.9.9.9"
          "216.146.35.35"
          "2620:fe::fe"
          "2606:4700:4700::1111"
        ];
      };
      firewall = {
        enable = lib.mkDefault true;
        allowedTCPPorts = [ 8384 22000 ]; # syncthing
        allowedUDPPorts = [
          22000 # syncthing
          21027 # syncthing
          51820 # wireguard
        ];
      };
    };
    boot = {
      # plymouth = {
      #   enable = true;
      #   theme = "breeze";
      # };
      initrd.systemd.enable = true;
      loader = {
        efi.canTouchEfiVariables = true;
      };
      tmp.cleanOnBoot = true;
      kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
      kernelParams = [ "quiet" "loglevel=3" ];
    };
    # programs.gnupg.agent = {
    #   enable = true;
    #   enableSSHSupport = true;
    # };
    # console.font = "FiraCode Nerd Font";
  };
}
