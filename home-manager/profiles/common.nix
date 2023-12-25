{ lib, pkgs, flake-self, system-config, ... }:
with lib; {
  options.link.options = {
    type = mkOption {
      type = types.enum [ "desktop" "laptop" "server" ];
      default = system-config.link.options.type;
      example = "server";
    };
  };
  imports = with flake-self.homeManagerModules; [
    neovim
    shell
    git
  ];
  config = {
    home.sessionVariables = {
      EDITOR = "nvim";
    };
    services.gpg-agent = {
      enable = true;
      enableExtraSocket = true;
      enableSshSupport = true;
    };
    fonts.fontconfig.enable = true;
    home.packages = with pkgs;
      [
        #home-manager
        s-tui
        apg # generate passwords
        xkcdpass
        sops
        ssh-to-age
        bitwarden-cli
        wcalc
        gnugrep
        ripgrep-all
        vgrep
        fzf
        glances
        unixtools.watch
        # gitFull
        iptables
        nftables
        wireguard-tools
        dnsutils
        ## Networking+
        ipfetch
        magic-wormhole # Secure data transfer
        netcat-openbsd
        crab_share
      ] ++ lib.optionals
        (system-config.nixpkgs.hostPlatform.system == "x86_64-linux") [ ];
    # Home-manager nixpkgs config
    nixpkgs = {
      # Allow "unfree" licenced packages
      config = {
        allowUnfree = true;
        permittedInsecurePackages = [ "electron-25.9.0" ];
      };
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
