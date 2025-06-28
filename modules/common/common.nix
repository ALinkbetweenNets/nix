{ config, system-config, pkgs, lib, nix-index-database, ... }:
with lib;
let cfg = config.link.common;
in {
  imports = [ nix-index-database.nixosModules.nix-index ];
  options.link.common.enable = mkEnableOption "activate common";
  config = mkIf cfg.enable {
    programs = {
      ssh = {
        startAgent = lib.mkDefault false;
        # agentTimeout = "1h";
        knownHosts = {
          dn = {
            hostNames = [ "dn.monitor-banfish.ts.net" ];
            publicKey =
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINI74luZ3xJcgaZYHzn5DtSpYufml+SbhZQV12gWGShS";
          };
          xn = {
            hostNames = [ "xn.monitor-banfish.ts.net" ];
            publicKey =
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOTI6IEjHQbsbMJMBQNk0/BR7W4QFVQLNOrhEdTHwS1P";
          };
          pi4b = {
            hostNames = [ "pi4b.monitor-banfish.ts.net" ];
            publicKey =
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO+rwC7YNUlQ7i2285iCVnopN2RXo/rBE8fAObogjoBc";
          };
          sn = {
            hostNames = [ "sn.monitor-banfish.ts.net" ];
            publicKey =
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMN0npgyMxdnljCmUdZD5sZURtYXUjtNqf1236CEwrB";
          };
        };
      };
      nh = {
        enable = true;
        flake = "/home/l/nix/";
        clean.enable=true;
      };
      gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
        # pinentryFlavor = if config.link.plasma.enable then "qt" else "gnome3";
      };
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
      users = {
        l.enable = true;
        root.enable = true;
      };
      # systemd-boot.enable = lib.mkDefault true;
      openssh.enable = lib.mkDefault true;
      # nftables.enable = lib.mkDefault true;
      # fail2ban.enable = lib.mkDefault true;
    };
    services.postgresql.package = pkgs.postgresql_16; # prevent major upgrades
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
    # services.connman.wifi.backend = "iwd";
    networking = {
      #   networkmanager.wifi.backend = "iwd";
      #   wireless.iwd = {
      #     enable = true;
      #     settings = {
      #       General.EnableNetworkConfiguration = true;
      #       Settings.AutoConnect = true;
      #       Network.EnableIPv6 = true;
      #     };
      #   };
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
    # Use nix-index-database for comma
    programs.nix-index-database.comma.enable = true;
    environment.systemPackages = with pkgs; [
      ## system
      limitcpu
      exfatprogs
      libsecret
      gnupg
      ## top
      s-tui
      glances
      nethogs
      kmod # modprobe
      ## basics
      # gitFull
      file
      killall
      trashy
      tmux
      zellij
      ## encryption& filesystem
      cryptsetup
      gocryptfs
      # cryfs
      age
      ## Network tools
      wget
      curl
      tree
      ## FS Tools
      # unzip
      # gnutar
      # xz
      # bzip2
      p7zip
      # netcat
      # netcat-gnu
      fzf
      gnugrep
      unixtools.watch
      wireguard-tools
      dnsutils
      fd
      ncdu # disk usage
      sysz
      systemctl-tui
      eza
      bat
      btop
    ];
    # console.font = "FiraCode Nerd Font";
    #   system.replaceRuntimeDependencies =
    #   let
    #     fixed-xz = (import
    #       (builtins.fetchGit {
    #         name = "xz-5-4-4";
    #         url = "https://github.com/NixOS/nixpkgs/";
    #         ref = "refs/heads/nixpkgs-unstable";
    #         rev = "9957cd48326fe8dbd52fdc50dd2502307f188b0d";
    #       })
    #       { system = "${pkgs.system}"; }).xz;
    #   in
    #   [
    #     ({
    #       original = pkgs.xz;
    #       replacement = fixed-xz;
    #     })
    #   ];
  };
}
