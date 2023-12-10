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
    # neovim
    # zsh
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
        ## Networking+
        ipfetch
        magic-wormhole # Secure data transfer
        netcat-openbsd
        socat
        tcpdump
        crab_share
        (pkgs.nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
      ] ++ lib.optionals
        (system-config.nixpkgs.hostPlatform.system == "x86_64-linux") [ ];
    programs = {
      # ssh = {
      #   enable = true;
      #   #compression=true;
      # };
      nix-index = {
        enable = true;
      };
      lf = { enable = true; };
      lesspipe = { enable = true; };
      yt-dlp = {
        enable = true;
        extraConfig = "--update";
        settings = { embed-thumbnail = true; };
      };
      direnv = {
        enable = true;
        enableBashIntegration = true;
        enableZshIntegration = true;
        nix-direnv.enable = true;
      };
    };
    # Home-manager nixpkgs config
    nixpkgs = {
      # Allow "unfree" licenced packages
      config = { allowUnfree = true; };
      overlays = [ ];
    };
    # Include man-pages
    manual.manpages.enable = true;
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
