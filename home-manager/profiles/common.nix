{ lib, pkgs, flake-self, system-config, ... }:
with lib; {
  options.link.options = {
    type = mkOption {
      type = types.enum [ "desktop" "laptop" "server" ];
      default = system-config.link.options.type;
      example = "server";
    };
  };
  imports = with flake-self.homeManagerModules; [ neovim shell git ];
  config = {
    home.sessionVariables = { EDITOR = "nvim"; };
    services.gpg-agent = {
      enable = true;
      enableExtraSocket = true;
      enableSshSupport = true;
    };
    programs.ssh = {
      enable = true;
      forwardAgent = true;
      matchBlocks = {
        "nc" = { port = 2522; };
        "sn" = { port = 2522; };
        "dn" = { port = 2522; };
        "xn" = { port = 2522; };
        "pi4b" = { port = 2522; };
        "pppn" = { port = 2522; };
        "npn" = { port = 2522; };
        "fn" = { port = 2522; };
        "10.5.5.1" = { port = 2522; };
        "10.5.5.5" = { port = 2522; };
        "10.5.5.6" = { port = 2522; };
        "c" = { port = 2522; };
        "f" = { port = 2522; };
        "n" = { port = 2522; };
        "s" = { port = 2522; };
      };
      compression = true;
    };
    home.packages = with pkgs;
      [
        xcp
        dysk
        git-crypt
        yazi # TUI File Manager with preview
        nix-output-monitor
        gpg-tui
        cht-sh
        # fastfetch
        # tldr
        #home-manager
        ## security
        sops
        ssh-to-age
        # bitwarden-cli
        ## piping
        # vgrep
        ## basics
        # gitFull
        ## networking
        # iptables
        # nftables
        ## Networking+
        ipfetch
        # magic-wormhole # Secure data transfer
        # iperf3 # speedtest
        crab_share
        jdupes # duplicate Finder, better fdupes
        rmlint
      ] ++ lib.optionals
      (system-config.nixpkgs.hostPlatform.system == "x86_64-linux") [ ];
    # Home-manager nixpkgs config
    nixpkgs = {
      # Allow "unfree" licenced packages
      config.allowUnfree = true;
      overlays = [
        flake-self.overlays.default
        flake-self.inputs.bonn-mensa.overlays.default
      ];
    };
    home = {
      # This value determines the Home Manager release that your
      # configuration is compatible with. This helps avoid breakage
      # when a new Home Manager release introduces backwards
      # incompatible changes.
      #
      # You can update Home Manager without changing this value. See
      # the Home Manager release notes for a list of state version
      # changes in each release.
      stateVersion = "23.11";
    };
    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
  };
}
